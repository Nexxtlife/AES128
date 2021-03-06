library ieee;
use ieee.std_logic_1164.all;

entity aes_dec is
	port (
		clk : in std_logic;
		rst : in std_logic;
		dec_key : in std_logic_vector(127 downto 0);
		ciphertext : in std_logic_vector(127 downto 0);
		plaintext : out std_logic_vector(127 downto 0);
		done : out std_logic
	);
end aes_dec;

architecture rtl of aes_dec is

	signal inverted_plaintext : std_logic_vector(127 downto 0);
	signal inverted_key : std_logic_vector(127 downto 0);
	signal inverted_cyphertext : std_logic_vector(127 downto 0);

	signal mux_output : std_logic_vector(127 downto 0);
	signal reg_output : std_logic_vector(127 downto 0);
	signal dec_mixcol_input : std_logic_vector(127 downto 0);
	signal dec_mixcol_output : std_logic_vector(127 downto 0);
	signal invsr_input : std_logic_vector(127 downto 0);
	signal invsb_input : std_logic_vector(127 downto 0);
	signal feedback : std_logic_vector(127 downto 0);
	signal round_key : std_logic_vector(127 downto 0);
	signal round_const : std_logic_vector(7 downto 0);
	signal is_first_round : std_logic;
begin
	inverter_inst_plaintext : entity work.inverter
		port map(
			data_in => inverted_plaintext,
			data_out => plaintext
		);
	inverter_inst_key : entity work.inverter
		port map(
			data_in => dec_key,
			data_out => inverted_key
		);	
	inverter_inst_cyphertext : entity work.inverter
		port map(
			data_in => ciphertext,
			data_out => inverted_cyphertext
		);
		
	mux_output <= inverted_cyphertext when rst = '0' else feedback;
	reg_inst : entity work.reg
		generic map(
			size => 128
		)
		port map(
			clk => clk,
			d   => mux_output,
			q   => reg_output
		);
	
	add_round_key_inst : entity work.add_round_key
		port map(
			input1 => reg_output,
			input2 => round_key,
			output => dec_mixcol_input
		);
	dec_mix_columns_inst : entity work.dec_mix_column
		port map(
			input_data  => dec_mixcol_input,
			output_data => dec_mixcol_output
		);	
	invsr_input <= dec_mixcol_input when is_first_round = '1' else dec_mixcol_output;
	dec_shft_row_inst : entity work.dec_shft_row
		port map(
			input  => invsr_input,
			output => invsb_input
		);
	
	dec_sub_byte_inst : entity work.dec_sub_byte
		port map(
			input_data  => invsb_input,
			output_data => feedback
		);	
		
	 key_schedule_inst : entity work.key_schedule
	 	port map(
	 		clk         => clk,
	 		rst         => rst,
	 		key         => dec_key,
	 		round_const => round_const,
	 		round_key   => round_key
	 	);
	 dec_controller_inst : entity work.dec_controller
	 	port map(
	 		clk            => clk,
	 		rst            => rst,
	 		rconst         => round_const,
	 		is_first_round => is_first_round,
	 		done           => done
	 	);
	 inverted_plaintext <= dec_mixcol_input;
end architecture rtl;