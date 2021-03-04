	component byteSub_display_sys is
		port (
			bytesub_0_avalon_streaming_sink_data     : in  std_logic_vector(127 downto 0) := (others => 'X'); -- data
			clk_clk                                  : in  std_logic                      := 'X';             -- clk
			reset_reset_n                            : in  std_logic                      := 'X';             -- reset_n
			shift_row_0_avalon_streaming_source_data : out std_logic_vector(127 downto 0)                     -- data
		);
	end component byteSub_display_sys;

	u0 : component byteSub_display_sys
		port map (
			bytesub_0_avalon_streaming_sink_data     => CONNECTED_TO_bytesub_0_avalon_streaming_sink_data,     --     bytesub_0_avalon_streaming_sink.data
			clk_clk                                  => CONNECTED_TO_clk_clk,                                  --                                 clk.clk
			reset_reset_n                            => CONNECTED_TO_reset_reset_n,                            --                               reset.reset_n
			shift_row_0_avalon_streaming_source_data => CONNECTED_TO_shift_row_0_avalon_streaming_source_data  -- shift_row_0_avalon_streaming_source.data
		);

