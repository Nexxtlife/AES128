library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is 
port(
	clk : in std_logic;
	reset_n : in std_logic;
	
	address : out std_logic_vector(5 downto 0);
	clken : out std_logic;
	chipselect : out std_logic;
	write_n : out std_logic;
	readdata : in std_logic_vector(127 downto 0);
	writedata : out std_logic_vector(127 downto 0);
	byteenable : out std_logic_vector(3 downto 0);
	debugaccess : out std_logic;
	
	
	
	bit_0 : in std_logic;
	bit_1 : in std_logic;
	bit_2 : in std_logic;
	bit_3 : in std_logic;
	bit_4 : in std_logic;
	bit_5 : in std_logic;
	bit_6 : in std_logic;
	bit_7 : in std_logic;
	bit_8 : in std_logic;
	bit_9 : in std_logic;
	
	out_data : out std_logic_vector(127 downto 0)
);
end entity;


architecture behave of control is

signal address_new : std_logic_vector(9 downto 0);

begin

	process (clk)
	begin
	address_new <= bit_9 & bit_8 & bit_7 & bit_6 & bit_5 & bit_4 & bit_3 & bit_2 & bit_1 & bit_0;
	address <= address_new;
	
	if rising_edge(clk) then
		if reset_n = '0' then
				out_data <= (others=>'0');
		else
			out_data <= x"011A1411011A1411011A1411011A1411";
		end if;
	end if;
	end process;

end behave;