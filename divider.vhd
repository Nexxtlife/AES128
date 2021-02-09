library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divider is 
port(
	clk : in std_logic;
	reset_n : in std_logic;

	in_data : in std_logic_vector(127 downto 0);

	out_data_1 : out std_logic_vector(31 downto 0);
	out_data_2 : out std_logic_vector(31 downto 0);
	out_data_3 : out std_logic_vector(31 downto 0);
	out_data_4 : out std_logic_vector(31 downto 0)
);
end entity;


architecture behave of divider is


begin

	process (clk)
	begin
	
	if rising_edge(clk) then
		if reset_n = '0' then
			out_data_1 <= (others=>'0');
			out_data_2 <= (others=>'0');
			out_data_3 <= (others=>'0');
			out_data_4 <= (others=>'0');
		else
			out_data_1 <= in_data(127 downto 96);
			out_data_2 <= in_data(95 downto 64);
			out_data_3 <= in_data(63 downto 32);
			out_data_4 <= in_data(31 downto 0);
			
		end if;
	end if;
	end process;

end behave;