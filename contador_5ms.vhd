library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_5ms is
    Port ( clk : in  STD_LOGIC;
           cnt_5ms : out  STD_LOGIC);
end contador_5ms;

architecture Behavioral of contador_5ms is

signal contador : STD_LOGIC_VECTOR(17 downto 0):= (others => '0'); -- Señal 

begin
	process (clk)
		begin
			if clk'event and clk='1' then
				cnt_5ms <= '0';
				contador <= contador + '1';
				if contador >= 250000 then -- Valor máximo de cuenta
					cnt_5ms <= '1';
					contador <= (others => '0');
				end if;
			end if;
	end process;

end Behavioral;

