LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY IFID_register_tb IS
END IFID_register_tb;
 
ARCHITECTURE behavior OF IFID_register_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFID_register
  	port
	  	(Clk, reset : in  std_logic;
  		instruction_i, pc_i: in std_logic_vector(31 downto 0);
        instruction_o, pc_o : out std_logic_vector(31 downto 0));
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal instruction_i, pc_i : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal instruction_o, pc_o : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFID_register PORT MAP (
          clk => clk,
          reset => reset,
          instruction_i => instruction_i,
          instruction_o => instruction_o,
          pc_i => pc_i,
          pc_o => pc_o
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

      wait for clk_period*10;

      -- insert stimulus here 
	  -- write some data
	  wait for clk_period/2;
	  pc_i <= x"1000_1000";
	  instruction_i <= x"0101_0101";
	  wait for clk_period;
	  pc_i <= x"FEDC_BA98";
	  instruction_i <= x"F00F_F00F";
	  wait for clk_period*2;
		
	assert false report "end of simulation" severity failure;
      wait;
   end process;

END;