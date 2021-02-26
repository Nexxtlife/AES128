library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity reg_tb is

end entity;

architecture behave of reg_tb is

component reg is
	port(
		clk : in std_logic;
		load : in std_logic;
		rst : in std_logic;
		enable_out : in std_logic;
		data_in : in std_logic_vector(127 downto 0);
		data_out : out std_logic_vector(127 downto 0)
	);
end component;
	
signal clk_sig : std_logic;
signal load_sig : std_logic;
signal	rst_sig : std_logic;
signal	enable_out_sig : std_logic;
signal data_in_sig : std_logic_vector(127 downto 0);
signal data_out_sig : std_logic_vector(127 downto 0);
	
constant clk_period : time := 10 ns;
	
begin

reg1: reg port map(clk=>clk_sig,load=>load_sig,rst=>rst_sig,enable_out=>enable_out_sig,data_in=>data_in_sig,data_out=>data_out_sig);

process
begin

clk_sig <= '0';
wait for clk_period/2;
clk_sig <= not clk_sig;
wait for clk_period/2;

end process;


process
begin
rst_sig<='0';
load_sig<='1';
wait for clk_period;
data_in_sig<=x"01010202010102020101020201010202";
wait for clk_period;
load_sig<= '0';
enable_out_sig <= '1';
wait for clk_period;
enable_out_sig<='0';
load_sig<='1';
wait for clk_period;
data_in_sig<=x"011A1411011A1411011A1411011A1411";
wait for clk_period;
load_sig<='0';
enable_out_sig<='1';
wait for clk_period;
enable_out_sig<='0';
rst_sig<='0';
wait;


end process;



end behave;