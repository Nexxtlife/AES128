library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divider is 
port(
	clk : in std_logic;
	reset_n : in std_logic;

	in_data : in std_logic_vector(127 downto 0);

	out_data_1 : out std_logic_vector(7 downto 0);
	out_data_2 : out std_logic_vector(7 downto 0);
	out_data_3 : out std_logic_vector(7 downto 0);
	out_data_4 : out std_logic_vector(7 downto 0);
	
	out_data_11 : out std_logic_vector(7 downto 0);
	out_data_12 : out std_logic_vector(7 downto 0)
	--out_data_13 : out std_logic_vector(7 downto 0);
	--out_data_14 : out std_logic_vector(7 downto 0);
	
	--out_data_21 : out std_logic_vector(7 downto 0);
	--out_data_22 : out std_logic_vector(7 downto 0);
	--out_data_23 : out std_logic_vector(7 downto 0);
	--out_data_24 : out std_logic_vector(7 downto 0);
	
	--out_data_31 : out std_logic_vector(7 downto 0);
	--out_data_32 : out std_logic_vector(7 downto 0);
	--out_data_33 : out std_logic_vector(7 downto 0);
	--out_data_34 : out std_logic_vector(7 downto 0)
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
			out_data_11 <= (others=>'0');
			out_data_12 <= (others=>'0');
			
		else
			out_data_1 <= in_data(7 downto 0);
			out_data_2 <= in_data(15 downto 8);
			out_data_3 <= in_data(23 downto 16);
			out_data_4 <= in_data(31 downto 24);
			out_data_11 <= in_data(39 downto 32);
			out_data_12 <= in_data(47 downto 40);
			
			
		end if;
	end if;
	end process;

end behave;