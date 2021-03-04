	component interface_sys is
		port (
			clk_clk                                       : in  std_logic                      := 'X'; -- clk
			reset_reset_n                                 : in  std_logic                      := 'X'; -- reset_n
			aes_interface_0_avalon_streaming_source_data  : out std_logic_vector(127 downto 0);        -- data
			aes_interface_0_avalon_streaming_source_ready : in  std_logic                      := 'X'; -- ready
			aes_interface_0_avalon_streaming_source_valid : out std_logic                              -- valid
		);
	end component interface_sys;

	u0 : component interface_sys
		port map (
			clk_clk                                       => CONNECTED_TO_clk_clk,                                       --                                     clk.clk
			reset_reset_n                                 => CONNECTED_TO_reset_reset_n,                                 --                                   reset.reset_n
			aes_interface_0_avalon_streaming_source_data  => CONNECTED_TO_aes_interface_0_avalon_streaming_source_data,  -- aes_interface_0_avalon_streaming_source.data
			aes_interface_0_avalon_streaming_source_ready => CONNECTED_TO_aes_interface_0_avalon_streaming_source_ready, --                                        .ready
			aes_interface_0_avalon_streaming_source_valid => CONNECTED_TO_aes_interface_0_avalon_streaming_source_valid  --                                        .valid
		);

