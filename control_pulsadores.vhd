--------------------------------------------------------------------------------------------------------------------------
-- CONTROL PULSADORES
--
-- Este modulo se encarga de mapear todas las conexiones entre los modulos que permiten generar y mantener el valor que va
-- a tener el codigo de usuario.	
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_pulsadores is
    Port ( clk : in  STD_LOGIC; -- Relog FPGA
           Rst : in  STD_LOGIC; -- reset Switch 7
           Up0 : in  STD_LOGIC; -- Incrementa 1
           Down0 : in  STD_LOGIC; -- Decrementa 1
			  Up1 : in  STD_LOGIC; -- Incrementa 10
			  Down1 : in  STD_LOGIC; -- Decrementa 10
           b : out  STD_LOGIC_VECTOR (5 downto 0)); -- Salida registro b
end control_pulsadores;

architecture Hierarchical of control_pulsadores is

signal s_cnt_100ms,s_rst_cnt,s_en_cnt,s_rst_b,s_en_b: STD_LOGIC := '0';
signal s_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

component MooreFSM is
		Port ( clk : in  STD_LOGIC; -- Relog FPGA
					  Up0 : in  STD_LOGIC; -- Incremento 1
					  Down0 : in  STD_LOGIC; -- Decremento 1
					  Up1 : in  STD_LOGIC; -- Incremento 10
					  Down1 : in  STD_LOGIC; -- Decremento 10
					  Rst : in  STD_LOGIC; -- Inicializa todo
					  cnt_100ms : in  STD_LOGIC; -- Cuenta 100ms
					  rst_cnt : out  STD_LOGIC; -- Inicializa contador
					  en_cnt : out  STD_LOGIC; -- Habilita contador
					  rst_b : out  STD_LOGIC; -- Inicializa registro
					  en_b : out  STD_LOGIC; -- Habilita incremento/decremento
					  sel : out  STD_LOGIC_VECTOR (1 downto 0)); -- Incremento/decremento
	end component;

component contador_100ms is
		Port ( clk : in  STD_LOGIC; -- Reloj FPGA
				  rst_cnt : in  STD_LOGIC; -- Inicialización contador
				  en_cnt : in  STD_LOGIC; -- Habilita contador
				  cnt_100ms : out  STD_LOGIC); -- Fin cuenta
end component;

component Reg_b is
		Port ( clk  : in  STD_LOGIC; -- Reloj FPGA
					  sel : in  STD_LOGIC_VECTOR (1 downto 0); -- Decrementa/Incrementa
					  en_b : in  STD_LOGIC; -- Habilita registro
					  rst_b : in  STD_LOGIC; -- Inicializa registro
					  b : out  STD_LOGIC_VECTOR (5 downto 0)); -- Salida
end component;

	

begin

U1 : MooreFSM
		port map (
		clk => clk,
		Up0 => Up0,
		Down0 => Down0,
		Up1 => Up1,
		Down1 => Down1,
		Rst => Rst,
		cnt_100ms => s_cnt_100ms,
		rst_cnt => s_rst_cnt,
		en_cnt => s_en_cnt,
		rst_b => s_rst_b,
		en_b => s_en_b,
		sel => s_sel
		);
	
U2 : Reg_b
		port map (
		clk => clk,
		sel => s_sel,
		en_b => s_en_b,
		rst_b => s_rst_b,
		b => b
		);

U3 : contador_100ms
		port map (
		clk => clk,
		rst_cnt => s_rst_cnt,
		en_cnt => s_en_cnt,
		cnt_100ms => s_cnt_100ms
		);

end Hierarchical;