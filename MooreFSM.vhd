--------------------------------------------------------------------------------------------------------------------------
-- AUTOMATA MOORE 
--
-- Este modulo recibe las senales de los pulsadores y gestiona la cuenta de 100ms para controlar el valor del registro b.	
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MooreFSM is
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
end MooreFSM;

architecture behavioral of MooreFSM is

type clase_estado is(st_Reset,st_Main,st_Up0a,st_Up0b,st_Up1a,
st_Up1b,st_Down0a,st_Down0b,st_Down1a,st_Down1b); -- Estados del automata
signal estado_actual: clase_estado :=st_Main;
signal estado_siguiente : clase_estado :=st_Main;

begin

process(clk) -- Proceso de sincronizacion
begin
if (clk'event and clk='1') then
	if (Rst='1') then
		estado_actual <= st_Reset;
	else 
		estado_actual <= estado_siguiente;
	end if;
end if;
end process;

process(estado_actual,Up0,Up1,Down0,Down1,cnt_100ms,Rst) -- Logica cambio de estados
begin
	case estado_actual is
		when st_Main => -- Estado reposo
			if Up0 = '1' then
				estado_siguiente <= st_Up0a;	
			elsif Up1 = '1' then
				estado_siguiente <= st_Up1a;
			elsif Down0 = '1' then
				estado_siguiente <= st_Down0a;
			elsif Down1 = '1' then
				estado_siguiente <= st_Down1a;
			elsif Rst = '1' then
				estado_siguiente <= st_Reset;
			else
				estado_siguiente <= st_Main;
			end if;	
		when st_Up0a => -- Inicio incremento 1
			if cnt_100ms = '1' then
				estado_siguiente <= st_Up0b;
			else 
				estado_siguiente <= st_Up0a;
			end if;
		when st_Up0b =>
		 estado_siguiente <= st_Main; -- Fin incremento 1		
		when st_Up1a => -- Inicio incremento 10
			if cnt_100ms = '1' then
				estado_siguiente <= st_Up1b;
			else 
				estado_siguiente <= st_Up1a;
			end if;
		when st_Up1b =>
		 estado_siguiente <= st_Main;	-- Fin incremento 10 
		when st_Down0a => -- Inicio decremento 1
			if cnt_100ms = '1' then
				estado_siguiente <= st_Down0b;
			else 
				estado_siguiente <= st_Down0a;
			end if;
		when st_Down0b =>
		 estado_siguiente <= st_Main; -- Fin decremento 1	
		when st_Down1a => -- Inicio decremento 10
			if cnt_100ms = '1' then
				estado_siguiente <= st_Down1b;
			else 
				estado_siguiente <= st_Down1a;
			end if;
		when st_Down1b =>
		 estado_siguiente <= st_Main; -- Fin decremento 10		
		when st_Reset =>
			if Rst='1' then
				estado_siguiente <= st_Reset;
			else
				estado_siguiente <= st_Main;
			end if;
		end case;
end process;
		
process (estado_actual) -- Logica de las salidas
begin
	case estado_actual is
		when st_Main => -- Valores por defecto
			rst_cnt <= '1';
			rst_b <= '0';
			sel <= "00";
			en_cnt <= '0';
			en_b <= '0';
		when st_Up0a => -- Activa contador
			rst_cnt <= '0';
			en_cnt <= '1';
		when st_Up1a => -- Activa contador
			rst_cnt <= '0';
			en_cnt <= '1';
		when st_Down0a => -- Activa contador
			rst_cnt <= '0';
			en_cnt <= '1';
		when st_Down1a => -- Activa contador
			rst_cnt <= '0';
			en_cnt <= '1';
		when st_Up0b => -- "00" incrementa +1
			en_b <= '1';
			sel <= "00";
		when st_Up1b => -- "10" incrementa +10
			en_b <= '1';
			sel <= "10";
		when st_Down0b => -- "01" decrementa -1
			en_b <= '1';
			sel <= "01";
		when st_Down1b => -- "11" decrementa -10
			en_b <= '1';
			sel <= "11";
		when st_Reset => -- Cuando reset, inicializar el registro
			rst_b <= '1';
	end case;
end process;	
end behavioral;