library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_multiply is
port (
    clk, rst_n : in std_logic;
    a,b : in std_logic_vector(7 downto 0);
    result : out std_logic_vector(15 downto 0)
);
end test_multiply;

architecture rtl of test_multiply is
begin
  mult_0 : entity work.lpm_multiply(SYN)
  port map(a, b, result);
end architecture rtl;