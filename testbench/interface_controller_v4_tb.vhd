library ieee;
use ieee.std_logic_1164.all;

entity interface_tb is 
end interface_tb;

architecture behavior of interface_tb is
	component interface
		port(
			clk_clk                                   : in  std_logic                      := 'X';             -- clk
			reset_reset_n                             : in  std_logic                      := 'X';             -- reset_n 	
			
			interface_0_avalon_master_1_read          : out std_logic; 
			interface_0_avalon_master_1_waitrequest   : in std_logic;  
			interface_0_avalon_master_1_address       : out std_logic_vector(4 - 1 downto 0);                -- address
			interface_0_avalon_master_1_byteenable    : out std_logic_vector(4 - 1 downto 0);               -- byteenable
			interface_0_avalon_master_1_readdata      : in  std_logic_vector(32 - 1 downto 0);  -- readdata
			
			
			-- control & status registers (CSR) slave
			interface_0_avalon_slave_1_write          : in std_logic;
			interface_0_avalon_slave_1_waitrequest   : out std_logic :='1';  
			interface_0_avalon_slave_1_address       : in std_logic_vector(4 - 1 downto 0);                  -- address
			interface_0_avalon_slave_1_byteenable    : in std_logic_vector(4 - 1 downto 0);                 -- byteenable
			interface_0_avalon_slave_1_writedata      : in  std_logic_vector(32 - 1 downto 0) 	-- readdata
			
			
			
			
	);	
	end component interface;	
	signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '0';
	
	signal	interface_0_avalon_slave_1_write_tb          :  std_logic;
	signal	interface_0_avalon_slave_1_waitrequest_tb   :  std_logic;  
	signal	interface_0_avalon_slave_1_address_tb       :  std_logic_vector(4 - 1 downto 0);                  -- address
	signal	interface_0_avalon_slave_1_byteenable_tb    :  std_logic_vector(4 - 1 downto 0);                 -- byteenable
	signal	interface_0_avalon_slave_1_writedata_tb      :   std_logic_vector(32 - 1 downto 0); 	-- readdata
	
	signal	interface_0_avalon_master_1_read_tb          :  std_logic; 
	signal	interface_0_avalon_master_1_waitrequest_tb   :  std_logic;  
	signal	interface_0_avalon_master_1_address_tb       :  std_logic_vector(4 - 1 downto 0);                -- address
	signal	interface_0_avalon_master_1_byteenable_tb    :  std_logic_vector(4 - 1 downto 0);               -- byteenable
	signal	interface_0_avalon_master_1_readdata_tb      :  std_logic_vector(32 - 1 downto 0);  -- readdata

	constant clk_period : time := 10 ns;
	
begin
	interface_inst : interface
		port map(
			clk_clk =>  clk_tb,
			reset_reset_n =>  rst_tb,
			
			interface_0_avalon_master_1_read   =>    interface_0_avalon_master_1_read_tb,   
			interface_0_avalon_master_1_waitrequest  =>interface_0_avalon_master_1_waitrequest_tb,
			interface_0_avalon_master_1_address    =>   interface_0_avalon_master_1_address_tb,
			interface_0_avalon_master_1_byteenable  => interface_0_avalon_master_1_byteenable_tb,
			interface_0_avalon_master_1_readdata   =>  interface_0_avalon_master_1_readdata_tb,
			
			interface_0_avalon_slave_1_write    =>    interface_0_avalon_slave_1_write_tb,
			interface_0_avalon_slave_1_waitrequest  =>interface_0_avalon_slave_1_waitrequest_tb,
			interface_0_avalon_slave_1_address   =>   interface_0_avalon_slave_1_address_tb,
			interface_0_avalon_slave_1_byteenable  => interface_0_avalon_slave_1_byteenable_tb,
			interface_0_avalon_slave_1_writedata =>   interface_0_avalon_slave_1_writedata_tb
			
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
		wait until rising_edge(clk_tb) and rst_tb = '0';
			interface_0_avalon_slave_1_write_tb <= '1';
			wait until interface_0_avalon_slave_1_waitrequest_tb = '0';
			report "entering csr";
			interface_0_avalon_slave_1_address_tb <= x"0";
			interface_0_avalon_slave_1_byteenable_tb <= "1111";
			interface_0_avalon_slave_1_writedata_tb <= x"aaaaaaaa";
		--end if;
	end process sim_proc;
	
	
end architecture behavior;