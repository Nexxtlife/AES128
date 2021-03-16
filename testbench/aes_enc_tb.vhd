library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library design_lib;
use design_lib.all;

entity aes_enc_tb is
end entity aes_enc_tb;

architecture sim of aes_enc_tb is
 
constant PERIOD : time := 10 ns;
  
signal clk_tb : std_logic := '0';
signal rst_tb : std_logic := '0';
signal key_tb : std_logic_vector(127 downto 0) := (others => '0');
signal plaintext_tb : std_logic_vector(127 downto 0) := (others => '0');
signal ciphertext_tb : std_logic_vector(127 downto 0);
signal done_tb : std_logic;

signal stop_clk : boolean := false;

begin
  
  -- instancja modułu testowanego
  DUT : entity design_lib.aes_enc(behavioral)
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
    -- testowanego modułu. --3925841d02dc09fbdc118597196a0b32
	plaintext_tb <= x"3243f6a8885a308d313198a2e0370734";
	key_tb <= x"2b7e151628aed2a6abf7158809cf4f3c";
	wait for PERIOD * 1;
	wait until done_tb = '1'; --3925841D02DC09FBDC118597196A0B32
	wait for PERIOD/2;
	if (ciphertext_tb = x"3925841D02DC09FBDC118597196A0B32") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	wait for PERIOD * 1;
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"80000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"0EDD33D3C621E546455BD8BA1418BEC8") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"40000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"C0CC0C5DA5BD63ACD44A80774FAD5222") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"20000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"2F0B4B71BC77851B9CA56D42EB8FF080") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"10000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"6B1E2FFFE8A114009D8FE22F6DB5F876") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"08000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"9AA042C315F94CBB97B62202F83358F5") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"04000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"DBE01DE67E346A800C4C4B4880311DE4") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"02000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"C117D2238D53836ACD92DDCDB85D6A21") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"01000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"DC0ED85DF9611ABB7249CDD168C5467E") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00800000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"807D678FFF1F56FA92DE3381904842F2") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00400000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"0E53B3FCAD8E4B130EF73AEB957FB402") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00200000000000000000000000000000";
	key_tb <= x"80000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"969FFD3B7C35439417E7BDE923035D65") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00100000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"A99B512C19CA56070491166A1503BF15") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00080000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"6E9985252126EE344D26AE369D2327E3") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00040000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"B85F4809F904C275491FCDCD1610387E") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00020000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"ED365B8D7D20C1F5D53FB94DD211DF7B") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00010000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"B3A575E86A8DB4A7135D604C43304896") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00008000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"89704BCB8E69F846259EB0ACCBC7F8A2") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00004000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"C56EE7C92197861F10D7A92B90882055") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00002000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"92F296F6846E0EAF9422A5A24A08B069") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00001000000000000000000000000000";
	key_tb <= x"80000000000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"E67E32BB8F11DEB8699318BEE9E91A60") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000800000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"B08EEF85EAF626DD91B65C4C3A97D92B") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000400000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"661083A6ADDCE79BB4E0859AB5538013") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000200000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"55DFE2941E0EB10AFC0B333BD34DE1FE") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000100000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"6BFE5945E715C9662609770F8846087A") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000080000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"79848E9C30C2F8CDA8B325F7FED2B139") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000040000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"7A713A53B99FEF34AC04DEEF80965BD0") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000020000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"18144A2B46620D32C3C32CE52D49257F") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000010000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"872E827C70887C80749F7B8BB1847C7E") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000008000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"6B86C6A4FE6A60C59B1A3102F8DE49F3") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000004000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"9848BB3DFDF6F532F094679A4C231A20") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
	
	wait until rising_edge(clk_tb) and rst_tb = '0';
	plaintext_tb <= x"00000000000000000000000000000000";
	key_tb <= x"00000002000000000000000000000000";
	wait for PERIOD * 1;
	wait until done_tb = '1';
	wait for PERIOD/2;
	if (ciphertext_tb = x"925AD528E852E329B2091CD3F1C2BCEE") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
	end if;
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
wait for PERIOD * 2;
rst_tb <= '1';
wait until done_tb = '1';
rst_tb <= '0';
end process;


end architecture sim;
