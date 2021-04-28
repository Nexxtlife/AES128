library ieee;
use ieee.std_logic_1164.all;

entity interface_tb is 
end interface_tb;

architecture behavior of interface_tb is
	component interface_controller
		port(
			clk                                  : in  std_logic                      := 'X';             -- clk
			rst                             : in  std_logic                      := 'X';             -- reset_n 	
			
			
			interface_0_avalon_slave_1_read          : in std_logic;
			interface_0_avalon_slave_1_write         : in std_logic;
			interface_0_avalon_slave_1_waitrequest   : out std_logic;  
			interface_0_avalon_slave_1_address       : in std_logic_vector(4 downto 0);                  -- address
			interface_0_avalon_slave_1_byteenable    : in std_logic_vector(4 downto 0);                 -- byteenable
			interface_0_avalon_slave_1_readdata      : out  std_logic_vector(31 downto 0) := (others => 'X'); 	-- readdata
			interface_0_avalon_slave_1_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); 	-- readdata
			
			key        : out  std_logic_vector(127 downto 0);
			plaintext  : out  std_logic_vector(127 downto 0);
			ciphertext : in std_logic_vector(127 downto 0);
			done       : in std_logic														-- valid st
			
	);	
	end component interface_controller;	
	signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '0';
	
	signal	interface_0_avalon_slave_1_read_tb          : std_logic;
	signal	interface_0_avalon_slave_1_write_tb         :  std_logic;
	signal	interface_0_avalon_slave_1_waitrequest_tb   :  std_logic;  
	signal	interface_0_avalon_slave_1_address_tb       :  std_logic_vector(4 downto 0);                  -- address
	signal	interface_0_avalon_slave_1_byteenable_tb    :  std_logic_vector(4 downto 0);                 -- byteenable
	signal	interface_0_avalon_slave_1_readdata_tb      :   std_logic_vector(31 downto 0) := (others => 'X'); 	-- readdata
	signal	interface_0_avalon_slave_1_writedata_tb     :   std_logic_vector(31 downto 0) := (others => 'X'); 	-- readdata
			
	signal	key_tb        :   std_logic_vector(127 downto 0);
	signal plaintext_tb  :   std_logic_vector(127 downto 0);
	signal	ciphertext_tb :  std_logic_vector(127 downto 0);
	signal	done_tb       :  std_logic;			

	constant clk_period : time := 10 ns;
	
begin
	interface_inst : interface_controller
		port map(
			clk =>  clk_tb,
			rst =>  rst_tb,
			
			interface_0_avalon_slave_1_read   =>    interface_0_avalon_slave_1_read_tb,   
			interface_0_avalon_slave_1_write  =>interface_0_avalon_slave_1_write_tb,
			interface_0_avalon_slave_1_waitrequest    =>   interface_0_avalon_slave_1_waitrequest_tb,
			interface_0_avalon_slave_1_address  => interface_0_avalon_slave_1_address_tb,
			interface_0_avalon_slave_1_byteenable   =>  interface_0_avalon_slave_1_byteenable_tb,
			interface_0_avalon_slave_1_readdata    =>    interface_0_avalon_slave_1_readdata_tb,
			interface_0_avalon_slave_1_writedata  =>interface_0_avalon_slave_1_writedata_tb,
			
			
			
			key   =>   key_tb,
			plaintext  => plaintext_tb,
			ciphertext =>   ciphertext_tb,
			done =>   done_tb
			
	);
	clk_process : process is
	begin
		clk_tb <= '0';
		wait for clk_period/2;
		clk_tb <= '1';
		wait for clk_period/2;
	end process clk_process;
	
	sim_proc : process is
	begin
		report "Testbench started";
		interface_0_avalon_slave_1_write_tb <= '0';
		interface_0_avalon_slave_1_address_tb <= (others => '0');
		interface_0_avalon_slave_1_read_tb <= '0';
		interface_0_avalon_slave_1_writedata_tb <= x"aaaaaaaa";
		interface_0_avalon_slave_1_byteenable_tb <= (others => '1');
		
		rst_tb <= '1';
		wait for clk_period/2;
		rst_tb <='0';  
		rst_tb <= '1';
		wait for clk_period/2;
		rst_tb <='0'; 
		report "reset done";
		
		wait until rising_edge(clk_tb) and rst_tb = '0';
			report "start";
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00000";
			interface_0_avalon_slave_1_writedata_tb <= x"aaaaaaaa";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			---------------------------------------------------------------
			
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00001";
			interface_0_avalon_slave_1_writedata_tb <= x"bbbbbbbb";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00010";
			interface_0_avalon_slave_1_writedata_tb <= x"cccccccc";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			
			wait for clk_period *2;

			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00000";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00001";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00010";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			wait;
		--end if;
	end process sim_proc;
	
	
end architecture behavior;