library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_std.ALL;

entity display is 
port(
	data_in : in std_logic_vector(7 downto 0);
	hex_0 : out std_logic;
	hex_1 : out std_logic;
	hex_2 : out std_logic;
	hex_3 : out std_logic;
	hex_4 : out std_logic;
	hex_5 : out std_logic;
	hex_6 : out std_logic;
	hex_7 : out std_logic;
	
	hex_10 : out std_logic;
	hex_11 : out std_logic;
	hex_12 : out std_logic;
	hex_13 : out std_logic;
	hex_14 : out std_logic;
	hex_15 : out std_logic;
	hex_16 : out std_logic;
	hex_17 : out std_logic
);
end entity;


architecture behave of display is
begin

	process(data_in)
	begin
		if data_in = "0000" then --0
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '1';
			hex_7 <= '1';
		elsif data_in = "0001" then --1
			hex_0 <= '1';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '1';
			hex_4 <= '1';
			hex_5 <= '1';
			hex_6 <= '1';
			hex_7 <= '1';
		elsif data_in = "0010" then --2
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '1';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '1';
			hex_6 <= '0';
			hex_7 <= '1';
		elsif data_in = "0011" then --3
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '1';
			hex_5 <= '1';
			hex_6 <= '0';
			hex_7 <= '1';
		elsif data_in = "0100" then --4
			hex_0 <= '1';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '1';
			hex_4 <= '1';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '1';
		elsif data_in = "0101" then --5
			hex_0 <= '0';
			hex_1 <= '1';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '1';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '1';
		elsif data_in = "0110" then --6
			hex_0 <= '0';
			hex_1 <= '1';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '1';
		elsif data_in = "0111" then --7
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '1';
			hex_4 <= '1';
			hex_5 <= '1';
			hex_6 <= '1';
			hex_7 <= '1';
		elsif data_in = "1000" then --8
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '1';
		elsif data_in = "1001" then --9
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '1';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '1';
		elsif data_in = "1010" then --10
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '1';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '0';
		elsif data_in = "1011" then --11
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '0';
		elsif data_in = "1100" then --12
			hex_0 <= '0';
			hex_1 <= '1';
			hex_2 <= '1';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '1';
			hex_7 <= '0';
		elsif data_in = "1101" then --13
			hex_0 <= '0';
			hex_1 <= '0';
			hex_2 <= '0';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '1';
			hex_7 <= '0';
		elsif data_in = "1110" then --14
			hex_0 <= '0';
			hex_1 <= '1';
			hex_2 <= '1';
			hex_3 <= '0';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '0';
		elsif data_in = "1111" then --15
			hex_0 <= '0';
			hex_1 <= '1';
			hex_2 <= '1';
			hex_3 <= '1';
			hex_4 <= '0';
			hex_5 <= '0';
			hex_6 <= '0';
			hex_7 <= '0';		
		end if;
		
	end process;

end behave;