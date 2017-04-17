LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY tb_control_pulsadores IS
END tb_control_pulsadores;
 
ARCHITECTURE behavior OF tb_control_pulsadores IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_pulsadores
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         Up0 : IN  std_logic;
         Down0 : IN  std_logic;
         Up1 : IN  std_logic;
         Down1 : IN  std_logic;
         b : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal Up0 : std_logic := '0';
   signal Down0 : std_logic := '0';
   signal Up1 : std_logic := '0';
   signal Down1 : std_logic := '0';

 	--Outputs
   signal b : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_pulsadores PORT MAP (
          clk => clk,
          Rst => Rst,
          Up0 => Up0,
          Down0 => Down0,
          Up1 => Up1,
          Down1 => Down1,
          b => b
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
		Down0 <= '1';
		wait for 100 ms;
		Down0 <= '0';
		Down1 <= '1';
		wait for 100 ms;
		Up1 <= '1';
		Down1 <= '0';
		wait for 100 ms;
		Up1 <= '0';
		Up0 <= '1';
		wait for 100 ms;	
		Down0 <= '1';
		Up0 <= '0';
		wait for 100 ms;
		Down0 <= '0';
		Down1 <= '1';
		wait for 200 ms;
		Up1 <= '1';
		Down1 <= '0';
		wait for 700 ms;
		Up1 <= '0';
		Up0 <= '1';
		

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
