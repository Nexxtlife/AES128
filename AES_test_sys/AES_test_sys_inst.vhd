	component AES_test_sys is
		port (
			clk_clk                                 : in  std_logic                    := 'X'; -- clk
			display_0_avalon_streaming_source_data  : out std_logic_vector(7 downto 0);        -- data
			display_0_avalon_streaming_source_ready : in  std_logic                    := 'X'; -- ready
			display_0_avalon_streaming_source_valid : out std_logic;                           -- valid
			display_1_avalon_streaming_source_data  : out std_logic_vector(7 downto 0);        -- data
			display_1_avalon_streaming_source_ready : in  std_logic                    := 'X'; -- ready
			display_1_avalon_streaming_source_valid : out std_logic;                           -- valid
			display_2_avalon_streaming_source_data  : out std_logic_vector(7 downto 0);        -- data
			display_2_avalon_streaming_source_ready : in  std_logic                    := 'X'; -- ready
			display_2_avalon_streaming_source_valid : out std_logic;                           -- valid
			display_3_avalon_streaming_source_data  : out std_logic_vector(7 downto 0);        -- data
			display_3_avalon_streaming_source_ready : in  std_logic                    := 'X'; -- ready
			display_3_avalon_streaming_source_valid : out std_logic;                           -- valid
			reset_reset_n                           : in  std_logic                    := 'X'  -- reset_n
		);
	end component AES_test_sys;

	u0 : component AES_test_sys
		port map (
			clk_clk                                 => CONNECTED_TO_clk_clk,                                 --                               clk.clk
			display_0_avalon_streaming_source_data  => CONNECTED_TO_display_0_avalon_streaming_source_data,  -- display_0_avalon_streaming_source.data
			display_0_avalon_streaming_source_ready => CONNECTED_TO_display_0_avalon_streaming_source_ready, --                                  .ready
			display_0_avalon_streaming_source_valid => CONNECTED_TO_display_0_avalon_streaming_source_valid, --                                  .valid
			display_1_avalon_streaming_source_data  => CONNECTED_TO_display_1_avalon_streaming_source_data,  -- display_1_avalon_streaming_source.data
			display_1_avalon_streaming_source_ready => CONNECTED_TO_display_1_avalon_streaming_source_ready, --                                  .ready
			display_1_avalon_streaming_source_valid => CONNECTED_TO_display_1_avalon_streaming_source_valid, --                                  .valid
			display_2_avalon_streaming_source_data  => CONNECTED_TO_display_2_avalon_streaming_source_data,  -- display_2_avalon_streaming_source.data
			display_2_avalon_streaming_source_ready => CONNECTED_TO_display_2_avalon_streaming_source_ready, --                                  .ready
			display_2_avalon_streaming_source_valid => CONNECTED_TO_display_2_avalon_streaming_source_valid, --                                  .valid
			display_3_avalon_streaming_source_data  => CONNECTED_TO_display_3_avalon_streaming_source_data,  -- display_3_avalon_streaming_source.data
			display_3_avalon_streaming_source_ready => CONNECTED_TO_display_3_avalon_streaming_source_ready, --                                  .ready
			display_3_avalon_streaming_source_valid => CONNECTED_TO_display_3_avalon_streaming_source_valid, --                                  .valid
			reset_reset_n                           => CONNECTED_TO_reset_reset_n                            --                             reset.reset_n
		);

