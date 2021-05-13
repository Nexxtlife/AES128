library ieee;
use ieee.std_logic_1164.all;

entity dec_byte_sub is
	port (
		input_data : in std_logic_vector(127 downto 0);
		output_data : out std_logic_vector(127 downto 0)
	);
end dec_byte_sub;

architecture behavioral of dec_byte_sub is
	
begin
	gen : for i in 0 to 15 generate
		s_box_inst : entity work.dec_s_box
			port map(
				input_byte  => input_data((i + 1)*8 - 1 downto i*8),
				output_byte => output_data((i + 1)*8 - 1 downto i*8)
			);		
	end generate gen;
	
end architecture behavioral;