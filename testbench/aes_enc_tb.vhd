library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library design_library;
use design_library.all;

entity aes_enc_tb is
end entity aes_enc_tb;

architecture sim of aes_enc_tb is
 
constant PERIOD : time := 20 ns;
  
signal clk_tb : std_logic := '0';
signal rst_tb : std_logic;
signal key_tb : std_logic_vector(127 downto 0) := (others => '0');
signal plaintext_tb : std_logic_vector(127 downto 0) := (others => '0');
signal ciphertext_tb : std_logic_vector(127 downto 0);
signal done_tb : std_logic;

signal stop_clk : boolean := false;

begin
  
  -- instancja modułu testowanego
  DUT : entity design_library.aes_enc(behavioral)
  port map (
    clk => clk_tb, 
    rst => rst_tb, 
    key => key_tb, 
    plaintext => plaintext_tb, 
    ciphertext => ciphertext_tb, 
    done => done_tb   
  );

  stimuli: process
  begin
    report "Testbench started";
    wait until rising_edge(clk_tb) and rst_tb = '0';
    -- TODO:
    -- tutaj musisz uzupełnic własne wymuszenia
    -- testowanego modułu.
    wait for PERIOD * 20;
    stop_clk <= true;
    report "Testbench finished";
    wait;
  end process stimuli;


clk_proc: process
begin
  if not stop_clk then
    clk_tb <= not clk_tb;
    wait for PERIOD / 2;
  else
    wait;
  end if;  
end process clk_proc;


reset_process: process
variable reset_cycles_count : integer := 2; 
begin
rst_tb <= '1';
while reset_cycles_count >= 0 loop
  wait until rising_edge(clk_tb);
  reset_cycles_count := reset_cycles_count - 1;
end loop;
rst_tb <= '0';
wait;
end process;


end architecture sim;
