library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
 
ENTITY tb_control_DAC IS
END tb_control_DAC;
 
ARCHITECTURE behavior OF tb_control_DAC IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_DAC
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
         start_DAC : IN  std_logic;
         valor_DAC : IN  std_logic_vector(11 downto 0);
         end_DAC : OUT  std_logic;
         CS1 : OUT  std_logic;
         SCLK : OUT  std_logic;
         DIN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal start_DAC : std_logic := '0';
   signal valor_DAC : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal end_DAC : std_logic;
   signal CS1 : std_logic;
   signal SCLK : std_logic;
   signal DIN : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_dac PORT MAP (
          clk => clk,
          rst => rst,
          start_DAC => start_DAC,
          valor_DAC => valor_DAC,
          end_DAC => end_DAC,
          CS1 => CS1,
          SCLK => SCLK,
          DIN => DIN
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
  
  -- Generacion del RESET inicial
 rst <='1','0' after 500 ns;
 
 -- Generacion de start_DAc cada 125us
   s_start_dac_process :process
   begin
		start_DAC <= '0';
		wait for 125 us;
		start_DAC <= '1';
		wait for 20 ns;
		start_DAC <= '0';
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      valor_DAC<="101010101001";
		wait for 250 us;
		valor_DAC<="110011010001";
		wait for 350 us;
      valor_DAc <="110101100110";
		wait;
   end process;

END;