library ieee;
use ieee.std_logic_1164.all;

entity column_calc is
	port (
		input_data : in std_logic_vector(31 downto 0);
		output_data : out std_logic_vector(31 downto 0)
	);
end column_calc;

architecture rtl of column_calc is
	signal temp : std_logic_vector(7 downto 0);
	signal temp0 : std_logic_vector(7 downto 0);
	signal temp1 : std_logic_vector(7 downto 0);
	signal temp2 : std_logic_vector(7 downto 0);
	signal temp3 : std_logic_vector(7 downto 0);
	signal temp0x2 : std_logic_vector(7 downto 0);
	signal temp1x2 : std_logic_vector(7 downto 0);
	signal temp2x2 : std_logic_vector(7 downto 0);
	signal temp3x2 : std_logic_vector(7 downto 0);	
begin
	temp <= input_data(31 downto 24) xor input_data(23 downto 16) xor input_data(15 downto 8) xor input_data(7 downto 0);
	temp0 <= input_data(7 downto 0) xor input_data(15 downto 8);
	temp1 <= input_data(15 downto 8) xor input_data(23 downto 16);
	temp2 <= input_data(23 downto 16) xor input_data(31 downto 24);
	temp3 <= input_data(31 downto 24) xor input_data(7 downto 0);
	gf_mult_inst0 : entity work.gf_mult
		port map(
			input_byte  => temp0,
			output_byte => temp0x2
		);
	gf_mult_inst1 : entity work.gf_mult
		port map(
			input_byte  => temp1,
			output_byte => temp1x2
		);
	gf_mult_inst2 : entity work.gf_mult
		port map(
			input_byte  => temp2,
			output_byte => temp2x2
		);
	gf_mult_inst3 : entity work.gf_mult
		port map(
			input_byte  => temp3,
			output_byte => temp3x2
		);
	output_data(7 downto 0) <= input_data(7 downto 0) xor temp0x2 xor temp;
	output_data(15 downto 8) <= input_data(15 downto 8) xor temp1x2 xor temp;
	output_data(23 downto 16) <= input_data(23 downto 16) xor temp2x2 xor temp;
	output_data(31 downto 24) <= input_data(31 downto 24) xor temp3x2 xor temp; 	
	
end architecture rtl;