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
    clk_clk, rst_t : in std_logic;
	
	-- control & status registers (CSR) slave
	interface_0_avalon_slave_1_read          : in std_logic;
	interface_0_avalon_slave_1_write         : in std_logic;
	interface_0_avalon_slave_1_waitrequest   : out std_logic;  
	interface_0_avalon_slave_1_address       : in std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                  -- address
	interface_0_avalon_slave_1_byteenable    : in std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                 -- byteenable
	interface_0_avalon_slave_1_readdata      : out  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	interface_0_avalon_slave_1_writedata     : in  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	
	key_out        : out  std_logic_vector(127 downto 0);
	plaintext_out  : out  std_logic_vector(127 downto 0);
	ciphertext_out : out std_logic_vector(127 downto 0);
	done_out       : out std_logic														-- valid st
  
  );
end interface_controller;


architecture behave of interface_controller is

-- state machine states
type read_states_T is (idle, running, stopping);
type write_states_T is (idle, running, stopping);
type encrypt_states_T is(idle, running, stopping);
signal encrypt_state : encrypt_states_T;
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
--signals for aes_enc

signal key_t :  std_logic_vector(127 downto 0);
signal plaintext_t : std_logic_vector(127 downto 0);
signal ciphertext_t :  std_logic_vector(127 downto 0);
signal done_t :  std_logic;

-- aliasy do obszarÃ³w w csr
alias control_reg:   std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(0);
alias key_reg:  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(1);
alias  plain_text_reg :  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(5);
alias cipher_text_reg : std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(9);

-- aliasy do bitÃ³w w obrzarach
alias encrypt_decrypt : std_logic is control_reg(0); 
alias start_flag : std_logic is control_reg(2);   
alias end_flag : std_logic is control_reg(3); 
constant PERIOD : time := 10 ns;
signal rst_aes : std_logic;
signal write_flag : std_logic := '0';


begin
-------------------------------------------------------------------------------
-- THE READ SLAVE STATE MACHINE
-------------------------------------------------------------------------------
aes_enc_inst : entity work.aes_enc
		port map(
		clk => clk_clk,
		rst => rst_aes,
		key => key_t,
		plaintext => plaintext_t,
		ciphertext => ciphertext_t,
		done => done_t	
		);

read_csr: process (clk_clk, rst_t)
begin
	if rst_t = '1' then
		read_state <= idle;
		interface_0_avalon_slave_1_waitrequest <= '0';
	elsif rising_edge (clk_clk) then
	
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

write_csr: process (clk_clk, rst_t)
begin
	if rst_t = '1' then
	
		write_state <= idle;
		interface_0_avalon_slave_1_waitrequest <= '0';
		
	elsif rising_edge (clk_clk) then
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
-- ENCRYPT
-------------------------------------------------------------------------------
-- enc : process (clk_clk, rst_t)
-- begin
		-- plaintext_out <= plaintext_t;
		-- key_out <= key_t;
		-- done_out <= done_t;
		-- ciphertext_out <= ciphertext_t;
		
	-- if rst_t = '1' then
		-- plaintext_t <= (others => '0');
		-- key_t <= (others => '0');

	-- elsif rising_edge (clk_clk) then

		-- if encrypt_decrypt = '1' and start_flag = '1' then
			-- plaintext_t <= csr_reg(5) & csr_reg(6) & csr_reg(7) & csr_reg(8);
			-- key_t <= csr_reg(1) & csr_reg(2) & csr_reg(3) & csr_reg(4);
			-- if done_t = '1' then
				-- csr_reg(9) <= ciphertext_t(127 downto 96);
				-- csr_reg(10) <= ciphertext_t(95 downto 64);
				-- csr_reg(11) <= ciphertext_t(63 downto 32);
				-- csr_reg(12) <= ciphertext_t(31 downto 0);
				-- ciphertext_out <= ciphertext_t;
			-- end if;
		-- end if;
	-- end if;
-- end process;


enc : process
begin	
		wait until start_flag ='1';
		rst_aes <= '0';
		plaintext_t <= csr_reg(5) & csr_reg(6) & csr_reg(7) & csr_reg(8);
		key_t <= csr_reg(1) & csr_reg(2) & csr_reg(3) & csr_reg(4);
		wait until rising_edge(clk_clk) and rst_aes = '0';
		rst_aes <= '1';		
		wait until done_t = '1';
		rst_aes <= '0';
		--wait for PERIOD * 1;
		-- csr_reg(9) <= ciphertext_t(127 downto 96);
		-- csr_reg(10) <= ciphertext_t(95 downto 64);
		-- csr_reg(11) <= ciphertext_t(63 downto 32);
		-- csr_reg(12) <= ciphertext_t(31 downto 0);
		-- csr_reg(13) <= x"aaaaaaaa";
		-- csr_reg(14) <= x"aaaaaaaa";
		-- csr_reg(15) <= x"aaaaaaaa";
		-- csr_reg(16) <= x"aaaaaaaa";
		wait until rising_edge(clk_clk);
		-- csr_reg(9) <= (others => '1');
		-- csr_reg(10) <= plaintext_t(95 downto 64);
		-- csr_reg(11) <= (others => '0');
		-- csr_reg(12) <= (others => '0');
		-- csr_reg(13) <= (others => '0');
		-- csr_reg(14) <= (others => '0');
		-- csr_reg(15) <= (others => '0');
		-- csr_reg(16) <= (others => '0');
		ciphertext_out <= ciphertext_t;
		data_temp_AES <= ciphertext_t;
		write_flag <= '1';
		wait until rising_edge(clk_clk);
		csr_reg(9) <= (others => '1');
		--csr_reg(0)<= x"00000000";
		-- if write_to_csr = '0' then
		--ciphertext_out <= ciphertext_t;
		-- csr_reg(9) <= data_temp_AES(127 downto 96);
		-- csr_reg(10) <= data_temp_AES(95 downto 64);
		-- csr_reg(11) <= data_temp_AES(63 downto 32);
		-- csr_reg(12) <= data_temp_AES(31 downto 0);
		
		-- csr_reg(13) <= x"aaaaaaaa";
		-- csr_reg(14) <= x"aaaaaaaa";
		-- csr_reg(15) <= x"aaaaaaaa";
		-- csr_reg(16) <= x"aaaaaaaa";
		-- write_to_csr <= '1';
		-- end if;

end process;

-- write_cipher_to_csr : process (clk_clk, rst_t)
-- begin
	-- if rst_t = '1' then
	
	-- csr_reg(9) <= (others => '0');
	-- csr_reg(10) <= (others => '0');
	-- csr_reg(11) <= (others => '0');
	-- csr_reg(12) <= (others => '0');
	-- csr_reg(13) <= (others => '0');
	-- csr_reg(14) <= (others => '0');
	-- csr_reg(15) <= (others => '0');
	-- csr_reg(16) <= (others => '0');
		
	-- elsif rising_edge (clk_clk) and done_t = '1' then
		-- plaintext_out <= (others => '0');
		-- cipher_text_reg <= x"12345678";
		-- --csr_reg(6) <= x"12345678";
		-- --csr_reg(7) <= x"12345678";
		-- --csr_reg(8) <= x"12345678";
		-- --csr_reg(13) <= x"12345678";
		-- --csr_reg(14) <= x"12345678";
		-- --csr_reg(15) <= x"12345678";
		-- --csr_reg(16) <= x"12345678";
	-- end if;
-- end process;
-- -------------------------------------------------------------------------------

end architecture behave;
