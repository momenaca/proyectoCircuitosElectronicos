--------------------------------------------------------------------------------------------------------------------------
-- PSEUDO RANDOM
--
-- Este modulo se encarga de comparar el codigo predefinido de cifrado con el codigo del usuario. En caso de ser iguales
-- enviara la senal directamente al DAC. En el caso contrario, se generara un codigo pseudo aleatorio que se entregara al
-- DAC.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pseudo_random is
       port (
		      clk : in std_logic; -- reloj FPGA
				Rst : in std_logic; -- Inicializamos todo (sw7)
				start_random : in std_logic; -- Empieza a funcionar
				sw : in std_logic_vector (5 downto 0); -- Codigo predefinido de cifrado
				b : in std_logic_vector (5 downto 0); -- Codigo introducido por el usuario
				valor_DAC : out std_logic_vector (11 downto 0); -- Valor binario a enviar al DAC
				valor_ADC : in std_logic_vector (11 downto 0); -- Valor recibido del ADC
				end_random : out std_logic -- Fin de la operacion
				);
end pseudo_random;

architecture Behavioral of pseudo_random is

signal codigo_aleatorio : std_logic_vector (15 downto 0); -- Senal para generar el codigo aleatorio
signal salida_xor: std_logic; -- salida de las puertas XOR

begin
process(clk, Rst) -- Generamos un posible codigo aleatorio mediante el uso de un LFSR de 4 bits
begin
	if Rst= '1' then -- Iniciamos el valor del registro de desplazamiento a 1 para evitar que se quede todo a 0
		codigo_aleatorio <= "0000000000000001";
		salida_xor<= (((codigo_aleatorio(15) XOR codigo_aleatorio(13))
		XOR codigo_aleatorio(12))XOR codigo_aleatorio(10));
		
	elsif clk'event and clk='1' then -- Concatenamos la salida de las puertas XOR a la senal codigo para crear
		salida_xor<= (((codigo_aleatorio(15) XOR codigo_aleatorio(13)) -- un codigo aleatorio
		XOR codigo_aleatorio(12))XOR codigo_aleatorio(10));
		codigo_aleatorio<= codigo_aleatorio(14 downto 0) & salida_xor;
		end if;
end process;
        	
			
process(clk, Rst) -- Enviamos datos al DAC
begin 
	if Rst ='1' then 
	  valor_DAC <= "000000000000";
	  end_random <='1';
	elsif clk'event and clk='1' then
		if start_random ='1' then 
			if b=sw then -- Si codigo usuario coincide con el predefinido
			  valor_DAC <= valor_ADC + "100000000000"; -- Enviamos lo obtenido del ADC mas un offset de x800
			 end_random <='1';
			else -- Si no coinciden los codigos enviamos una senal aleatoria
			  valor_DAC <= codigo_aleatorio(11 downto 0);
			  end_random <='1';
			end if;
		end if;
	end if;
end process;
end Behavioral;