library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_std.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
library STD;
use STD.TEXTIO.ALL;

entity s_box is 
port(-- can still add load and rst the table from file
	data_in : in std_logic_vector(31 downto 0);
	data_out : out std_logic_vector(31 downto 0)
);
end entity;


architecture behave of s_box is

type table is array(0 to 255) of std_logic_vector(7 downto 0);




signal table_object: table;

signal temp_data_out:std_logic_vector(31 downto 0);

signal temp_data_in_1 : std_logic_vector(7 downto 0);
signal temp_data_in_2 : std_logic_vector(7 downto 0);
signal temp_data_in_3 : std_logic_vector(7 downto 0);
signal temp_data_in_4 : std_logic_vector(7 downto 0);

begin
table_object(0)<=x"63"; -- holding the sub table in a array ( takes more space)
table_object(1)<=x"7c";
table_object(2)<=x"77";
table_object(3)<=x"7b";
table_object(4)<=x"f2";
table_object(5)<=x"6b";
table_object(6)<=x"6f";
table_object(7)<=x"5c";
table_object(8)<=x"30";
table_object(9)<=x"01";
table_object(10)<=x"67";
table_object(11)<=x"2b";
table_object(12)<=x"fe";
table_object(13)<=x"d7";
table_object(14)<=x"ab";
table_object(15)<=x"76";
table_object(16)<=x"ca";
table_object(17)<=x"82";
table_object(18)<=x"c9";
table_object(19)<=x"7d";
table_object(20)<=x"fa";
table_object(21)<=x"59";
table_object(22)<=x"47";
table_object(23)<=x"f0";
table_object(24)<=x"ad";
table_object(25)<=x"d4";
table_object(26)<=x"a2";
table_object(27)<=x"af";
table_object(28)<=x"9c";
table_object(29)<=x"a4";
table_object(30)<=x"72";
table_object(31)<=x"c0";

--table_object(32)<=x"";
--table_object(33)<=x"";
--table_object(34)<=x"";
--table_object(35)<=x"";
--table_object(36)<=x"";
--table_object(37)<=x"";
--table_object(38)<=x"";
--table_object(39)<=x"";
--table_object(40)<=x"";
--table_object(41)<=x"";
--table_object(42)<=x"";
--table_object(43)<=x"";
--table_object(44)<=x"";
--table_object(45)<=x"";
--table_object(46)<=x"";
--table_object(47)<=x"";
--table_object(48)<=x"";
--table_object(49)<=x"";
--table_object(50)<=x"";
--table_object(51)<=x"";
--table_object(52)<=x"";
--table_object(53)<=x"";
--table_object(54)<=x"";
--table_object(55)<=x"";
--table_object(56)<=x"";
--table_object(57)<=x"";
--table_object(58)<=x"";
--table_object(59)<=x"";
--table_object(60)<=x"";
--table_object(61)<=x"";
--table_object(62)<=x"";
--table_object(63)<=x"";

--table_object(64)<=x"";
--table_object(65)<=x"";
--table_object(66)<=x"";
--table_object(67)<=x"";
--table_object(68)<=x"";
--table_object(69)<=x"";
--table_object(70)<=x"";
--table_object(71)<=x"";
--table_object(72)<=x"";
--table_object(73)<=x"";
--table_object(74)<=x"";
--table_object(75)<=x"";
--table_object(76)<=x"";
--table_object(77)<=x"";
--table_object(78)<=x"";
--table_object(79)<=x"";
--table_object(80)<=x"";
--table_object(81)<=x"";
--table_object(82)<=x"";
--table_object(83)<=x"";
--table_object(84)<=x"";
--table_object(85)<=x"";
--table_object(86)<=x"";
--table_object(87)<=x"";
--table_object(88)<=x"";
--table_object(89)<=x"";
--table_object(90)<=x"";
--table_object(91)<=x"";
--table_object(92)<=x"";
--table_object(93)<=x"";
--table_object(94)<=x"";
--table_object(95)<=x"";

--table_object(96)<=x"";
--table_object(97)<=x"";
--table_object(98)<=x"";
--table_object(99)<=x"";
--table_object(100)<=x"";
--table_object(102)<=x"";
--table_object(103)<=x"";
--table_object(104)<=x"";
--table_object(105)<=x"";
--table_object(106)<=x"";
--table_object(107)<=x"";
--table_object(108)<=x"";
--table_object(109)<=x"";
--table_object(110)<=x"";
--table_object(111)<=x"";
--table_object(112)<=x"";
--table_object(113)<=x"";
--table_object(114)<=x"";
--table_object(115)<=x"";
--table_object(116)<=x"";
--table_object(117)<=x"";
--table_object(118)<=x"";
--table_object(119)<=x"";
--table_object(120)<=x"";
--table_object(121)<=x"";
--table_object(122)<=x"";
--table_object(123)<=x"";
--table_object(124)<=x"";
--table_object(125)<=x"";
--table_object(126)<=x"";
--table_object(127)<=x"";



process(data_in)
begin

				
			data_out <= table_object(to_integer(unsigned(data_in(31 downto 24)))) & table_object(to_integer(unsigned(data_in(23 downto 16)))) & table_object(to_integer(unsigned(data_in(15 downto 8)))) & table_object(to_integer(unsigned(data_in(7 downto 0))));

	
end process;


end behave;