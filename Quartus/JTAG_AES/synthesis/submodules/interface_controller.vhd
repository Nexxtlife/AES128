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
	
	--avalon slave interface
	interface_0_avalon_slave_1_read          : in std_logic;
	interface_0_avalon_slave_1_write         : in std_logic;
	interface_0_avalon_slave_1_waitrequest   : out std_logic;  
	interface_0_avalon_slave_1_address       : in std_logic_vector(INTERFACE_ADDR_WIDTH - 1 downto 0);                  -- address
	interface_0_avalon_slave_1_byteenable    : in std_logic_vector(3 downto 0);                 	-- byteenable
	interface_0_avalon_slave_1_readdata      : out  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X'); 	-- readdata
	interface_0_avalon_slave_1_writedata     : in  std_logic_vector(INTERFACE_WIDTH - 1 downto 0) := (others => 'X') 	-- readdata
  
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
signal data_temp_AES : std_logic_vector (127 downto 0);

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

--plaintext length
subtype text_length_T is std_logic_vector (7 downto 0);
signal working_address: std_logic_vector (7 downto 0) := (others=> '0');

-- aliasy do obszarÃ³w w csr
alias control_reg:   std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(0);
alias key_reg:  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)  is csr_reg(1);
alias  plain_text_reg :  std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(5);
alias cipher_text_reg : std_logic_vector(INTERFACE_WIDTH - 1 downto 0)	is csr_reg(9);

-- aliasy do bitÃ³w w obrzarach
alias encrypt_decrypt : std_logic is control_reg(0); 
alias start_flag : std_logic is control_reg(2);   
alias end_flag : std_logic is control_reg(3);
alias text_length :std_logic_vector(7 downto 0) is control_reg(15 downto 8); 

signal rst_aes : std_logic;

--wait_request signals
signal local_write_wait : std_logic := '0';
signal local_read_wait : std_logic := '0';
signal out_waitrequest : std_logic;
signal start_read : std_logic := '0';
signal start_read2 : std_logic := '0';


begin
------------------------------- ------------------------------------------------
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

-- read_csr: process (clk_clk, rst_t)
-- begin
	-- if rst_t = '1' then
		-- read_state <= idle;
	-- elsif rising_edge (clk_clk) then
	
		-- case read_state is
			
			-- when idle =>
				-- if write_state = idle and interface_0_avalon_slave_1_read = '1' then
					-- read_state <= running;
					
				-- end if;
				
			-- when running =>
				-- interface_0_avalon_slave_1_readdata <= csr_reg(to_integer(unsigned(interface_0_avalon_slave_1_address)));
				-- read_state <= stopping;
				
			-- when stopping =>
				-- read_state <= idle;
		
		-- end case;
	-- end if;
-- end process;

-- -------------------------------------------------------------------------------
-- -- THE WRITE SLAVE STATE MACHINE
-- -------------------------------------------------------------------------------

-- write_csr: process (clk_clk, rst_t)
-- begin
	-- if rst_t = '1' then
	
		-- write_state <= idle;
		
	-- elsif rising_edge (clk_clk) then
		-- case write_state is
		
			-- when idle =>
				-- if read_state = idle and interface_0_avalon_slave_1_write = '1' then
					-- write_state <= running;			
				-- end if;
				
	
			-- when running =>	
				-- write_state <= stopping;	
								
			-- when stopping =>
				-- write_state <= idle;
		
		-- end case;

	-- end if;
-- end process; 


-- enc_csr: process (clk_clk, rst_t)
-- begin
	-- if rst_t = '1' then
		-- encrypt_state <= idle;
		-- rst_aes <= '0';
	-- elsif rising_edge (clk_clk) then	
		-- case encrypt_state is
			
			-- when idle =>
				-- if encrypt_decrypt = '1' and start_flag = '1' then
					-- plaintext_t <= csr_reg(5) & csr_reg(6) & csr_reg(7) & csr_reg(8);
					-- key_t <= csr_reg(1) & csr_reg(2) & csr_reg(3) & csr_reg(4);
					-- rst_aes <= '0';
					-- encrypt_state <= running;
					
				-- end if;
				-- --ADD HERE THE DECRYPT
				
			-- when running =>
				-- rst_aes <= '1';	
				-- if done_t = '1' then
					-- rst_aes <= '0';
					-- data_temp_AES <= ciphertext_t;
					-- encrypt_state <= stopping;
				-- end if;
				
				
			-- when stopping =>
				-- encrypt_state <= idle;
		
		-- end case;
	-- end if;
-- end process;
-------------------------------------------------------------------------------
-- NON STATE MACHINE READ AND WRITE
-------------------------------------------------------------------------------

interface_0_avalon_slave_1_waitrequest <= out_waitrequest and (interface_0_avalon_slave_1_write or interface_0_avalon_slave_1_read);


out_waitrequest_proc: process(clk_clk)
  begin
    if rising_edge(clk_clk) then
      if rst_t = '1' then
        out_waitrequest <= '1';
      else
        if interface_0_avalon_slave_1_write = '1' or interface_0_avalon_slave_1_read = '1' then
          out_waitrequest <= '0';
        end if;

        if out_waitrequest = '0' and (interface_0_avalon_slave_1_write = '1' or interface_0_avalon_slave_1_read = '1') then
          out_waitrequest <= '1';
        end if;

      end if;
    end if;
  end process out_waitrequest_proc; 
  
csr_proc: process(clk_clk)
  begin
    if rising_edge(clk_clk) then
      if rst_t = '1' then
		encrypt_state <= idle;
		rst_aes <= '0';
        csr_reg <= (others => (others => '0'));
      else
        if interface_0_avalon_slave_1_write = '1' then
          csr_reg(to_integer(unsigned(interface_0_avalon_slave_1_address))) <= interface_0_avalon_slave_1_writedata;
        end if;
        if interface_0_avalon_slave_1_read = '1' then
			if start_read = '0' and rising_edge(clk_clk) then
				start_read <= '1';
			end if;
			if start_read = '1' and rising_edge(clk_clk) then
				start_read2 <= '1';
			end if;			
			if start_read2 = '1' and rising_edge(clk_clk) then
				interface_0_avalon_slave_1_readdata <= csr_reg(to_integer(unsigned(interface_0_avalon_slave_1_address)));
				start_read <= '0';
				start_read2 <= '0';
			end if;
        end if;
		if start_flag = '1' and encrypt_decrypt = '1' then		
			case encrypt_state is			
				when idle =>
						plaintext_t <= csr_reg(5) & csr_reg(6) & csr_reg(7) & csr_reg(8);
						key_t <= csr_reg(1) & csr_reg(2) & csr_reg(3) & csr_reg(4);
						rst_aes <= '0';
						encrypt_state <= running;
				when running =>
					rst_aes <= '1';	
					if done_t = '1' then
						rst_aes <= '0';
						control_reg <= x"00000000";
						csr_reg(9) <= ciphertext_t(127 downto 96);
						csr_reg(10) <= ciphertext_t(95 downto 64);
						csr_reg(11) <= ciphertext_t(63 downto 32);
						csr_reg(12) <= ciphertext_t(31 downto 0);	
						encrypt_state <= stopping;
					end if;				
				when stopping =>
					encrypt_state <= idle;
			end case;
		end if;
      end if; 
    end if;
  end process csr_proc;




-------------------------------------------------------------------------------
-- WAIT_REQUEST
-------------------------------------------------------------------------------
-- wait_request : process (clk_clk)
-- begin
		-- if rst_t = '1' then
			-- interface_0_avalon_slave_1_waitrequest <= '0';
			
		-- elsif write_state = idle  and interface_0_avalon_slave_1_write = '1' then
			-- interface_0_avalon_slave_1_waitrequest <= '1';
		-- elsif read_state = idle and interface_0_avalon_slave_1_read = '1'then
			-- interface_0_avalon_slave_1_waitrequest <= '1';
		-- elsif write_state = running then
			-- interface_0_avalon_slave_1_waitrequest <= '0';
		-- elsif read_state = running then 
			-- interface_0_avalon_slave_1_waitrequest <= '0'; 
		-- end if;

-- end process;
-------------------------------------------------------------------------------
-- CSR_PROCESS
-------------------------------------------------------------------------------
-- csr_process: process (clk_clk, rst_t)
-- begin
	-- if rst_t = '1' then
		-- control_reg <= x"00000000";
	-- elsif rising_edge (clk_clk) then
		-- if write_state = running then
			-- csr_reg(to_integer(unsigned(interface_0_avalon_slave_1_address))) <= interface_0_avalon_slave_1_writedata;
		-- end if;
		-- if encrypt_state = stopping then
			-- --working_address <= working_address +1;
			-- control_reg <= x"00000000";
			-- csr_reg(9) <= data_temp_AES(127 downto 96);
			-- csr_reg(10) <= data_temp_AES(95 downto 64);
			-- csr_reg(11) <= data_temp_AES(63 downto 32);
			-- csr_reg(12) <= data_temp_AES(31 downto 0);
		-- end if;
	-- end if;

-- end process;
---------------------------------------------------------------------------------

end architecture behave;
