library ieee;
use ieee.std_logic_1164.all;

entity shft_row is

	port (
		data_in : in std_logic_vector(127 downto 0);
		data_out : out std_logic_vector(127 downto 0)
	);
end entity;

architecture behave of shft_row is

	

begin
	data_out(127 downto 120) <= data_in(95 downto 88);
	data_out(119 downto 112) <= data_in(55 downto 48);
	data_out(111 downto 104) <= data_in(15 downto 8);
	data_out(103 downto 96) <= data_in(103 downto 96);
	
	data_out(95 downto 88) <= data_in(63 downto 56);
	data_out(87 downto 80) <= data_in(23 downto 16);
	data_out(79 downto 72) <= data_in(111 downto 104);
	data_out(71 downto 64) <= data_in(71 downto 64);
	
	data_out(63 downto 56) <=data_in(31 downto 24);
	data_out(55 downto 48) <= data_in(119 downto 112);
	data_out(47 downto 40) <= data_in(79 downto 72);
	data_out(39 downto 32) <= data_in(39 downto 32);
	
	data_out(31 downto 24) <= data_in(127 downto 120);
	data_out(23 downto 16) <= data_in(87 downto 80);
	data_out(15 downto 8) <= data_in(47 downto 40);
	data_out(7 downto 0) <= data_in(7 downto 0);
	
		

end architecture behave;