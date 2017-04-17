LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_top_digital IS
END tb_top_digital;
 
ARCHITECTURE behavior OF tb_top_digital IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_digital
    PORT(
         Puls0 : IN  std_logic;
         Puls1 : IN  std_logic;
         Puls2 : IN  std_logic;
         Puls3 : IN  std_logic;
         sw : IN  std_logic_vector(5 downto 0);
			sw6 : IN std_logic;
         sw7 : IN  std_logic;
         clk : IN  std_logic;
         DOUT : IN  std_logic;
         Seg7 : OUT  std_logic_vector(0 to 6);
			LEDS : OUT std_logic_vector(7 downto 0);
         Disp0 : OUT  std_logic;
         Disp1 : OUT  std_logic;
         Disp2 : OUT  std_logic;
         Disp3 : OUT  std_logic;
         CS0 : OUT  std_logic;
         DIN : OUT  std_logic;
         SCLK : OUT  std_logic;
         CS1 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Puls0 : std_logic := '0';
   signal Puls1 : std_logic := '0';
   signal Puls2 : std_logic := '0';
   signal Puls3 : std_logic := '0';
   signal sw : std_logic_vector(5 downto 0) := (others => '0');
	signal sw6 : std_logic := '1';
   signal sw7 : std_logic := '0';
   signal clk : std_logic := '0';
   signal DOUT : std_logic := '0';

 	--Outputs
   signal Seg7 : std_logic_vector(0 to 6);
	signal LEDS : std_logic_vector(7 downto 0);
   signal Disp0 : std_logic;
   signal Disp1 : std_logic;
   signal Disp2 : std_logic;
   signal Disp3 : std_logic;
   signal CS0 : std_logic;
   signal DIN : std_logic;
   signal SCLK : std_logic;
   signal CS1 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_digital PORT MAP (
          Puls0 => Puls0,
          Puls1 => Puls1,
          Puls2 => Puls2,
          Puls3 => Puls3,
          sw => sw,
			 sw6=> sw6,
          sw7 => sw7,
          clk => clk,
          DOUT => DOUT,
          Seg7 => Seg7,
			 LEDS => LEDS,
          Disp0 => Disp0,
          Disp1 => Disp1,
          Disp2 => Disp2,
          Disp3 => Disp3,
          CS0 => CS0,
          DIN => DIN,
          SCLK => SCLK,
          CS1 => CS1
        );
    sw7<= '1','0' after 500 ns;
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
		sw6 <= '1';		
		Puls0<= '1';
		wait for 200 ms;
		Puls0 <='0';
		Puls2 <='1';
		wait for 100 ms;
		Puls2 <='0';
		sw<="111111";
		wait for 80 ms;
		sw<="001100";
		
		

   end process;
END;
