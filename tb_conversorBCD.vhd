LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY tb_conversorBCD IS
END tb_conversorBCD;
 
ARCHITECTURE behavior OF tb_conversorBCD IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT conversorBCD
    PORT(
         clk : IN  std_logic;
         b : IN  std_logic_vector(5 downto 0);
         D0 : OUT  std_logic_vector(3 downto 0);
         D1 : OUT  std_logic_vector(3 downto 0);
         D2 : OUT  std_logic_vector(3 downto 0);
         D3 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal b : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal D0 : std_logic_vector(3 downto 0);
   signal D1 : std_logic_vector(3 downto 0);
   signal D2 : std_logic_vector(3 downto 0);
   signal D3 : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: conversorBCD PORT MAP (
          clk => clk,
          b => b,
          D0 => D0,
          D1 => D1,
          D2 => D2,
          D3 => D3
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
		b <= "111111";

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
