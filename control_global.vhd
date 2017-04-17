--------------------------------------------------------------------------------------------------------------------------
-- CONTROL GLOBAL
--
-- Este modulo se encarga gestionar los bloques que dependen de el. Para ello utiliza senales de tipo inicio y fin para 
-- concatenar los procesamientos de los bloques. Ademas implementa un automata para facilitar la depuracion del programa.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_global is
    port (
	       clk : in std_logic; -- reloj FPGA
			 Rst : in std_logic; -- Inicializa todo
			 end_ADC : in std_logic; -- Indica que el modulo ADC ha acabado
			 end_random : in std_logic; -- Indica que el modulo random ha acabado
			 end_DAC : in std_logic; -- Indica que el modulo DAC ha acabado
			 start_random : out std_logic; -- Inicia el modulo random
			 start_ADC : out std_logic; -- Inicia el modulo ADC
			 start_DAC : out std_logic; -- Inicia el modulo DAC
			 global_st : out std_logic_vector (1 downto 0) -- Distintos estados del automata
			 );
end control_global;

architecture Behavioral of control_global is

    signal s_start_DAC : std_logic ;
	 signal s_start_ADC : std_logic;
	 signal s_start_random : std_logic;
	 signal s_global_st : std_logic_vector(1 downto 0) := (others => '0');
	 signal contador : std_logic_vector(12 downto 0) := (others => '0');
	 signal fin_de_cuenta : std_logic;

begin

process(clk) -- Contador interno de 125 us
begin
	 if clk'event and clk='1' then
		 fin_de_cuenta <= '0';
		 contador <= contador + '1';
		 if contador >= 6250 then -- Valor maximo de la cuenta
			 fin_de_cuenta <= '1';
			 contador <= (others => '0');
		 end if;
	  end if;
end process;

process (end_random, end_ADC, fin_de_cuenta, end_DAC) -- Descripcion del automata
begin	  
  if s_global_st = "00" and fin_de_cuenta ='1' then																
  s_start_ADC <='1';  -- Estado de reposo, cuando hayan pasado 125us activamos      
  s_global_st <="01"; -- el control del ADC pasando al estado "01"
  end if;
  
  if s_global_st = "01" and end_ADC ='1' then 
  s_start_random <='1'; -- Estado "01", cuando acabe de capturar datos 
  s_start_ADC <= '0';   -- el ADC pasamos a la encriptacion
  s_global_st <="11";
  end if;
  
  if s_global_st = "11" and end_random='1' then
  s_start_random <='0'; -- Estado "11", cuando acabe la encriptacion
  s_start_DAC <= '1';   -- enviamos datos con el DAC
  s_global_st <= "10";
  end if;
  
  if s_global_st = "10" and end_DAC ='1' then
  s_start_DAC <='0';  -- Estado "10", cuando acabe de enviar datos al DAC
  s_global_st <="00"; -- volvemos al estado de reposo
  end if;  
end process;

start_DAC <= s_start_DAC; -- Asignamos las salidas a las senales utilizadas anteriormente
start_ADC <= s_start_ADC;
global_st <= s_global_st;
start_random <= s_start_random;

end Behavioral;