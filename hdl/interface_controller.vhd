library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity <entity-name> is
  generic (
    CSR_WIDTH : natural := 8; -- w tym miejscu powinno być do wyboru [8,16,31]
    CSR_LENGTH : natural := 8; -- w tym miejscu można podać długość rejestru [0-n]
    CSR_ADDR_WIDTH : natural := 3 
  ) 
  port (
    clk, rst_n : in std_logic; 
    . . . 
    -- csr interface signals
    csr_address:    in  std_logic_vector(CSR_ADDR_WIDTH - 1 downto 0);
    csr_read:       in  std_logic;
    csr_readdata:   out std_logic_vector(CSR_WIDTH - 1 downto 0);
    csr_write:      in  std_logic;
    csr_writedata:  in  std_logic_vector(CSR_WIDTH - 1 downto 0);
    csr_waitrequest : out std_logic;
    . . . 
    -- -------------------------------------------------------------
    -- pozostałe interfejsy
  );
end entity <entity-name>;


architecture <arch-name> of <avmm-csr-snippet> is
  
subtype word_t is std_logic_vector(CSR_WIDTH - 1  downto 0);
type register_t is array(integer range <>) of word_t;

function init_csr
  return register_t is
  variable temp: register_t(CSR_LENGTH - 1 downto 0);
  begin
    -- tutaj możesz podefiniować domyślne wartości csr po resecie i po power-up
    temp := (others => (others => '0'));
    return temp;
  end init_csr;


signal csr_reg: register_t := init_csr;

-- aliasy do obszarów w csr
alias status_reg:   std_logic_vector(CSR_WIDTH - 1 downto 0)  is csr_reg(0);
alias control_reg:  std_logic_vector(CSR_WIDTH - 1 downto 0)  is csr_reg(1);
alias key_reg:      register_t(31 downto 0)                   is csr_reg(33 downto 2);

-- aliasy do bitów w obrzarach
alias some_flag_0 : std_logic is status_reg(0);
alias some_flag_1 : std_logic is status_reg(1);
. . . 

signal out_waitrequest : std_logic;


begin

  csr_waitrequest <= out_waitrequest and (csr_write or csr_read);

  -- #1 odczyt asynchroniczny lub patrz #2
  csr_readdata <= csr(to_integer(unsigned(csr_address)));
  
  csr_proc: process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        csr <= init_csr;
        -- lub
        -- csr <= (others => (others => '0'));
      else

        if csr_write = '1' then
          csr(to_integer(unsigned(csr_address))) <= csr_writedata;
        end if;

        -- -- #2 odczyt synchroniczny
        -- if csr_read = '1' then
        --   csr_readdata <= csr(to_integer(unsigned(csr_address)));
        -- end if;

      end if;
    end if;
  end process csr_proc;

  out_waitrequest_proc: process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        out_waitrequest <= '1';
      else
        -- reset sygnału waitrequest
        if csr_write = '1' or csr_read = '1' then
          out_waitrequest <= '0';
        end if;

        -- ponowne ustawienie waitrequest po pojedynczym transferze
        if out_waitrequest = '0' and (csr_write = '1' or csr_read = '1') then
          out_waitrequest <= '1';
        end if;

      end if;
    end if;
  end process out_waitrequest_proc;  
  
end architecture <arch-name>;
