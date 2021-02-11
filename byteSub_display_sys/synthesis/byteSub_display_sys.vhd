-- byteSub_display_sys.vhd

-- Generated using ACDS version 18.0 614

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity byteSub_display_sys is
	port (
		byte_div_0_data_out_0_data           : out std_logic_vector(7 downto 0);                      --           byte_div_0_data_out_0.data
		byte_div_0_data_out_1_data           : out std_logic_vector(7 downto 0);                      --           byte_div_0_data_out_1.data
		byte_div_0_data_out_2_data           : out std_logic_vector(7 downto 0);                      --           byte_div_0_data_out_2.data
		bytesub_0_avalon_streaming_sink_data : in  std_logic_vector(127 downto 0) := (others => '0'); -- bytesub_0_avalon_streaming_sink.data
		clk_clk                              : in  std_logic                      := '0';             --                             clk.clk
		reset_reset_n                        : in  std_logic                      := '0'              --                           reset.reset_n
	);
end entity byteSub_display_sys;

architecture rtl of byteSub_display_sys is
	component byte_sub is
		port (
			clk      : in  std_logic                      := 'X';             -- clk
			reset    : in  std_logic                      := 'X';             -- reset
			out_data : out std_logic_vector(127 downto 0);                    -- data
			in_data  : in  std_logic_vector(127 downto 0) := (others => 'X')  -- data
		);
	end component byte_sub;

	component byte_div is
		port (
			clk        : in  std_logic                      := 'X';             -- clk
			reset_n    : in  std_logic                      := 'X';             -- reset_n
			out_data_1 : out std_logic_vector(7 downto 0);                      -- data
			out_data_2 : out std_logic_vector(7 downto 0);                      -- data
			out_data_3 : out std_logic_vector(7 downto 0);                      -- data
			in_data    : in  std_logic_vector(127 downto 0) := (others => 'X')  -- data
		);
	end component byte_div;

	component altera_reset_controller is
		generic (
			NUM_RESET_INPUTS          : integer := 6;
			OUTPUT_RESET_SYNC_EDGES   : string  := "deassert";
			SYNC_DEPTH                : integer := 2;
			RESET_REQUEST_PRESENT     : integer := 0;
			RESET_REQ_WAIT_TIME       : integer := 1;
			MIN_RST_ASSERTION_TIME    : integer := 3;
			RESET_REQ_EARLY_DSRT_TIME : integer := 1;
			USE_RESET_REQUEST_IN0     : integer := 0;
			USE_RESET_REQUEST_IN1     : integer := 0;
			USE_RESET_REQUEST_IN2     : integer := 0;
			USE_RESET_REQUEST_IN3     : integer := 0;
			USE_RESET_REQUEST_IN4     : integer := 0;
			USE_RESET_REQUEST_IN5     : integer := 0;
			USE_RESET_REQUEST_IN6     : integer := 0;
			USE_RESET_REQUEST_IN7     : integer := 0;
			USE_RESET_REQUEST_IN8     : integer := 0;
			USE_RESET_REQUEST_IN9     : integer := 0;
			USE_RESET_REQUEST_IN10    : integer := 0;
			USE_RESET_REQUEST_IN11    : integer := 0;
			USE_RESET_REQUEST_IN12    : integer := 0;
			USE_RESET_REQUEST_IN13    : integer := 0;
			USE_RESET_REQUEST_IN14    : integer := 0;
			USE_RESET_REQUEST_IN15    : integer := 0;
			ADAPT_RESET_REQUEST       : integer := 0
		);
		port (
			reset_in0      : in  std_logic := 'X'; -- reset
			clk            : in  std_logic := 'X'; -- clk
			reset_out      : out std_logic;        -- reset
			reset_req      : out std_logic;        -- reset_req
			reset_req_in0  : in  std_logic := 'X'; -- reset_req
			reset_in1      : in  std_logic := 'X'; -- reset
			reset_req_in1  : in  std_logic := 'X'; -- reset_req
			reset_in2      : in  std_logic := 'X'; -- reset
			reset_req_in2  : in  std_logic := 'X'; -- reset_req
			reset_in3      : in  std_logic := 'X'; -- reset
			reset_req_in3  : in  std_logic := 'X'; -- reset_req
			reset_in4      : in  std_logic := 'X'; -- reset
			reset_req_in4  : in  std_logic := 'X'; -- reset_req
			reset_in5      : in  std_logic := 'X'; -- reset
			reset_req_in5  : in  std_logic := 'X'; -- reset_req
			reset_in6      : in  std_logic := 'X'; -- reset
			reset_req_in6  : in  std_logic := 'X'; -- reset_req
			reset_in7      : in  std_logic := 'X'; -- reset
			reset_req_in7  : in  std_logic := 'X'; -- reset_req
			reset_in8      : in  std_logic := 'X'; -- reset
			reset_req_in8  : in  std_logic := 'X'; -- reset_req
			reset_in9      : in  std_logic := 'X'; -- reset
			reset_req_in9  : in  std_logic := 'X'; -- reset_req
			reset_in10     : in  std_logic := 'X'; -- reset
			reset_req_in10 : in  std_logic := 'X'; -- reset_req
			reset_in11     : in  std_logic := 'X'; -- reset
			reset_req_in11 : in  std_logic := 'X'; -- reset_req
			reset_in12     : in  std_logic := 'X'; -- reset
			reset_req_in12 : in  std_logic := 'X'; -- reset_req
			reset_in13     : in  std_logic := 'X'; -- reset
			reset_req_in13 : in  std_logic := 'X'; -- reset_req
			reset_in14     : in  std_logic := 'X'; -- reset
			reset_req_in14 : in  std_logic := 'X'; -- reset_req
			reset_in15     : in  std_logic := 'X'; -- reset
			reset_req_in15 : in  std_logic := 'X'  -- reset_req
		);
	end component altera_reset_controller;

	signal bytesub_0_avalon_streaming_source_data   : std_logic_vector(127 downto 0); -- byteSub_0:out_data -> byte_div_0:in_data
	signal rst_controller_reset_out_reset           : std_logic;                      -- rst_controller:reset_out -> [byteSub_0:reset, rst_controller_reset_out_reset:in]
	signal reset_reset_n_ports_inv                  : std_logic;                      -- reset_reset_n:inv -> rst_controller:reset_in0
	signal rst_controller_reset_out_reset_ports_inv : std_logic;                      -- rst_controller_reset_out_reset:inv -> byte_div_0:reset_n

begin

	bytesub_0 : component byte_sub
		port map (
			clk      => clk_clk,                                --                   clock.clk
			reset    => rst_controller_reset_out_reset,         --                   reset.reset
			out_data => bytesub_0_avalon_streaming_source_data, -- avalon_streaming_source.data
			in_data  => bytesub_0_avalon_streaming_sink_data    --   avalon_streaming_sink.data
		);

	byte_div_0 : component byte_div
		port map (
			clk        => clk_clk,                                  --      clock.clk
			reset_n    => rst_controller_reset_out_reset_ports_inv, --      reset.reset_n
			out_data_1 => byte_div_0_data_out_0_data,               -- data_out_0.data
			out_data_2 => byte_div_0_data_out_1_data,               -- data_out_1.data
			out_data_3 => byte_div_0_data_out_2_data,               -- data_out_2.data
			in_data    => bytesub_0_avalon_streaming_source_data    --    data_in.data
		);

	rst_controller : component altera_reset_controller
		generic map (
			NUM_RESET_INPUTS          => 1,
			OUTPUT_RESET_SYNC_EDGES   => "deassert",
			SYNC_DEPTH                => 2,
			RESET_REQUEST_PRESENT     => 0,
			RESET_REQ_WAIT_TIME       => 1,
			MIN_RST_ASSERTION_TIME    => 3,
			RESET_REQ_EARLY_DSRT_TIME => 1,
			USE_RESET_REQUEST_IN0     => 0,
			USE_RESET_REQUEST_IN1     => 0,
			USE_RESET_REQUEST_IN2     => 0,
			USE_RESET_REQUEST_IN3     => 0,
			USE_RESET_REQUEST_IN4     => 0,
			USE_RESET_REQUEST_IN5     => 0,
			USE_RESET_REQUEST_IN6     => 0,
			USE_RESET_REQUEST_IN7     => 0,
			USE_RESET_REQUEST_IN8     => 0,
			USE_RESET_REQUEST_IN9     => 0,
			USE_RESET_REQUEST_IN10    => 0,
			USE_RESET_REQUEST_IN11    => 0,
			USE_RESET_REQUEST_IN12    => 0,
			USE_RESET_REQUEST_IN13    => 0,
			USE_RESET_REQUEST_IN14    => 0,
			USE_RESET_REQUEST_IN15    => 0,
			ADAPT_RESET_REQUEST       => 0
		)
		port map (
			reset_in0      => reset_reset_n_ports_inv,        -- reset_in0.reset
			clk            => clk_clk,                        --       clk.clk
			reset_out      => rst_controller_reset_out_reset, -- reset_out.reset
			reset_req      => open,                           -- (terminated)
			reset_req_in0  => '0',                            -- (terminated)
			reset_in1      => '0',                            -- (terminated)
			reset_req_in1  => '0',                            -- (terminated)
			reset_in2      => '0',                            -- (terminated)
			reset_req_in2  => '0',                            -- (terminated)
			reset_in3      => '0',                            -- (terminated)
			reset_req_in3  => '0',                            -- (terminated)
			reset_in4      => '0',                            -- (terminated)
			reset_req_in4  => '0',                            -- (terminated)
			reset_in5      => '0',                            -- (terminated)
			reset_req_in5  => '0',                            -- (terminated)
			reset_in6      => '0',                            -- (terminated)
			reset_req_in6  => '0',                            -- (terminated)
			reset_in7      => '0',                            -- (terminated)
			reset_req_in7  => '0',                            -- (terminated)
			reset_in8      => '0',                            -- (terminated)
			reset_req_in8  => '0',                            -- (terminated)
			reset_in9      => '0',                            -- (terminated)
			reset_req_in9  => '0',                            -- (terminated)
			reset_in10     => '0',                            -- (terminated)
			reset_req_in10 => '0',                            -- (terminated)
			reset_in11     => '0',                            -- (terminated)
			reset_req_in11 => '0',                            -- (terminated)
			reset_in12     => '0',                            -- (terminated)
			reset_req_in12 => '0',                            -- (terminated)
			reset_in13     => '0',                            -- (terminated)
			reset_req_in13 => '0',                            -- (terminated)
			reset_in14     => '0',                            -- (terminated)
			reset_req_in14 => '0',                            -- (terminated)
			reset_in15     => '0',                            -- (terminated)
			reset_req_in15 => '0'                             -- (terminated)
		);

	reset_reset_n_ports_inv <= not reset_reset_n;

	rst_controller_reset_out_reset_ports_inv <= not rst_controller_reset_out_reset;

end architecture rtl; -- of byteSub_display_sys
