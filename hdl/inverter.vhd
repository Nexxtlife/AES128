library ieee;
use ieee.std_logic_1164.all;

entity inverter is
	port (
		data_in : in std_logic_vector(127 downto 0);
		data_out : out std_logic_vector(127 downto 0)
	);
end inverter;

architecture behavioral of inverter is
	signal temp_out : std_logic_vector(127 downto 0);

begin

	data_out <= data_in(7 downto 0 ) & data_in(15 downto 8 ) & data_in(23 downto 16 ) & data_in(31 downto 24 ) & data_in(39 downto 32 ) & data_in(47 downto 40 ) & data_in(55 downto 48 ) &data_in(63 downto 56 ) & data_in(71 downto 64 ) & data_in(79 downto 72 ) & data_in(87 downto 80 ) & data_in(95 downto 88 ) & data_in(103 downto 96 ) & data_in(111 downto 104 ) & data_in(119 downto 112 ) & data_in(127 downto 120 );
	
end architecture behavioral;