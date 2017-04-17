--------------------------------------------------------------------------------------------------------------------------
-- TOP DIGITAL
--
-- Este modulo se encarga de mapear todas las conexiones entre el resto de modulos del proyecto. Ademas selecciona alterna
-- tivamente las senales DIN y SCLK en funcion del uso del ADC y DAC.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_digital is
 Port( Puls0	: in std_logic; -- Incrementa 1
			Puls1	: in std_logic; -- Decrementa 1
			Puls2	: in std_logic; -- Incrementa 10
			Puls3	: in std_logic; -- Decrementa 10
			sw : in  std_logic_vector(5 downto 0); -- Codigo predefinido mediante los switches
			sw7 : in std_logic; -- Switch que activa el reset
			sw6 : in std_logic; -- Switch que activa los LEDS
			clk : in std_logic; -- reloj de la FPGA
			DOUT : in std_logic; -- senal de datos del ADC
			Seg7 : out std_logic_vector(0 to 6); -- Conjunto de LEDs que activan el display
			LEDS : out std_logic_vector(7 downto 0); -- Conjunto de leds, que representan el transito de bits del ADC
			Disp0 : out std_logic; -- Seleccion display a iluminar
			Disp1 : out std_logic;
			Disp2 : out std_logic;
			Disp3 : out std_logic;
			CS0 : out std_logic; -- Activa la conexion con el ADC
			DIN : out std_logic; -- senal de transferencia de datos con el ADC/DAC
			SCLK : out std_logic; -- senal de control del ADC/DAC
			CS1 : out std_logic -- Activa la conexion con el DAC
			);
end top_digital;

architecture Hierarchical of top_digital is

component control_pulsadores is
    Port ( clk : in  STD_LOGIC; -- Relog FPGA
           Rst : in  STD_LOGIC; -- reset Swtich 0
           Up0 : in  STD_LOGIC; -- Incrementa 1
           Down0 : in  STD_LOGIC; -- Decrementa 1
			  Up1 : in  STD_LOGIC; -- Incrementa 10
			  Down1 : in  STD_LOGIC; -- Decrementa 10
           b : out  STD_LOGIC_VECTOR (5 downto 0) -- Salida registro
			  );
end component;

component control_displays is
    Port ( clk : in  STD_LOGIC; -- Reloj FPGA
           b : in  STD_LOGIC_VECTOR (5 downto 0); -- Codigo usuario
			  sw : in STD_LOGIC_VECTOR (5 downto 0); --Codigo predefinido
           Disp0 : out  STD_LOGIC; -- Seleccion display a iluminar
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (0 to 6)  -- Conjunto de LEDs que activan el display
			  );
end component;

component control_ADC IS
      Port (
		   clk : in std_logic; -- Reloj FPGA
			Rst : in std_logic; -- Inicializa todo (sw7)
			start_ADC : in std_logic; -- Empieza a funcionar
			DOUT : in std_logic; -- Entrada del ADC
			sw6 : in std_logic; -- activa LEDS;
			CS0 : out std_logic; -- Activa la conexion con el ADC
			SCLK : out std_logic; -- Senal de control
			end_ADC : out std_logic; -- Fin de la operacion
			DIN : out std_logic; -- Senal de peticion
			LEDS : out std_logic_vector(7 downto 0); -- Muestra los 8 bits mas significativos de Valor_ADC
			valor_ADC : out std_logic_vector(11 downto 0) -- Valor binario recibido desde el ADC
			);
end component;

component control_DAC IS
      Port (
		   clk : in std_logic; -- Reloj PFGA
			Rst : in std_logic; -- Inicialziamos todo (sw7)
			start_DAC : in std_logic; -- Empieza a funcionar
			CS1 : out std_logic; -- Activa la conexion con el DAC
			SCLK : out std_logic; -- Senal de control
			end_DAC : out std_logic; -- Fin de la operacion
			DIN : out std_logic; -- Senal de dato
			valor_DAC : in std_logic_vector(11 downto 0) -- Valor binario a enviar al DAC
			); 
end component;

component control_global is
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
end component;

component pseudo_random is
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
end component;

signal s_b : STD_LOGIC_VECTOR(5 DOWNTO 0); -- Codigo del usuario
signal s_end_ADC : std_logic; -- Indica si se ha acabado de interactuar con el ADC
signal s_end_DAC : std_logic; -- Indica si se ha acabado de interactuar con el DAC
signal s_end_random : std_logic; -- Indica si se ha acabado realizar la encriptacion
signal s_start_random : std_logic; -- Indica el inicio del proceso de encriptacion
signal s_start_ADC : std_logic; -- Indica el inicio del proceso de transferencia/captura al ADC
signal s_start_DAC : std_logic; -- Indica el inicio del proceso de transferencia con el DAC
signal s_valor_ADC : std_logic_vector(11 downto 0); -- Valor obtenido despues de interactuar con el ADC
signal s_valor_DAC : std_logic_vector(11 downto 0); -- Valor que se envia al DAC
signal s_global_st : std_logic_vector(1 downto 0); -- Estado del control global
signal s_DINadc : std_logic; -- Diferenciamos los DIN y SCLK porque compartimos estas 2 senales entre el ADC/DAC.
signal s_DINdac : std_logic; -- Necesitaremos alternar entre estas 4 senales dependiendo del uso del ADC o del DAC.
signal s_SCLKadc : std_logic; -- Debajo de los port maps esta la implementacion para conseguir esto.
signal s_SCLKdac : std_logic; 
signal s_CS0 : std_logic; -- senal que indica si se esta interactuando con el ADC
signal s_CS1 : std_logic; -- senal que indica si se esta interactuando con el DAC

begin

U1: control_pulsadores 
		port map(
		clk => clk,
		Rst => sw7,
		Up0 => Puls0,
		Up1 => Puls2,
		Down0 => Puls1,
		Down1 => Puls3,
		b => s_b
		);

U2: control_displays 
		port map(
		clk => clk,
		b => s_b,
		sw => sw,
		Disp0 => Disp0,
		Disp1 => Disp1,
		Disp2 => Disp2,
		Disp3 => Disp3,
		Seg7 => Seg7
		);

U3: control_ADC 
		port map(
		clk => clk,
		Rst => sw7,
		start_ADC => s_start_ADC,
		DOUT => DOUT,
		sw6 => sw6,
		CS0 => s_CS0,
		SCLK => s_SCLKadc,
		end_ADC => s_end_ADC,
		DIN => s_DINadc,
		LEDS => LEDS,
		valor_ADC => s_valor_ADC
		);


U4: control_DAC 
		port map(
		clk => clk,
		Rst => sw7,
		start_DAC => s_start_DAC,
		CS1 => s_CS1,
		SCLK => s_SCLKdac,
		end_DAC => s_end_DAC,
		DIN => s_DINdac,
		valor_DAC => s_valor_DAC
		);

U5: control_global 
		port map(
		clk => clk,
		Rst => sw7,
		end_ADC => s_end_ADC,
		end_random => s_end_Random,
		end_DAC => s_end_DAC,
		start_random => s_start_random,
		start_ADC => s_start_ADC,
		start_DAC => s_start_DAC,
		global_st => s_global_st
		);

U6: pseudo_random 
		port map(
		clk => clk,
		Rst => sw7,
		start_random => s_start_random,
		sw => sw,
		b => s_b,
		valor_DAC => s_valor_DAC,
		valor_ADC => s_valor_ADC,
		end_random => s_end_random
		);


process(clk) -- Implementacion que permite alternar entre las senales DIN y SCLK del ADC/DAC
begin
	if s_CS1='0' then -- Cuando se este usando el DAC usamos el DIN y SCLK del modulo de control DAC
		DIN <= s_DINdac;
		SCLK <= s_SCLKdac;
	elsif s_CS0='0' then -- Cuando se este usando el ADC usamos el DIN y SCLK del modulo de control ADC
		DIN <= s_DINadc;
		SCLK <= s_SCLKadc;	
	end if;
end process;

CS0<=s_CS0; -- Asignamos el valor de la senal utilizada anteriormente
CS1<=s_CS1;

end Hierarchical;