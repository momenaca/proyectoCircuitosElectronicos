--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:29:28 11/22/2016
-- Design Name:   
-- Module Name:   E:/Proyecto_ise12migration/tb_Reg_b.vhd
-- Project Name:  Proyecto
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Reg_b
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
 
ENTITY tb_Reg_b IS
END tb_Reg_b;
 
ARCHITECTURE behavior OF tb_Reg_b IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Reg_b
    PORT(
         clk : IN  std_logic;
         sel : IN  std_logic_vector(1 downto 0);
         en_b : IN  std_logic;
         rst_b : IN  std_logic;
         b : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal sel : std_logic_vector(1 downto 0) := (others => '0');
   signal en_b : std_logic := '0';
   signal rst_b : std_logic := '0';

 	--Outputs
   signal b : std_logic_vector(5 downto 0);
   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Reg_b PORT MAP (
          clk => clk,
          sel => sel,
          en_b => en_b,
          rst_b => rst_b,
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
		sel <= "00"		;
		rst_b <= '1';
		wait for 20 ns;
		rst_b <= '0';
		en_b <='1';
		wait for 10 ns;
		sel <= "00"	;
		wait for 40 ns;
		sel <= "10";
		wait for 20 ns;
		sel <= "01";
		wait for 20 ns;
		sel <= "11";
		wait for 20 ns;
		en_b <= '0';
		
		   

      wait;
   end process;

END;
