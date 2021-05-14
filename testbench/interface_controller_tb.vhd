library ieee;
use ieee.std_logic_1164.all;

library design_lib;
use design_lib.all;

entity interface_tb is 
end interface_tb;

architecture behavior of interface_tb is
	component interface_controller
		port(
			clk_clk                                  : in  std_logic                      := 'X';             -- clk
			rst_t                           : in  std_logic                      := 'X';             -- reset_n 	
			
			
			interface_0_avalon_slave_1_read          : in std_logic;
			interface_0_avalon_slave_1_write         : in std_logic;
			interface_0_avalon_slave_1_waitrequest   : out std_logic;  
			interface_0_avalon_slave_1_address       : in std_logic_vector(4 downto 0);                  -- address
			interface_0_avalon_slave_1_byteenable    : in std_logic_vector(3 downto 0);                 -- byteenable
			interface_0_avalon_slave_1_readdata      : out  std_logic_vector(31 downto 0) := (others => 'X'); 	-- readdata
			interface_0_avalon_slave_1_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X') 	-- readdata
			
	);	
	end component interface_controller;	
	signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '0';
	
	signal	interface_0_avalon_slave_1_read_tb          : std_logic;
	signal	interface_0_avalon_slave_1_write_tb         :  std_logic;
	signal	interface_0_avalon_slave_1_waitrequest_tb   :  std_logic;  
	signal	interface_0_avalon_slave_1_address_tb       :  std_logic_vector(4 downto 0);                  -- address
	signal	interface_0_avalon_slave_1_byteenable_tb    :  std_logic_vector(3 downto 0);                 -- byteenable
	signal	interface_0_avalon_slave_1_readdata_tb      :   std_logic_vector(31 downto 0) := (others => 'X'); 	-- readdata
	signal	interface_0_avalon_slave_1_writedata_tb     :   std_logic_vector(31 downto 0) := (others => 'X'); 	-- readdata

	constant clk_period : time := 10 ns;
	
begin
	interface_inst : entity design_lib.interface_controller
		port map(
			clk_clk =>  clk_tb,
			rst_t =>  rst_tb,
			
			interface_0_avalon_slave_1_read   =>    interface_0_avalon_slave_1_read_tb,   
			interface_0_avalon_slave_1_write  =>interface_0_avalon_slave_1_write_tb,
			interface_0_avalon_slave_1_waitrequest    =>   interface_0_avalon_slave_1_waitrequest_tb,
			interface_0_avalon_slave_1_address  => interface_0_avalon_slave_1_address_tb,
			interface_0_avalon_slave_1_byteenable   =>  interface_0_avalon_slave_1_byteenable_tb,
			interface_0_avalon_slave_1_readdata    =>    interface_0_avalon_slave_1_readdata_tb,
			interface_0_avalon_slave_1_writedata  =>interface_0_avalon_slave_1_writedata_tb
			
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
			interface_0_avalon_slave_1_writedata_tb <= x"00000000";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			---------------------------------------------------------------
			--WRITE KEY----------------------------------------------------
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00001";
			interface_0_avalon_slave_1_writedata_tb <= x"2b7e1516";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			---------------------------------------------------------------
			
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00010";
			interface_0_avalon_slave_1_writedata_tb <= x"28aed2a6";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00011";
			interface_0_avalon_slave_1_writedata_tb <= x"abf71588";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00100";
			interface_0_avalon_slave_1_writedata_tb <= x"09cf4f3c";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			
			--WRITE PLAIN----------------------------------------------------
			
			
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00101";
			interface_0_avalon_slave_1_writedata_tb <= x"3243f6a8";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00110";
			interface_0_avalon_slave_1_writedata_tb <= x"885a308d";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00111";
			interface_0_avalon_slave_1_writedata_tb <= x"313198a2";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "01000";
			interface_0_avalon_slave_1_writedata_tb <= x"e0370734";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------
			
			wait for clk_period *2;

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
			
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00011";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00100";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			
			wait for clk_period *2;
			
			--write--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00000";
			interface_0_avalon_slave_1_writedata_tb <= x"0000000f";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			wait for clk_period;
			interface_0_avalon_slave_1_write_tb <= '0';
			--------------------------------------------------------------

			
			wait for clk_period *4;
			
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
			interface_0_avalon_slave_1_address_tb <= "00000";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			
			--READ CIPHER-------------------------------------------------
			wait for clk_period *20;
			
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "01001";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "01010";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "01011";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "01100";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			
			
			--READING CONTROL REG
			--read--------------------------------------------------------
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '1';
			interface_0_avalon_slave_1_address_tb <= "00000";
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			wait for clk_period;
			interface_0_avalon_slave_1_read_tb <= '0';
			--------------------------------------------------------------
			wait;
		--end if;
	end process sim_proc;
	
	
end architecture behavior;
