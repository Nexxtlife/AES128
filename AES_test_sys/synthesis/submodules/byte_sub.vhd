library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity byte_sub is 
port(
	clk : in std_logic;
	reset_n : in std_logic;
	
	in_valid : in std_logic;
	in_ready : out std_logic;
	in_data : in std_logic_vector(95 downto 0);
	
	out_valid : in std_logic;
	out_ready : out std_logic;
	out_data : out std_logic_vector(95 downto 0)
);
end entity;


architecture behave of byte_sub is

begin

	gen: for i in 0 to 2 generate
		s_box_inst : entity work.sbox
			port map (
				data_in  => in_data((i + 1)*32 - 1 downto i*32),
				data_out => out_data((i + 1)*32 - 1 downto i*32)
			);
	end generate gen;


end behave;