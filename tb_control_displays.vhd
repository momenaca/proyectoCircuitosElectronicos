--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:35:05 12/08/2016
-- Design Name:   
-- Module Name:   E:/Proyecto Final/Proyecto/tb_control_displays.vhd
-- Project Name:  Proyecto
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control_displays
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_control_displays IS
END tb_control_displays;
 
ARCHITECTURE behavior OF tb_control_displays IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_displays
    PORT(
         clk : IN  std_logic;
         b : IN  std_logic_vector(5 downto 0);
         sw : IN  std_logic_vector(5 downto 0);
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         Seg7 : OUT  std_logic_vector(0 to 6)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal b : std_logic_vector(5 downto 0) := (others => '0');
   signal sw : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal Seg7 : std_logic_vector(0 to 6);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_displays PORT MAP (
          clk => clk,
          b => b,
          sw => sw,
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
		b <= "110101";
		sw <= "111111";


      wait;
   end process;

END;
