--------------------------------------------------------------------------------
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY tb_MooreFSM IS
END tb_MooreFSM;
 
ARCHITECTURE behavior OF tb_MooreFSM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MooreFSM
    PORT(
         clk : IN  std_logic;
         Up0 : IN  std_logic;
         Down0 : IN  std_logic;
         Up1 : IN  std_logic;
         Down1 : IN  std_logic;
         Rst : IN  std_logic;
         cnt_100ms : IN  std_logic;
         rst_cnt : OUT  std_logic;
         en_cnt : OUT  std_logic;
         rst_b : OUT  std_logic;
         en_b : OUT  std_logic;
         sel : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Up0 : std_logic := '0';
   signal Down0 : std_logic := '0';
   signal Up1 : std_logic := '0';
   signal Down1 : std_logic := '0';
   signal Rst : std_logic := '0';
   signal cnt_100ms : std_logic := '0';

 	--Outputs
   signal rst_cnt : std_logic;
   signal en_cnt : std_logic;
   signal rst_b : std_logic;
   signal en_b : std_logic;
   signal sel : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MooreFSM PORT MAP (
          clk => clk,
          Up0 => Up0,
          Down0 => Down0,
          Up1 => Up1,
          Down1 => Down1,
          Rst => Rst,
          cnt_100ms => cnt_100ms,
          rst_cnt => rst_cnt,
          en_cnt => en_cnt,
          rst_b => rst_b,
          en_b => en_b,
          sel => sel
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
      Up0 <= '1';
		wait for 5 ms;
      cnt_100ms <= '1';
		
      wait for  5 ms;
		cnt_100ms <= '0';
      Up0 <= '0';
      Up1 <= '1';	
      wait for 5 ms;
      cnt_100ms <='1';
		
		wait for 5 ms;
      Up1 <= '0';
		Down0 <= '1';
		cnt_100ms <='1';
		wait for 5 ms;
      cnt_100ms <= '1';
		
      wait for 5 ms;
		cnt_100ms <= '0';
      Down0 <= '0';
      Down1 <= '1';	
      wait for 5 ms;
      cnt_100ms <='1';
		

      -- insert stimulus here 

      wait;
   end process;

END;
