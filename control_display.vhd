library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity control_display is

port(

rst_n : in std_logic;

clk : in std_logic;

data_in : in std_logic_vector(7 downto 0);

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

architecture behave of control_display is
 
 signal hex_disp_0 : std_logic_vector(3 downto 0);
 signal hex_disp_1 : std_logic_vector(3 downto 0);	
 
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
 d1 : display port map (
					data_in => hex_disp_0, 
					hex_0 => hex_0_sig,
					hex_1 => hex_1_sig,
					hex_2 => hex_2_sig,
					hex_3 => hex_3_sig,
					hex_4 => hex_4_sig,
					hex_5 => hex_5_sig,
					hex_6 => hex_6_sig,
					hex_7 => hex_7_sig
				);
 d2 : display port map (
					data_in => hex_disp_1, 
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
		hex_0_sig <= '0';
		hex_1_sig <= '0';
		hex_2_sig <= '0';
		hex_3_sig <= '0';
		hex_4_sig <= '0';
		hex_5_sig <= '0';
		hex_6_sig <= '0';
		hex_7_sig <= '0';
		
		hex_10_sig <= '0';
		hex_11_sig <= '0';
		hex_12_sig <= '0';
		hex_13_sig <= '0';
		hex_14_sig <= '0';
		hex_15_sig <= '0';
		hex_16_sig <= '0';
		hex_17_sig <= '0';
		
		else
		hex_disp_0 <= data_in(3 downto 0);
		hex_disp_1 <= data_in(7 downto 4);
		end if;
	end if;
	
	end process;
	


end behave;