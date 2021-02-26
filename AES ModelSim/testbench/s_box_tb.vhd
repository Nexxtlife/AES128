library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity s_box_tb is

end entity;

architecture behave of s_box_tb is

component s_box is
port(

	data_in : in std_logic_vector(31 downto 0);
	data_out : out std_logic_vector(31 downto 0)
);
end component;
	
signal clk_sig : std_logic;

signal data_in_sig : std_logic_vector(31 downto 0);
signal data_out_sig : std_logic_vector(31 downto 0);
	
constant clk_period : time := 10 ns;
	
begin

s_box1: s_box port map(data_in=>data_in_sig,data_out=>data_out_sig);

process
begin

clk_sig <= '0';
wait for clk_period/2;
clk_sig <= not clk_sig;
wait for clk_period/2;

end process;


process
begin
data_in_sig<=x"01010202";
wait for clk_period*5;
data_in_sig<=x"011A1411";
wait for clk_period;

wait;


end process;




end behave;