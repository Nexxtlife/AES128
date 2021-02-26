library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is 
port(
	clk : in std_logic;
	load : in std_logic;
	rst : in std_logic;
	enable_out : in std_logic;
	data_in : in std_logic_vector(127 downto 0);
	data_out : out std_logic_vector(127 downto 0)
);
end entity;


architecture behave of reg is
signal state : std_logic_vector (127 downto 0) := (others => 'Z');

begin

process(clk)
begin
	if rst = '1' then
		state <= (others=>'0');
		elsif rising_edge(clk) then 
			if load = '1' then
				state <= data_in;
			elsif enable_out = '1' then
				data_out<= state;
			end if;
	end if;

end process;


end behave;