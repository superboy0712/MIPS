--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:14:26 10/18/2014
-- Design Name:   
-- Module Name:   D:/Documents/Xilinx Projects/multi_cycle_cpu/src/MIPS_ALU_ctrl_tb.vhd
-- Project Name:  multi_cycle_cpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MIPS_ALU_ctrl
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
 
ENTITY MIPS_ALU_ctrl_tb IS
END MIPS_ALU_ctrl_tb;
 
ARCHITECTURE behavior OF MIPS_ALU_ctrl_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MIPS_ALU_ctrl
    PORT(
         funct_code : IN  std_logic_vector(5 downto 0);
         ALU_op : IN  std_logic_vector(1 downto 0);
         ALU_ctrl : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal funct_code : std_logic_vector(5 downto 0) := (others => '0');
   signal ALU_op : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal ALU_ctrl : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
   signal clock : std_logic;
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MIPS_ALU_ctrl PORT MAP (
          funct_code => funct_code,
          ALU_op => ALU_op,
          ALU_ctrl => ALU_ctrl
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here 
	  --LW/SW
	  ALU_op <= "00";
	  wait for 10 ns;
	  assert ALU_ctrl = "0010" report "ALU_op 00 failed" severity error;
	  -- BEQ
	  ALU_op <= "01";
	  wait for 10 ns;
	  assert ALU_ctrl = "0110" report "ALU_op 01 failed" severity error;
	  --R TYPE
	  ALU_op <= "10";
	  funct_code <= "000000";
	  wait for 10 ns;
	  assert ALU_ctrl = "0010" report "ALU_op 10 failed" severity error;
	  -- R TYPE  with don't care bits COVERAGE test FOR ADD
	  ALU_op <= "10";
	  funct_code <= "010000";
	  wait for 10 ns;
	  assert ALU_ctrl = "0010" report "ALU_op 10 failed" severity error;
	  
	  funct_code <= "110000";
	  wait for 10 ns;
	  assert ALU_ctrl = "0010" report "ALU_op 10 failed" severity error;
	 
	  funct_code <= "100000";
	  wait for 10 ns;
	  assert ALU_ctrl = "0010" report "ALU_op 10 failed" severity error;
	  -- R TYPE  with don't care bits COVERAGE test FOR SUB
	  ALU_op <= "10";
	  funct_code <= "010010";
	  wait for 10 ns;
	  assert ALU_ctrl = "0110" report "ALU_ctrl = 0110 failed" severity error;
	  
	  funct_code <= "110010";
	  wait for 10 ns;
	  assert ALU_ctrl = "0110" report "ALU_ctrl = 0110 failed" severity error;
	 
	  funct_code <= "100010";
	  wait for 10 ns;
	  assert ALU_ctrl = "0110" report "ALU_ctrl = 0110 failed" severity error;
	  -- and
	  funct_code <= "100100";
	  wait for 10 ns;
	  assert ALU_ctrl = "0000" report "ALU_ctrl = 0110 failed" severity error;
	  -- or
	  funct_code <= "100101";
	  wait for 10 ns;
	  assert ALU_ctrl = "0001" report "ALU_ctrl = 0110 failed" severity error;
	  -- slt
	  funct_code <= "101010";
	  wait for 10 ns;
	  assert ALU_ctrl = "0111" report "ALU_ctrl = 0110 failed" severity error;

      wait;
   end process;

END;
