library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity control_display is

port(

rst_n : in std_logic;

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

architecture behave of control_display is
 
 signal number_last : std_logic_vector(7 downto 0);
 signal number_new : std_logic_vector(7 downto 0);
 signal data_in_sig : std_logic_vector(3 downto 0);
 signal data_in_sig2 : std_logic_vector(3 downto 0);	
 
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
					data_in => data_in_sig, 
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
					data_in => data_in_sig2, 
					hex_0 => hex_8_sig,
					hex_1 => hex_9_sig,
					hex_2 => hex_10_sig,
					hex_3 => hex_11_sig,
					hex_4 => hex_12_sig,
					hex_5 => hex_13_sig,
					hex_6 => hex_14_sig,
					hex_7 => hex_15_sig
				);
 
led_0 <= number_last(0);
led_1 <= number_last(1); 
led_2 <= number_last(2);
led_3 <= number_last(3);
led_4 <= number_last(4);
led_5 <= number_last(5);
led_6 <= number_last(6);
led_7 <= number_last(7);	
data_in_sig <= number_new(3 downto 0);
data_in_sig2 <= number_new(7 downto 4);

	process (clk)
	begin
	if rising_edge(clk) then
		if rst_n = '0' then
			
			number_last <= (others => '0');
		else
			number_new <= bit_7 & bit_6 & bit_5 & bit_4 & bit_3 & bit_2 & bit_1 & bit_0;
			
			if mode = '0'then

				if load = '0' then
					number_last <= number_new;
					end if;
			else
				if load = '0' then
					number_last <= number_last xor number_new;
				end if;
			end if;
		end if;
	end if;
	
	end process;
	


end behave;