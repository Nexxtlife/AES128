-- this is a temporary working file 
-- need to implement a fifo for master read ( i think)
-- detect if fifo is full or empty
-- read from fifo must be controlled

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity interface_controller is
  generic (
    INTERFACE_WIDTH : integer := 32; -- change in tcl file [8,16,32]
    INTERFACE_LENGTH : natural := 32; -- change in tcl file [0-n]
    INTERFACE_ADDR_WIDTH : natural := 5
  );
  port (
    clk, rst : in std_logic;
	
	-- control & status registers (CSR) slave
	interface_0_avalon_slave_1_read          : in std_logic;
	interface_0_avalon_slave_1_write         : in std_logic;
	interface_0_avalon_slave_1_waitrequest   : out std_logic;  
	interface_0_avalon_slave_1_address       : in std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                  -- address
	interface_0_avalon_slave_1_byteenable    : in std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                 -- byteenable
	interface_0_avalon_slave_1_readdata      : out  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	interface_0_avalon_slave_1_writedata     : in  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	
	key        : out  std_logic_vector(127 downto 0);
	plaintext  : out  std_logic_vector(127 downto 0);
	ciphertext : in std_logic_vector(127 downto 0);
	done       : in std_logic														-- valid st
  
  );
end interface_controller;


architecture behave of interface_controller is

-- state machine states
type read_states_T is (idle, running, stopping);
type write_states_T is (idle, running, stopping);
signal read_state : read_states_T;
signal write_state : write_states_T;

-- temp data storage
signal data_temp : std_logic_vector (INTERFACE_WIDTH - 1 downto 0); 
signal data_temp_AES : std_logic_vector (127 downto 0);

--CSR initial values
--function init_csr
  --return register_t is
  --variable temp: register_t(INTERFACE_LENGTH - 1 downto 0);
  --begin
	--entire table set to '0'
    --temp := (others => (others => '0'));
    --return temp;
  --end init_csr;
  
-------------------------------------------------------------------------------------------
----------CSR SOLUTION---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
subtype word_t is std_logic_vector(INTERFACE_WIDTH - 1  downto 0);
type reg_t is array (INTERFACE_LENGTH - 1 downto 0) of word_t;

signal csr_reg : reg_t:= (others => (others => '0'));
signal test_temp : std_logic_vector(31 downto 0) := (others => '0');
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- aliasy do obszarów w csr
alias control_reg:   std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(0);
alias key_reg:  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(1);
alias  plain_text_reg :  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(5);

-- aliasy do bitów w obrzarach
alias encrypt_decrypt : std_logic is control_reg(0);         -- used to start the DMA (when logic 1)
alias start_flag : std_logic is control_reg(2);         -- logic 1 if either state machines are active
alias end_flag : std_logic is control_reg(3);         -- logic 1 if either state machines are active

signal out_waitrequest : std_logic;


begin
-------------------------------------------------------------------------------
-- THE READ SLAVE STATE MACHINE
-------------------------------------------------------------------------------


read_csr: process (clk, rst)
begin
	if rst = '1' then
		read_state <= idle;
		interface_0_avalon_slave_1_waitrequest <= '0';
	elsif rising_edge (clk) then
	
		case read_state is
			
			when idle =>
				if write_state = idle and interface_0_avalon_slave_1_read = '1' then
					read_state <= running;
					interface_0_avalon_slave_1_waitrequest <= '1';
					--data_temp <= csr_reg(0);
					--data_temp <= csr_reg(to_integer(unsigned(interface_0_avalon_slave_1_address)));
					
				end if;
				
			when running =>
				interface_0_avalon_slave_1_waitrequest <= '0';
				interface_0_avalon_slave_1_readdata <= csr_reg(to_integer(unsigned(interface_0_avalon_slave_1_address)));
				read_state <= stopping;
				
			when stopping =>
				data_temp <= (others => '0');
				read_state <= idle;
		
		end case;
	end if;
end process;

-------------------------------------------------------------------------------
-- THE WRITE SLAVE STATE MACHINE
-------------------------------------------------------------------------------

write_csr: process (clk, rst)
begin
	if rst = '1' then
		write_state <= idle;
		interface_0_avalon_slave_1_waitrequest <= '0';
		
	elsif rising_edge (clk) then
		case write_state is
		
			when idle =>
				if read_state = idle and interface_0_avalon_slave_1_write = '1' then
					write_state <= running;			
					interface_0_avalon_slave_1_waitrequest <= '1';
				end if;
	
			when running =>	
			
				interface_0_avalon_slave_1_waitrequest <= '0';
				--test_temp <= interface_0_avalon_slave_1_writedata;
				--csr_reg(1) <= interface_0_avalon_slave_1_writedata;
				csr_reg(to_integer(unsigned(interface_0_avalon_slave_1_address))) <= interface_0_avalon_slave_1_writedata;
				write_state <= stopping;	
								
			when stopping =>
		
				write_state <= idle;
		
		end case;
	end if;
end process;

-------------------------------------------------------------------------------
-- CSR PROCESS
-------------------------------------------------------------------------------

csr: process (clk, rst)
begin
	if rst = '1' then
		--csr_reg <= (others => (others => '0'));
		interface_0_avalon_slave_1_waitrequest <= '0';
	elsif rising_edge (clk) then
		case encrypt_decrypt is
			when '1' =>
				if start_flag = '1' then
					key <= key_reg;
					plaintext <= plain_text_reg;
				end if;
					
			when '0' =>
				if start_flag = '1' then
				end if;

			when others =>

			end case;
	end if;
end process;	

end architecture behave;
