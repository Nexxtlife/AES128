-- this is a temporary working file 
-- need to implement a fifo for master read ( i think)
-- detect if fifo is full or empty
-- read from fifo must be controlled

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity interface_controller is
  generic (
    INTERFACE_WIDTH : integer := 8; -- change in tcl file [8,16,32]
    INTERFACE_LENGTH : natural := 1; -- change in tcl file [0-n]
    INTERFACE_ADDR_WIDTH : natural := 3;
  );
  port (
    clk, rst : in std_logic;
	
	-- control & status registers (CSR) slave
	interface_0_avalon_slave_1_read          : in std_logic;
	interface_0_avalon_slave_1_write         : in std_logic;
	interface_0_avalon_slave_1_waitrequest   : out std_logic;  
	interface_0_avalon_slave_1_address       : in std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                  -- address
	interface_0_avalon_slave_1_byteenable    : in std_logic_vector(INTERFACE_BYTE_ENABLE - 1 downto 0);                 -- byteenable
	interface_0_avalon_slave_1_readdata      : out  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	interface_0_avalon_slave_1_writedata     : out  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	
	interface_0_avalon_streaming_source_data  : out std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                -- data st
	interface_0_avalon_streaming_source_ready : in  std_logic                      := 'X';             					-- ready st
	interface_0_avalon_streaming_source_valid : out std_logic															-- valid st
  
  );
end interface_controller;


architecture behave of interface_controller is

subtype word_t is std_logic_vector(INTERFACE_WIDTH - 1  downto 0);
type register_t is array(integer range <>) of word_t;


-- state machine states
type read_states_T is (idle, running, stopping);
type write_states_T is (idle, running);
type data_states is (first, second, third, fourth);
signal data_state : data_states;
signal read_state : read_states_T;
signal write_state : write_states_T;


-- extra read master signals
signal slave_read_address : std_logic_vector (INTERFACE_ADDR_WIDTH - 1 downto 0);         -- the current read address
signal slave_words_read : std_logic_vector (8 downto 0);            					   -- tracks the words read
-- extra write master signals
signal master_write_address : std_logic_vector (INTERFACE_ADDR_WIDTH - 1 downto 0);        -- the current write address



--CSR initial values
function init_csr
  return register_t is
  variable temp: register_t(INTERFACE_LENGTH - 1 downto 0);
  begin
	--entire table set to '0'
    temp := (others => (others => '0'));
    return temp;
  end init_csr;

signal csr_reg: register_t := init_csr;

-- aliasy do obszarów w csr
alias status_reg:   std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(0);
alias control_reg:  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(1);
alias csr_rd_addr:  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(2); -- the read start address register
alias csr_key_addr:  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(3); -- the write start address register
--alias key_reg:      register_t(31 downto 0)                   is csr_reg(33 downto 2);

-- aliasy do bitów w obrzarach
alias csr_status : std_logic_vector is status_reg(0);           -- the status word that will be read from the status register
alias csr_go_flag : std_logic_vector is control_reg(1);         -- used to start the DMA (when logic 1)
alias active_flag : std_logic_vector is control_reg(2);         -- logic 1 if either state machines are active
alias csr_stream : std_logic_vector is control_reg(3);         -- logic 1 if either state machines are active
alias csr_read : std_logic_vector is control_reg(4);         -- logic 1 if either state machines are active
alias engaged : std_logic_vector is control_reg(5);         -- if 1 then controller is busy

signal out_waitrequest : std_logic;

begin
-------------------------------------------------------------------------------
-- THE READ SLAVE STATE MACHINE
-------------------------------------------------------------------------------
--something will be here


-------------------------------------------------------------------------------
-- THE READ MASTER FIFO STATE MACHINE
-------------------------------------------------------------------------------
--element responsible for getting new values from fifo when the controller isnt doing anything
-- check if fifo is empty then dont read
-- what to read from jtag (address of data to cypher, address of key, csr controll statement)
-- divide the data.
read_master_fifo: process (clk, rst)
begin
	if rst = '1' then
		master_read_state <= idle;
		master_read_address <= (others => '0');
		master_words_read <= (others => '0');
	elsif rising_edge (clk) then

		case master_read_state is
			
			when idle =>
				if engaged = '0' then
					master_fifo_read_state <= running;
					interface_0_avalon_master_fifo_1_read <= '1';
				end if;
				
			when running =>
				engaged => 1;
				case control_reg is
				when "00" =>
					control_reg <= interface_0_avalon_master_1_fifo_readdata;
				when "10" =>
					csr_key_addr <= interface_0_avalon_master_1_fifo_readdata;
				when "11" =>
					csr_rd_addr <= interface_0_avalon_master_1_fifo_readdata;
				when others =>
				end case;
				master_fifo_read_state <= stopping;
				
			when stopping =>
				csr_go_flag <= '1';
				master_fifo_read_state <= idle;
		
		end case;
	end if;
end process;

-------------------------------------------------------------------------------
-- THE READ SLAVE STATE MACHINE
-------------------------------------------------------------------------------

read_master: process (clk, rst)
begin
	if rst = '1' then
		master_read_state <= idle;
		master_read_address <= (others => '0');
		
	elsif rising_edge (clk) then
		case master_read_state is
		
			when idle =>
					interface_0_avalon_master_1_readdata
				if master_write_state = idle and csr_go_flag = '1' then
					data_state <= first;
					master_read_state <= running;			
					master_read_address <= csr_rd_addr;
				end if;
	
			when running =>			
				if data_state = first then
					data_for_AES(127 downto 96) <= interface_0_avalon_master_1_readdata;
					master_read_address <= master_read_address + 32;
					data_state <= second;
				elsif data_state = second then
					data_for_AES(95 downto 64) <= interface_0_avalon_master_1_readdata;
					master_read_address <= master_read_address + 32;
					data_state <= third;
				elsif data_state = third then
					data_for_AES(63 downto 32) <= interface_0_avalon_master_1_readdata;
					master_read_address <= master_read_address + 32;
					data_state <= fourth;
				elsif data_state = fourth then
					data_for_AES(31 downto 0) <= interface_0_avalon_master_1_readdata;
					master_read_state <= stopping;
				end if;
				
				
			when stopping =>				
				master_read_state <= idle;
		
		end case;
	end if;
end process;

-------------------------------------------------------------------------------
-- THE WRITE MASTER STATE MACHINE
-------------------------------------------------------------------------------

write_master: process (clk, rst)
begin
	if rst = '1' then
		write_state <= idle;
	elsif rising_edge (clk) then


		case master_write_state is

			when idle =>
				if csr_go_flag = '1' then
					master_write_state <= running;
					master_write_address <= csr_wr_addr;
				end if;
			when running =>
				--write stuff
				
				if master_read_state = idle then
					master_write_state <= idle;
				end if;			
		end case;
	end if;
end process;
-------------------------------------------------------------------------------
-- CSR PROCESS
-------------------------------------------------------------------------------

csr: process (clk, rst)
begin
	if rst = '1' then
		csr_rd_addr <= (others => '0');
		csr_wr_addr <= (others => '0');
	elsif rising_edge (clk) then
		if csr_status = '1' then
			case control_reg is
				when "10" =>
					--asd
				when "11" =>

				when others =>
			end case;
		end if;
	end if;
end process;	


  out_waitrequest_proc: process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        out_waitrequest <= '1';
      else
        -- reset sygnału waitrequest
        if csr_write = '1' or csr_read = '1' then
          out_waitrequest <= '0';
        end if;

        -- ponowne ustawienie waitrequest po pojedynczym transferze
        if out_waitrequest = '0' and (csr_write = '1' or csr_read = '1') then
          out_waitrequest <= '1';
        end if;

      end if;
    end if;
  end process out_waitrequest_proc; 
end architecture behave;
