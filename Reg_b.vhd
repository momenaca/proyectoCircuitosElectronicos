--------------------------------------------------------------------------------------------------------------------------
-- REGISTRO B
--
-- Este modulo es un registro que contiene en binario el valor del codigo introducido por el usuario. Es capaz de variar
-- su valor en funcion de las senales que provienen del automata siempre que los valores esten entre (0-63) que son los
-- valores permitidos.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg_b is
    Port ( clk  : in  STD_LOGIC; -- Reloj FPGA
           sel : in  STD_LOGIC_VECTOR (1 downto 0); -- Decrementa/Incrementa
           en_b : in  STD_LOGIC; -- Habilita registro
           rst_b : in  STD_LOGIC; -- Inicializa registro
           b : out  STD_LOGIC_VECTOR (5 downto 0)); -- Valor codigo usuario en binario
end Reg_b;

architecture Behavioral of Reg_b is

signal s_Reg_b : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');	

begin

registro : process (rst_b,clk)
begin
	if (rst_b = '1') then
		s_Reg_b <= "000000"; -- CCCCC es el valor inicial de la cuenta
	elsif clk'event and clk='1' then
		if en_b = '1' then
			if ((sel = "00") and (s_Reg_b < "111111")) then -- DDDDD corresponde a 63 en binario
				s_Reg_b <= s_Reg_b + "01";
			end if;
			if ((sel = "01") and (s_Reg_b > "000000")) then -- EEEEE corresponde a 0 en binario
				s_Reg_b <= s_Reg_b - "01";
			end if;
			if ((sel = "10") and (s_Reg_b < "110110")) then -- FFFFF corresponde a 54 en binario
				s_Reg_b <= s_Reg_b + "01010";
			end if;
			if ((sel = "11") and (s_Reg_b > "001001")) then -- GGGGG corresponde a 9 en binario
				s_Reg_b <= s_Reg_b - "01010";
			end if;
		end if;
	end if;
end process;

b <= s_Reg_b; -- Asignamos a b la senal que hemos utilizado
	
end Behavioral;