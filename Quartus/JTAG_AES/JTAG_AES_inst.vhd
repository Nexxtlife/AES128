	component JTAG_AES is
		port (
			clk_clk : in std_logic := 'X'  -- clk
		);
	end component JTAG_AES;

	u0 : component JTAG_AES
		port map (
			clk_clk => CONNECTED_TO_clk_clk  -- clk.clk
		);

