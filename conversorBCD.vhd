library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity conversorBCD is
    Port ( clk : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (5 downto 0);
           D0 : out  STD_LOGIC_VECTOR (3 downto 0);
           D1 : out  STD_LOGIC_VECTOR (3 downto 0);
           D2 : out  STD_LOGIC_VECTOR (3 downto 0);
           D3 : out  STD_LOGIC_VECTOR (3 downto 0));
end conversorBCD;

architecture Behavioral of conversorBCD is

component conversorBCD_unit is
					Port ( data_in : in STD_LOGIC_VECTOR (5 downto 0); -- numero binario de entrada
                      data_out : out STD_LOGIC_VECTOR (3 downto 0); -- numero binario de salida
                      digito : out STD_LOGIC_VECTOR (3 downto 0) ); -- digito BCD de salida
end component;

begin

D2<=(others => '0'); D3<=(others => '0');

U1 : conversorBCD_unit port map(b,D0,D1);
end Behavioral;

