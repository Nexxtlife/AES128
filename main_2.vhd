library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity main_2 is

port(

rst_n : in std_logic;
load : in std_logic;
clk : in std_logic;

hex_0_sig : out std_logic;
hex_1_sig : out std_logic;
hex_2_sig : out std_logic;
hex_3_sig : out std_logic;
hex_4_sig : out std_logic;
hex_5_sig : out std_logic;
hex_6_sig : out std_logic;
hex_7_sig : out std_logic;

hex_10_sig : out std_logic;
hex_11_sig : out std_logic;
hex_12_sig : out std_logic;
hex_13_sig : out std_logic;
hex_14_sig : out std_logic;
hex_15_sig : out std_logic;
hex_16_sig : out std_logic;
hex_17_sig : out std_logic


);
end entity;

architecture behave of main_2 is
 
 signal data : std_logic_vector(127 downto 0) := x"01010202010102020101020201010202";
 signal hex_data_0 : std_logic_vector(7 downto 0);
 signal hex_data_1 : std_logic_vector(7 downto 0);
 signal hex_data_2 : std_logic_vector(7 downto 0);
 --data<=x"01010202010102020101020201010202";

 component byteSub_display_sys is
        port (
            byte_div_0_data_out_0_data           : out std_logic_vector(7 downto 0);                      -- data
            byte_div_0_data_out_1_data           : out std_logic_vector(7 downto 0);                      -- data
            byte_div_0_data_out_2_data           : out std_logic_vector(7 downto 0);                      -- data
            bytesub_0_avalon_streaming_sink_data : in  std_logic_vector(127 downto 0) := (others => 'X'); -- data
            clk_clk                              : in  std_logic                      := 'X';             -- clk
            reset_reset_n                        : in  std_logic                      := 'X'              -- reset_n
        );
end component byteSub_display_sys;

component display
		port(
			data_in : in std_logic_vector(3 downto 0);
			hex_0 : out std_logic;
			hex_1 : out std_logic;
			hex_2 : out std_logic;
			hex_3 : out std_logic;
			hex_4 : out std_logic;
			hex_5 : out std_logic;
			hex_6 : out std_logic;
			hex_7 : out std_logic
		);
	end component;


 begin


 
 u0 : component byteSub_display_sys
		port map (
			bytesub_0_avalon_streaming_sink_data => data, -- bytesub_0_avalon_streaming_sink.data
			clk_clk                              => clk,                              --                             clk.clk
			reset_reset_n                        => rst_n,                        --                           reset.reset_n
			byte_div_0_data_out_0_data           => hex_data_0,           --           byte_div_0_data_out_0.data
			byte_div_0_data_out_1_data           => hex_data_1,           --           byte_div_0_data_out_1.data
			byte_div_0_data_out_2_data           => hex_data_2            --           byte_div_0_data_out_2.data
		);
 
d0 : display port map (
					data_in => hex_data_0(3 downto 0), 
					hex_0 => hex_0_sig,
					hex_1 => hex_1_sig,
					hex_2 => hex_2_sig,
					hex_3 => hex_3_sig,
					hex_4 => hex_4_sig,
					hex_5 => hex_5_sig,
					hex_6 => hex_6_sig,
					hex_7 => hex_7_sig
				);
d1 : display port map (
					data_in => hex_data_0(7 downto 4), 
					hex_0 => hex_10_sig,
					hex_1 => hex_11_sig,
					hex_2 => hex_12_sig,
					hex_3 => hex_13_sig,
					hex_4 => hex_14_sig,
					hex_5 => hex_15_sig,
					hex_6 => hex_16_sig,
					hex_7 => hex_17_sig
				);

	process (clk)
	begin
	if rising_edge(clk) then
		if rst_n = '0' then
			data<=(others=>'0');
		else

		end if;
	end if;
	
	end process;
	


end behave;