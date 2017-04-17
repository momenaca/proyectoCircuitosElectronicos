library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity visualizacion is
    Port ( clk : in  STD_LOGIC;
           cnt_5ms : in  STD_LOGIC;
           Digito0 : in  STD_LOGIC_VECTOR (3 downto 0);
           Digito1 : in  STD_LOGIC_VECTOR (3 downto 0);
           Digito2 : in  STD_LOGIC_VECTOR (3 downto 0);
           Digito3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (0 to 6));
end visualizacion;

architecture Behavioral of visualizacion is

signal sel : STD_LOGIC_VECTOR(1 downto 0):=(others => '0');
signal s_Dig : STD_LOGIC_VECTOR(3 downto 0) :=(others => '0');

begin

	process (clk)
		begin
		if clk'event and clk='1' then
			if cnt_5ms='1' then
				sel <= sel+"01";
				end if;
			end if;
	end process;

	process (sel, Digito0, Digito1, Digito2, Digito3)
		begin
		s_Dig <= Digito0; -- asignación por defecto
		Disp0 <= '1'; Disp1 <= '1'; Disp2<='1'; Disp3 <='1'; -- por defecto
		case sel is
			when "00" => Disp0<='0';s_Dig <= Digito0;
			when "01" => Disp1<='0';s_Dig <= Digito1;
			when "10" => Disp2<='0';s_Dig <= Digito2;
			when "11" => Disp3<='0';s_Dig <= Digito3;
		when others => Disp0 <= '1';
		end case;
		end process;

	 	with s_Dig select Seg7 <=
			 "0000001" when "0000",
			 "1001111" when "0001",
			 "0010010" when "0010",
			 "0000110" when "0011",
			 "1001100" when "0100",
			 "0100100" when "0101",
			 "0100000" when "0110",
			 "0001111" when "0111",
			 "0000000" when "1000",
			 "0001100" when "1001",
			 "1111111" when others;
end Behavioral;

