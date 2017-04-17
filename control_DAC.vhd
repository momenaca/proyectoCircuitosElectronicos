--------------------------------------------------------------------------------------------------------------------------
-- CONTROL DAC
--
-- Este modulo se encarga de enviar y recibir todas las senales que deben llegar al DAC. Lo realiza mediante un automata
-- de 3 estados.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_DAC is
      Port (
		   clk : in std_logic; -- Reloj PFGA
			Rst : in std_logic; -- Inicialziamos todo (sw7)
			start_DAC : in std_logic; -- Empieza a funcionar
			CS1 : out std_logic; -- Activa la conexion con el DAC
			SCLK : out std_logic; -- Senal de control
			end_DAC : out std_logic; -- Fin de la operacion
			DIN : out std_logic; -- Senal de dato
			valor_DAC : in std_logic_vector(11 downto 0)); -- Valor binario a enviar al DAC
end control_DAC;

architecture behavior of control_DAC is

signal st : std_logic_vector(1 downto 0); -- Estados del automata
signal fin_de_cuenta : std_logic := '0'; -- Fin primer contador
signal bit_DIN : std_logic_vector(3 downto 0); -- Contador interno para las senales de control 
signal dato_DAC : std_logic_vector(15 downto 0); -- Dato a enviar al DAC
signal en_cnt : std_logic :='0'; -- Enable para sincronizar
signal contador : std_logic_vector(5 downto 0):= (others => '0'); -- Primer contador
signal SCLK_aux : std_logic :='0'; -- SCLK generada

BEGIN

PROCESS(Rst,clk) -- Contador de 1us
begin
	if (st= "00" OR Rst ='1') then -- Si "00" o Rst activado, inicializamos la cuenta
		contador <= (others => '0');
		fin_de_cuenta <='0';

	elsif clk'event and clk='1' then
		fin_de_cuenta <= '0';
		if en_cnt='1' then
		  contador <= contador + '1';
		  end if;
		if contador >= 50 then -- Valor máximo de cuenta
			fin_de_cuenta <= '1';
			contador <= (others => '0');
		end if;
	end if;
end process;
	

PROCESS(Rst,clk) -- Segundo contador que genera SCLK
begin 
	if (st="00" OR Rst='1') then
	SCLK_aux<='0';
	elsif clk'event and clk='1' then
		if fin_de_cuenta='1' then
			SCLK_aux<= not SCLK_aux;
		end if;
	end if;
end process;
             	
					
PROCESS (Rst, clk) -- Descripcion funcionamiento del automata
BEGIN
	IF (Rst = '1') THEN -- Inicializar
		CS1 <= '1';
		DIN <= '0';
		en_cnt <='0';
		end_DAC <='0';
		st <= "00";
		bit_DIN <= (others => '0');
		dato_DAC <= (others => '0');

	ELSIF clk'event and clk = '1' THEN
		CASE st IS
		WHEN "00" => -- Reposo (Estado 00)
		CS1 <='1'; -- No interactuamos con el DAC
		DIN <='0'; -- No usamos DIN para enviar datos
		bit_DIN <= (others => '0');
		end_DAC <='0';
		en_cnt <='0';
		dato_DAC <= "000" & valor_DAC & '0'; -- Precarga del dato a enviar
		IF start_DAC = '1' THEN st <= "01";
		END IF;


		WHEN "01" => -- Entrega del dato (Estado 01)
		en_cnt <= '1';
		CS1 <= '0'; -- Interactuamos con el DAC
		DIN <= dato_DAC(15); -- Le asignamos el primer bit que se envia y que ira alternando 
		IF (fin_de_cuenta = '1' and SCLK_aux = '1') THEN
		dato_DAC<= dato_DAC(14 downto 0) & '0'; -- Desplaza el bit de envio
		bit_DIN <= bit_DIN + "01";
			IF bit_DIN >= "1111" THEN -- Se ha enviado el dato completo
			st <= "11"; bit_DIN <= (others => '0');
			END IF;
		END IF;


		WHEN "11" => -- Envio senal final
		st <= "00";
		end_DAC <='1';
		CS1 <= '1';

		WHEN others =>
		st <= "00";
		END CASE;
	END IF;

END PROCESS;

SCLK <= SCLK_aux; -- Asignamos sclk a esta senal

END behavior;