	component JTAG_AES is
		port (
			clk_clk         : in std_logic := 'X'; -- clk
			reset_n_reset_n : in std_logic := 'X'  -- reset_n
		);
	end component JTAG_AES;

	u0 : component JTAG_AES
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --     clk.clk
			reset_n_reset_n => CONNECTED_TO_reset_n_reset_n  -- reset_n.reset_n
		);

