LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY tb_pseudo_random IS
END tb_pseudo_random;
 
ARCHITECTURE behavior OF tb_pseudo_random IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pseudo_random
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_random : IN  std_logic;
         sw : IN  std_logic_vector(5 downto 0);
         b : IN  std_logic_vector(5 downto 0);
         valor_DAC : OUT  std_logic_vector(11 downto 0);
         valor_ADC : IN  std_logic_vector(11 downto 0);
         end_random : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_random : std_logic := '0';
   signal sw : std_logic_vector(5 downto 0) :="101100" ;
   signal b : std_logic_vector(5 downto 0) := (others => '0');
   signal valor_ADC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal valor_DAC : std_logic_vector(11 downto 0);
   signal end_random : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pseudo_random PORT MAP (
          clk => clk,
          Rst => Rst,
          start_random => start_random,
          sw => sw,
          b => b,
          valor_DAC => valor_DAC,
          valor_ADC => valor_ADC,
          end_random => end_random
        );
    Rst <='1','0' after 200 ns;
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
 random_process :process
   begin
		start_random <= '0';
		wait for 150 us;
		start_random <= '1';
		wait for 50 ns;
		start_random <= '0';
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
     valor_ADC<="000010001101";
		b<=sw;
		wait for 300 us;
		valor_ADC<="000011010011";
		b<="111111";
		wait;
   end process;

END;
