--------------------------------------------------------------------------------------------------------------------------
-- CONTROL DISPLAYS
--
-- Este modulo se encarga de mapear todas las conexiones entre los modulos que se encargan de mostrar el valor del codigo 
-- de usuario almacenado.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_displays is
    Port ( clk : in  STD_LOGIC; -- Reloj FPGA
           b : in  STD_LOGIC_VECTOR (5 downto 0); -- Codigo usuario
			  sw : in STD_LOGIC_VECTOR (5 downto 0); -- Codigo predefinido
           Disp0 : out  STD_LOGIC; -- Seleccion display a iluminar
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (0 to 6)); -- Conjunto de LEDs que activan el display
end control_displays;

architecture Hierarchical of control_displays is

signal s_D0, s_D1, s_D2, s_D3 : STD_LOGIC_VECTOR(3 DOWNTO 0);	
signal s_D0_sw, s_D1_sw, s_D2_sw, s_D3_sw : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_cnt_5ms : STD_LOGIC;

component contador_5ms is
	Port ( clk : in  STD_LOGIC;
           cnt_5ms : out  STD_LOGIC);
end component;

component conversorBCD is
	Port ( clk : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (5 downto 0);
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);
           D3 : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component conversorBCD2 is
	Port ( clk : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (5 downto 0);
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);
           D3 : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component visualizacion is
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
end component;

begin

U1 : conversorBCD
		port map(
		clk => clk,
		b => b,
		D0 => s_D0,
		D1 => s_D1,
		D2 => s_D2,
		D3 => s_D3
		);

U2 : conversorBCD2
      port map(
	   clk => clk,
	   sw => sw,
	   D0 => s_D0_sw,
	   D1 => s_D1_sw,
	   D2 => s_D2_sw,
	   D3 => s_D3_sw
	   );		

U3 : contador_5ms
		port map(
		clk => clk,
		cnt_5ms => s_cnt_5ms
		);

U4 : visualizacion
		port map(
		clk => clk,
		cnt_5ms => s_cnt_5ms,
		Digito0 => s_D0,
		Digito1 => s_D1,
		Digito2 => s_D0_sw,
		Digito3 => s_D1_sw,
		Disp0 => Disp0,
		Disp1 => Disp1,
		Disp2 => Disp2,
		Disp3 => Disp3,
		Seg7 => Seg7
		);

end Hierarchical;