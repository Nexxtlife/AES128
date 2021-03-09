library ieee;
use ieee.std_logic_1164.all;
 
entity mix_column is
	port (
		input_data : in std_logic_vector(127 downto 0);
		output_data : out std_logic_vector(127 downto 0)
	);
end mix_column;

architecture rtl of mix_column is
	
begin
	mix_column_inst0 : entity work.column_calc
		port map(
			input_data  => input_data(31 downto 0),
			output_data => output_data(31 downto 0)
		);
	mix_column_inst1 : entity work.column_calc
		port map(
			input_data  => input_data(63 downto 32),
			output_data => output_data(63 downto 32)
		);		
	mix_column_inst2 : entity work.column_calc
		port map(
			input_data  => input_data(95 downto 64),
			output_data => output_data(95 downto 64)
		);
	mix_column_inst3 : entity work.column_calc
		port map(
			input_data  => input_data(127 downto 96),
			output_data => output_data(127 downto 96)
		);	
end architecture rtl;