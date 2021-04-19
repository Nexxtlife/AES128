-- this is a temporary working file
-- need to implement a fifo for master read ( i think)
-- constantly listening slave needs a fifo

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
	
	interface_0_avalon_master_1_read          : out std_logic; 
	interface_0_avalon_master_1_write         : out std_logic;  	
	interface_0_avalon_master_1_waitrequest   : in std_logic;  
	interface_0_avalon_master_1_address       : out std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                -- address
	interface_0_avalon_master_1_byteenable    : out std_logic_vector(INTERFACE_BYTE_ENABLE - 1 downto 0);               -- byteenable
	interface_0_avalon_master_1_readdata      : out  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X');  -- readdata
	interface_0_avalon_master_1_writedata     : in std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	
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
type master_read_states_T is (idle, running, stopping);
type master_write_states_T is (idle, running);
signal master_read_state : read_states_T;
signal master_write_state : write_states_T;


-- extra read master signals
signal master_read_address : std_logic_vector (INTERFACE_ADDR_WIDTH - 1 downto 0);         -- the current read address
signal master_words_read : std_logic_vector (8 downto 0);            					   -- tracks the words read
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
alias csr_wr_addr:  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(3); -- the write start address register
--alias key_reg:      register_t(31 downto 0)                   is csr_reg(33 downto 2);

-- aliasy do bitów w obrzarach
alias csr_status : std_logic_vector is status_reg(0);           -- the status word that will be read from the status register
alias csr_go_flag : std_logic_vector is control_reg(1);         -- used to start the DMA (when logic 1)
alias active_flag : std_logic_vector is control_reg(2);         -- logic 1 if either state machines are active
alias csr_write : std_logic_vector is control_reg(3);         -- logic 1 if either state machines are active
alias csr_read : std_logic_vector is control_reg(4);         -- logic 1 if either state machines are active

	-- control & status registers (CSR) slave
	--avs_csr_address : in std_logic_vector (1 downto 0);
	--avs_csr_readdata : out std_logic_vector (31 downto 0);
	--avs_csr_write : in std_logic;
	--avs_csr_writedata : in std_logic_vector (31 downto 0)

signal out_waitrequest : std_logic;
-- ----------------------------------------------------------------------------
-- BEGIN
-- ----------------------------------------------------------------------------
begin
-------------------------------------------------------------------------------
-- THE READ SLAVE STATE MACHINE
-------------------------------------------------------------------------------
read_slave: process (clk, rst)
begin
	if rst = '1' then
		interface_0_avalon_slave_1_waitrequest

end process; 

-------------------------------------------------------------------------------
-- THE READ MASTER STATE MACHINE
-------------------------------------------------------------------------------

read_master: process (clk, rst)
begin
	if rst = '1' then
		master_read_state <= idle;
		master_read_address <= (others => '0');
		master_words_read <= (others => '0');
	elsif rising_edge (clk) then

		case master_read_state is
			
			-- IDLE
			-- When idle just sit and wait for the go flag.
			-- Only start if the write state machine is idle as it may be
			-- finishing a previous data transfer.
			-- Start the machine by moving to the running state and initialising address and counters.
			when idle =>
				if master_write_state = idle and csr_go_flag = '1' then
					master_read_state <= running;
					master_read_address <= csr_rd_addr;
					master_words_read <= (others => '0');
				end if;
				
			-- RUNNING
			-- Count reads, inc address and check for completion
			-- The read signal is held inactive by comb logic if fifo full so do nothing if fifo full
			-- also do nothing if waitrequest is active as this means signals need to be held
			when running =>
				-- if waitrequest is active or fifo full do nothing, otherwise...
				if avm_read_master_waitrequest /= '1' and fifo_full /= '1' then
					master_read_address <= master_read_address + (INTERFACE_ADDR_WIDTH/8);  -- add addres_width/8 per word as masters use byte addressing					
					master_words_read <= master_words_read + 1;
					if master_words_read = 255 then  -- 256 in total (255 previous plus this one)
						master_read_state <= stopping;
					end if;	
				end if;
				
			-- STOPPING
			-- Required to implement a cycle delay before going idle
			-- This ensures that the fifo empty flag is updated before going idle
			-- so that the write state machine does not register a false completion
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
			
			-- IDLE
			-- Just sit and wait for the go flag
			-- When the go flag is set start by moving to the writing state and 
			-- set the address.
			when idle =>
				if csr_go_flag = '1' then
					master_write_state <= running;
					master_write_address <= csr_wr_addr;
				end if;
			
			-- RUNNING
			-- write words out of the fifo
			-- inc address as we go
			-- if no data in fifo go back to fifo wait state
			-- The write signal is held inactive by comb logic if fifo empty so do nothing if fifo empty
			when running =>
				if avm_write_master_waitrequest /= '1' and fifo_empty /= '1' then
					master_write_address <= master_write_address + 4;  -- Masters use byte addressing so inc by 4 for next word
				end if;
				if fifo_empty = '1' and master_read_state = idle then
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
		if avs_csr_write = '1' then
			case avs_csr_address is
				when "10" =>
					csr_rd_addr <= avs_csr_writedata (31 downto 2) & "00";
					-- ignore 2 lsbs as this component only supports word aligned data
				when "11" =>
					csr_wr_addr <= avs_csr_writedata (31 downto 2) & "00";
					-- ignore 2 lsbs as this component only supports word aligned data
				when others =>
			end case;
		end if;
	end if;
end process;	


  csr_waitrequest <= out_waitrequest and (csr_write or csr_read);

  -- #1 odczyt asynchroniczny lub patrz #2
  csr_readdata <= csr(to_integer(unsigned(csr_address)));
  
  csr_proc: process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        csr <= init_csr;
        -- lub
        -- csr <= (others => (others => '0'));
      else

        if csr_write = '1' then
          csr(to_integer(unsigned(csr_address))) <= csr_writedata;
        end if;

        -- -- #2 odczyt synchroniczny
        -- if csr_read = '1' then
        --   csr_readdata <= csr(to_integer(unsigned(csr_address)));
        -- end if;

      end if;
    end if;
  end process csr_proc;

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
