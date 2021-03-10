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
	signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '0';
	signal plaintext_tb : std_logic_vector(127 downto 0);
	signal key_tb : std_logic_vector(127 downto 0);	
	signal done_tb : std_logic;
	signal ciphertext_tb : std_logic_vector(127 downto 0);	
	constant clk_period : time := 10 ns;
	
begin
	enc_inst : aes_enc
		port map(
			clk        => clk_tb,
			rst        => rst_tb,
			key        => key_tb,
			plaintext  => plaintext_tb,
			ciphertext => ciphertext_tb,
			done       => done_tb
		);	
	clk_process : process is
	begin
		clk_tb <= '0';
		wait for clk_period/2;
		clk_tb <= '1';
		wait for clk_period/2;
	end process clk_process;
	
	sim_proc : process is
	begin
	
		--plaintext = 3243f6a8885a308d313198a2e0370734
		--key = 2b7e151628aed2a6abf7158809cf4f3c		
		--cyphertext = 3925841d02dc09fbdc118597196a0b32
		-- the order of significance starts from the back so 32 43 f6 a8 88 5a 30 8d 31 31 98 a2 e0 37 07 34 should be noted as 340737e0a29831318d305a88a8f64332
		-- so the cyphertext should be 320b6a19978511dcfb09dc021d842539
		plaintext_tb <= x"3243f6a8885a308d313198a2e0370734";
		key_tb <= x"2b7e151628aed2a6abf7158809cf4f3c";
		rst_tb <= '0';		
		wait for clk_period * 1;
		rst_tb <= '1';
		wait until done_tb = '1';
		wait for clk_period/2;			

		wait;
	end process sim_proc;
	
end architecture behavior;