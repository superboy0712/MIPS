--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:20:40 10/16/2014
-- Design Name:   
-- Module Name:   D:/Documents/Xilinx Projects/multi_cycle_cpu/MIPS_ALU_tb.vhd
-- Project Name:  multi_cycle_cpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY MIPS_ALU_tb IS
END MIPS_ALU_tb;
 
ARCHITECTURE behavior OF MIPS_ALU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         alu_ctrl : IN  std_logic_vector(3 downto 0);
         alu_src1 : IN  std_logic_vector(31 downto 0);
         alu_src2 : IN  std_logic_vector(31 downto 0);
         alu_zero : OUT  std_logic;
         alu_result : OUT  std_logic_vector(31 downto 0);
         alu_carry : OUT  std_logic
        );
    END COMPONENT;
    
	signal clock : std_logic;
   --Inputs
   signal alu_ctrl : std_logic_vector(3 downto 0) := (others => '0');
   signal alu_src1 : std_logic_vector(31 downto 0) := (others => '0');
   signal alu_src2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal alu_zero : std_logic;
   signal alu_result : std_logic_vector(31 downto 0);
   signal alu_carry : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          alu_ctrl => alu_ctrl,
          alu_src1 => alu_src1,
          alu_src2 => alu_src2,
          alu_zero => alu_zero,
          alu_result => alu_result,
          alu_carry => alu_carry
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
	  --test add
		alu_src1 <= X"f0f0f0f0";
		alu_src2 <= X"0f0f0f0f";
		alu_ctrl <= "0000";
		wait for 10 ns;
		assert alu_result = X"00000000" report "and failed" severity error;
		-- test or 
		wait for 10 ns;
		alu_src1 <= X"f0f0f0f0";
		alu_src2 <= X"0f0f0f0f";
		alu_ctrl <= "0001";
		wait for 10 ns;
		assert alu_result = X"ffffffff" report "or failed" severity error;
		-- test add 
		wait for 10 ns;
		alu_src1 <= std_logic_vector(to_signed(1234567,32));
		alu_src2 <= std_logic_vector(to_signed(7654321,32));
		alu_ctrl <= "0010";
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(8888888,32)) report "add failed" severity error;
		-- test sub 
		wait for 10 ns;
		alu_src1 <= std_logic_vector(to_signed(7777777,32));
		alu_src2 <= std_logic_vector(to_signed(4444444,32));
		alu_ctrl <= "0110";
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(3333333,32)) report "sub failed" severity error;
		-- test sub2 
		wait for 10 ns;
		alu_src1 <= std_logic_vector(to_signed(4444444,32));
		alu_src2 <= std_logic_vector(to_signed(7777777,32));
		alu_ctrl <= "0110";
		wait for 10 ns;
		assert alu_result = std_logic_vector(to_signed(-3333333,32)) report "sub2 failed" severity error;
		-- test slt
		wait for 10 ns;
		alu_src1 <= std_logic_vector(to_signed(4444444,32));
		alu_src2 <= std_logic_vector(to_signed(7777777,32));
		alu_ctrl <= "0111";
		wait for 10 ns;
		assert alu_result = x"00000001" report "slt failed" severity error;
		-- test nor
		wait for 10 ns;
		alu_src1 <= X"00000000";
		alu_src2 <= X"00000000";
		alu_ctrl <= "1100";
		wait for 10 ns;
		assert alu_result = x"ffffffff" report "nor failed" severity error;
		
      wait;
   end process;

END;
