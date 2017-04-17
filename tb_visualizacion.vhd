LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY tb_visualizacion IS
END tb_visualizacion;
 
ARCHITECTURE behavior OF tb_visualizacion IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT visualizacion
    PORT(
         clk : IN  std_logic;
         cnt_5ms : IN  std_logic;
         Digito0 : IN  std_logic_vector(3 downto 0);
         Digito1 : IN  std_logic_vector(3 downto 0);
         Digito2 : IN  std_logic_vector(3 downto 0);
         Digito3 : IN  std_logic_vector(3 downto 0);
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal cnt_5ms : std_logic := '0';
   signal Digito0 : std_logic_vector(3 downto 0) := (others => '0');
   signal Digito1 : std_logic_vector(3 downto 0) := (others => '0');
   signal Digito2 : std_logic_vector(3 downto 0) := (others => '0');
   signal Digito3 : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal Seg7 : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: visualizacion PORT MAP (
          clk => clk,
          cnt_5ms => cnt_5ms,
          Digito0 => Digito0,
          Digito1 => Digito1,
          Digito2 => Digito2,
          Digito3 => Digito3,
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3,
          Seg7 => Seg7
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		cnt_5ms <= '1';
		Digito0 <= "0010";
		Digito1 <= "0100";

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
