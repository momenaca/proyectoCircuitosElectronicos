library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digital1 is
    Port ( clk : in  STD_LOGIC;
           Up0 : in  STD_LOGIC;
           Down0 : in  STD_LOGIC;
           Up1 : in  STD_LOGIC;
           Down1 : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (0 to 6));
end digital1;

architecture Hierarchical of digital1 is

	component control_pulsadores is
		Port ( clk : in  STD_LOGIC; -- Relog FPGA
					  Rst : in  STD_LOGIC; -- reset Swtich 0
					  Up0 : in  STD_LOGIC; -- Incrementa 1
					  Down0 : in  STD_LOGIC; -- Decrementa 1
					  Up1 : in  STD_LOGIC; -- Incrementa 10
					  Down1 : in  STD_LOGIC; -- Decrementa 10
					  b : out  STD_LOGIC_VECTOR (5 downto 0)); -- Salida registro
	end component;

	component control_displays is
    Port ( clk : in  STD_LOGIC;
           b : in  STD_LOGIC_VECTOR (5 downto 0);
           Disp0 : out  STD_LOGIC;
           Disp1 : out  STD_LOGIC;
           Disp2 : out  STD_LOGIC;
           Disp3 : out  STD_LOGIC;
           Seg7 : out  STD_LOGIC_VECTOR (0 to 6));
	end component;

signal s_b : STD_LOGIC_VECTOR(5 DOWNTO 0);

begin
 
U1 : control_pulsadores port map(
clk => clk,
Rst => Rst,
Up0 => Up0,
Down0 => Down0,
Up1 => Up1,
Down1 => Down1,
b => s_b
);

U2 : control_displays port map(
clk => clk,
b => s_b,
Disp0 => Disp0,
Disp1 => Disp1,
Disp2 => Disp2,
Disp3 => Disp3,
Seg7 => Seg7
);

end Hierarchical;

