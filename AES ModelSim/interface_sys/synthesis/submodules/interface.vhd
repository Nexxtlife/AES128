library ieee;
use ieee.std_logic_1164.all;

entity interface is
	port(
			clk_clk                                   : in  std_logic                      := 'X';             -- clk
			reset_reset_n                             : in  std_logic                      := 'X';             -- reset_n
			interface_0_avalon_master_1_read          : out std_logic;                                         -- read
			interface_0_avalon_master_1_address       : out std_logic_vector(4 downto 0);                      -- address
			interface_0_avalon_master_1_byteenable    : out std_logic_vector(15 downto 0);                     -- byteenable
			interface_0_avalon_master_1_readdata      : in  std_logic_vector(127 downto 0) := (others => 'X'); -- readdata
			
			interface_0_avalon_streaming_source_data  : out std_logic_vector(127 downto 0);                    -- data
			interface_0_avalon_streaming_source_ready : in  std_logic                      := 'X';             -- ready
			interface_0_avalon_streaming_source_valid : out std_logic                                          -- valid
	);
end interface;

architecture behavior of interface is
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
	signal plaintext : std_logic_vector(127 downto 0);
	signal key : std_logic_vector(127 downto 0);	
	
	signal done : std_logic;
	signal ciphertext : std_logic_vector(127 downto 0);	
	constant clk_period : time := 10 ns;
	
begin
	
	enc_inst : aes_enc
				port map(
					clk        => clk_clk,
					rst        => reset_reset_n,
					key        => key,
					plaintext  => plaintext,
					ciphertext => ciphertext,
					done       => done
	);


	process (clk_clk)
	begin
	if rising_edge(clk_clk) then
		if(reset_reset_n ='1') then
			interface_0_avalon_streaming_source_data <= (others =>'0');
			interface_0_avalon_streaming_source_valid <='0';
		elsif(interface_0_avalon_streaming_source_ready = '1') then
				interface_0_avalon_master_1_read <= '1';
				interface_0_avalon_master_1_address <= "00000";
				interface_0_avalon_master_1_byteenable <= x"FFFF";
				plaintext <= interface_0_avalon_master_1_readdata;

		
				--plaintext <= x"54776F204F6E65204E696E652054776F";
				key <= x"5468617473206D79204B756E67204675";
				
				--wait until done = '1';
				interface_0_avalon_streaming_source_data <= ciphertext;
				interface_0_avalon_streaming_source_valid <= '1';
				interface_0_avalon_streaming_source_data <= (others=>'0');
				interface_0_avalon_streaming_source_valid <= '0';
		end if;
	end if;
	
	end process;

	
end architecture behavior;