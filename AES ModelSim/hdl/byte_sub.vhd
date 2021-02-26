library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity byte_sub is 
port(

	data_in : in std_logic_vector(127 downto 0);
	data_out : out std_logic_vector(127 downto 0)
);
end entity;


architecture behave of byte_sub is

begin

	gen: for i in 0 to 3 generate
		s_box_inst : entity work.s_box
			port map (
				data_in  => data_in((i + 1)*32 - 1 downto i*32),
				data_out => data_out((i + 1)*32 - 1 downto i*32)
			);
	end generate gen;


end behave;