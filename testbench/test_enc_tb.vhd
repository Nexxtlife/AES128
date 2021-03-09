library ieee;
use ieee.std_logic_1164.all;

entity test_enc is 
end test_enc;

architecture behavior of test_enc is
	component aes_enc
		port(
			clk        : in  std_logic;
			rst        : in  std_logic;
			key        : in  std_logic_vector(127 downto 0);
			plaintext  : in  std_logic_vector(127 downto 0);
			ciphertext : out std_logic_vector(127 downto 0);
			done       : out std_logic
		);		
	end component aes_enc;	
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal plaintext : std_logic_vector(127 downto 0);
	signal key : std_logic_vector(127 downto 0);	
	
	signal done : std_logic;
	signal ciphertext : std_logic_vector(127 downto 0);	
	constant clk_period : time := 10 ns;
	
begin
	enc_inst : aes_enc
		port map(
			clk        => clk,
			rst        => rst,
			key        => key,
			plaintext  => plaintext,
			ciphertext => ciphertext,
			done       => done
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
		plaintext <= x"54776F204F6E65204E696E652054776F";
		key <= x"5468617473206D79204B756E67204675";
		rst <= '0';		
		wait for clk_period * 1;
		rst <= '1';
		wait until done = '1';
		wait for clk_period/2;			

		wait;
	end process sim_proc;
	
end architecture behavior;