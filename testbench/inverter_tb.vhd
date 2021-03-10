library ieee;
use ieee.std_logic_1164.all;

entity inverter_tb is 
end inverter_tb;

architecture behavior of inverter_tb is
	component inverter
		port(
			data_in  : in  std_logic_vector(127 downto 0);
			data_out : out std_logic_vector(127 downto 0)
		);		
	end component inverter;	
	
	signal clk : std_logic := '0';
	signal data_in : std_logic_vector(127 downto 0);
	signal data_out : std_logic_vector(127 downto 0);	
	constant clk_period : time := 10 ns;
	
begin
	inverter_inst : inverter
		port map(
			data_in  => data_in,
			data_out => data_out
		);
		
	clk_process : process is
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process clk_process;
	
	sim_proc : process is
	begin
	
		--plaintext = 3243f6a8885a308d313198a2e0370734
		--key = 2b7e151628aed2a6abf7158809cf4f3c		
		--cyphertext = 3925841d02dc09fbdc118597196a0b32
		-- the order of significance starts from the back so 32 43 f6 a8 88 5a 30 8d 31 31 98 a2 e0 37 07 34 should be noted as 340737e0a29831318d305a88a8f64332
		-- so the cyphertext should be 320b6a19978511dcfb09dc021d842539
		data_in <= x"3243f6a8885a308d313198a2e0370734";
		wait for clk_period/2;			

		wait;
	end process sim_proc;
	
end architecture behavior;