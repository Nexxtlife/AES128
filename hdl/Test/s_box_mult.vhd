library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s_box_mult is
port (
    clk, rst_n : in std_logic;
	input_byte : in std_logic_vector(7 downto 0);
	output_byte : out std_logic_vector(7 downto 0)
);
end s_box_mult;

architecture rtl of s_box_mult is

constant n : natural := 8;
signal slv : std_logic_vector(7 downto 0);
signal sum_result : std_logic;
signal mult_result : std_logic(15 downto 0);
signal counter : unsigned(7 downto 0);
signal sum_done_w : std_logic;
signal counter : unsigned(7 downto 0);

signal inversion_matrix : std_logic(63 downto 0) := (others=>'0');
signal inversion_vector : std_logic_vector(7 downto 0) := (others =>'0');

type inversion_states_T is(multiplying, adding, stopping);
signal inversion_state : inversion_states_T;

begin

  sum_done_w <= counter(counter'length - 1);
  
  process(clk)
  begin
    if rising_edge(clk) then
	  if reset = '1' then
        sum_result <= '0';
        counter <= (others => '0');
		inversion_state <= multiplying;
      else
		case inversion_state is 
		when multiplying =>
			mult_0 : entity work.lpm_multiply(SYN) --needs a done value
			
			port map(
				a => input_byte, 
				b => inversion_matrix(8 downto 0), 
				result => mult_result
			);
			inversion_state <= adding;
		when adding =>
			sum_result <= sum_result xor mult_result(mult_result'length - 1); -- xor ostatniego elementu
			mult_result <= mult_result(mult_result'length - 2 downto 0) & '0'; -- rejestr przesuwny wektora
			
			counter <= counter(counter'length - 2 downto 0) & '1';
			
			inversion_state <= stopping;
		when stopping =>
		
			inversion_state <= multiplying;
			
		end case;
	  
        
      end if;
    end if;
  end process;  
  
end architecture rtl;