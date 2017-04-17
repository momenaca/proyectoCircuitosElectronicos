--------------------------------------------------------------------------------------------------------------------------
-- CONTROL ADC
--
-- Este modulo se encarga de enviar y recibir todas las senales que deben llegar al ADC. Para ello, envia un byte de 
-- peticion y luego recibe la respuesta que entrega al siguiente bloque. Todo esto lo realiza mediante un automata de 4
-- estados.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_ADC is
      Port (
		   clk : in std_logic; -- Reloj FPGA
			Rst : in std_logic; -- Inicializa todo (sw7)
			start_ADC : in std_logic; -- Empieza a funcionar
			DOUT : in std_logic; -- Entrada del ADC
			sw6 : in std_logic; -- Switch que activa los LEDS
			CS0 : out std_logic; -- Activa la conexion con el ADC
			SCLK : out std_logic; -- Senal de control
			end_ADC : out std_logic; -- Fin de la operacion
			DIN : out std_logic; -- Senal de peticion
			LEDS : out std_logic_vector(7 downto 0); -- Conjunto de leds, que representan el transito de bits del ADC
			valor_ADC : out std_logic_vector(11 downto 0)); -- Valor binario recibido desde el ADC
end control_ADC;

architecture behavior of control_ADC is

signal st : std_logic_vector(1 downto 0); -- Estados del automata contador
signal byte_peticion_ADC : std_logic_vector(7 downto 0); -- Peticion al ADC
signal fin_de_cuenta : std_logic := '0'; -- Fin del primer contador
signal bit_DIN : std_logic_vector(3 downto 0); -- Contador interno para las senales de control
signal dato_ADC : std_logic_vector(15 downto 0); -- Dato que sacas del ADC
signal en_cnt : std_logic :='0'; -- Enable para sincronizar
signal contador : std_logic_vector(5 downto 0):= (others => '0'); -- Primer contador
signal SCLK_aux : std_logic :='0'; -- SCLK generada
BEGIN

PROCESS(Rst,clk) -- Contador de 1us
begin
	if ( st= "00" OR Rst ='1') then -- Si "00" o Rst activado, inicializamos la cuenta
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
	
PROCESS(Rst,clk) -- Segundo contador que genera la senal SCLK
begin 
	if (st="00" OR Rst='1') then 
		 SCLK_aux<='0';	 
	elsif clk'event and clk='1' then
		if fin_de_cuenta='1' then -- Cada vez que pasa 1us, cambia su estado generando SCLK
			SCLK_aux<= not SCLK_aux;
		end if;
	end if;
end process;
             		

PROCESS (Rst, clk) -- Descripcion funcionamiento automata
BEGIN
	IF (Rst = '1') THEN -- Inicializar 
		CS0 <= '1';
		DIN <= '0';
		en_cnt <='0';
		end_ADC <='0';
		st <= "00";
		valor_ADC <= (others => '0');
		bit_DIN <= (others => '0');
		dato_ADC <= (others => '0');
		byte_peticion_ADC <= (others => '0');

	ELSIF clk'event and clk = '1' THEN 
		CASE st IS
		WHEN "00" => -- Reposo (Estado 00) ponemos contadores a 0, CS y DIN desactivados
		CS0 <='1';
		DIN <='0';
		bit_DIN <= (others => '0');
		end_ADC <='0';
		en_cnt <='0';
		byte_peticion_ADC <= "10010111"; -- Precarga del byte de peticion (97)
			IF start_ADC = '1' THEN st <= "01";
			END IF;

		WHEN "01" => -- Entrega de la peticion (Estado 01)
		en_cnt <= '1';
		CS0 <= '0';
		DIN <= byte_peticion_ADC(7); -- Le asignamos el primer bit que se envia y que ira alternando
			IF (fin_de_cuenta = '1' and SCLK_aux = '1') THEN
			byte_peticion_ADC <= byte_peticion_ADC(6 downto 0) & '0'; -- Desplaza petición
			bit_DIN <= bit_DIN + "01";
				IF bit_DIN >= "0111" THEN -- Se ha enviado la peticion completa
				st <= "10"; bit_DIN <= (others => '0');
				END IF;
			END IF;

		WHEN "10" => -- Recepcion de los datos serie (Estado 10)
		CS0 <= '0';
		en_cnt <= '1';
			IF (fin_de_cuenta = '1' and SCLK_aux = '0') THEN -- Flanco de subida de SCLK
			dato_ADC <= dato_ADC(14 downto 0) & DOUT; -- Recepcion serie
			END IF;
			IF (fin_de_cuenta = '1' and SCLK_aux = '1') THEN -- Flanco de bajada de SCLK
			bit_DIN <= bit_DIN + "01";
				IF bit_DIN = "1111" THEN -- Se ha recibido el dato completo
				st <= "11"; bit_DIN <= (others => '0');
				END IF;
			END IF;

		WHEN "11" => -- Entrega del dato de salida, y final (Estado 11)
		CS0 <= '1'; -- Finaliza la comunicación con el ADC
		st <= "00";
		valor_ADC <= dato_ADC(14 downto 3);
		
		 if(sw6 ='1') then              -- Si sw6 es '1', se muestra mediante los leds los 8 bits mas significativos
		   LEDS<=dato_ADC(14 downto 7); -- del dato_ADC, por el contrario, permanencen apagados.
       else 
           LEDS<=(others => '0');
	    end if;
			
		end_ADC <='1';
		
		WHEN others =>
		st <= "00";
		END CASE;
	END IF;
END PROCESS;

SCLK <= SCLK_aux; -- Asignamos salida a la senal utilizada anteriormente
END behavior;