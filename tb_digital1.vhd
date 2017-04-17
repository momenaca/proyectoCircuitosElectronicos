LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY tb_digital1 IS
END tb_digital1;
 
ARCHITECTURE behavior OF tb_digital1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT digital1
    PORT(
         clk : IN  std_logic;
         Up0 : IN  std_logic;
         Down0 : IN  std_logic;
         Up1 : IN  std_logic;
         Down1 : IN  std_logic;
         Rst : IN  std_logic;
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(0 to 6)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Up0 : std_logic := '0';
   signal Down0 : std_logic := '0';
   signal Up1 : std_logic := '0';
   signal Down1 : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal Seg7 : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: digital1 PORT MAP (
          clk => clk,
          Up0 => Up0,
          Down0 => Down0,
          Up1 => Up1,
          Down1 => Down1,
          Rst => Rst,
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
      wait for 1000 ns;	
		Up1 <='1';
		wait for  100 ms;
		Up0 <= '1';
		Up1 <='0';
		

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
