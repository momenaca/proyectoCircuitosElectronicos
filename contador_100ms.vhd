--------------------------------------------------------------------------------------------------------------------------
-- CONTADOR 100ms
--
-- Contador que genera una senal activa con cada cuenta de 100ms. Es necesario para el funcionamiento del automata.
-- Este ultimo es quien habilita e inicializa la cuenta.
--------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contador_100ms is
        Port (
		  clk,rst_cnt,en_cnt : in STD_LOGIC;
		  cnt_100ms : out STD_LOGIC );
end contador_100ms;

architecture Behavioral of contador_100ms is

signal contador : STD_LOGIC_VECTOR(22 DOWNTO 0):= (others => '0'); -- BBBBB es 22 porque el máximo valor de la
																						 -- cuenta en binario tiene 23 digitos

begin
process (clk)
begin
   if clk'event and clk='1' then
	    cnt_100ms <= '0';
       if en_cnt='1' then
          contador <= contador + '1';
       end if;		
       if contador >= 5000000 then -- AAAAA corresponde a 100ms/Tclk(20ns)		  
		    cnt_100ms <= '1';
			 contador <= (others => '0');
		 end if;
		 if rst_cnt='1' then
		    cnt_100ms <= '0';
			 contador <= (others => '0');
       end if;
    end if;
end process;	 
end Behavioral;