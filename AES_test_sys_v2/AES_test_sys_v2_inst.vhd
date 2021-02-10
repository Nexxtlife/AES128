	component AES_test_sys_v2 is
		port (
			bytesub_0_avalon_streaming_sink_data  : in  std_logic_vector(127 downto 0) := (others => 'X'); -- data
			bytesub_0_avalon_streaming_sink_ready : out std_logic;                                         -- ready
			bytesub_0_avalon_streaming_sink_valid : in  std_logic                      := 'X';             -- valid
			clk_clk                               : in  std_logic                      := 'X';             -- clk
			reset_reset_n                         : in  std_logic                      := 'X';             -- reset_n
			display_0_display_out_data            : out std_logic_vector(7 downto 0);                      -- data
			display_3_display_out_data            : out std_logic_vector(7 downto 0);                      -- data
			display_2_display_out_data            : out std_logic_vector(7 downto 0);                      -- data
			display_1_display_out_data            : out std_logic_vector(7 downto 0)                       -- data
		);
	end component AES_test_sys_v2;

	u0 : component AES_test_sys_v2
		port map (
			bytesub_0_avalon_streaming_sink_data  => CONNECTED_TO_bytesub_0_avalon_streaming_sink_data,  -- bytesub_0_avalon_streaming_sink.data
			bytesub_0_avalon_streaming_sink_ready => CONNECTED_TO_bytesub_0_avalon_streaming_sink_ready, --                                .ready
			bytesub_0_avalon_streaming_sink_valid => CONNECTED_TO_bytesub_0_avalon_streaming_sink_valid, --                                .valid
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                             clk.clk
			reset_reset_n                         => CONNECTED_TO_reset_reset_n,                         --                           reset.reset_n
			display_0_display_out_data            => CONNECTED_TO_display_0_display_out_data,            --           display_0_display_out.data
			display_3_display_out_data            => CONNECTED_TO_display_3_display_out_data,            --           display_3_display_out.data
			display_2_display_out_data            => CONNECTED_TO_display_2_display_out_data,            --           display_2_display_out.data
			display_1_display_out_data            => CONNECTED_TO_display_1_display_out_data             --           display_1_display_out.data
		);

