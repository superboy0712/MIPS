--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:56:25 10/19/2014
-- Design Name:   
-- Module Name:   D:/Documents/Xilinx Projects/multi_cycle_cpu/src/reg_file_tb.vhd
-- Project Name:  multi_cycle_cpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reg_file
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
use ieee.numeric_std.all;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY reg_file_tb IS
END reg_file_tb;
 
ARCHITECTURE behavior OF reg_file_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reg_file
    PORT(
         clk : IN  std_logic;
         wr_en : IN  std_logic;
         rd_reg_num1 : IN  std_logic_vector(4 downto 0);
         rd_reg_num2 : IN  std_logic_vector(4 downto 0);
         wr_reg_num : IN  std_logic_vector(4 downto 0);
         wr_data : IN  std_logic_vector(31 downto 0);
         rd_data1 : OUT  std_logic_vector(31 downto 0);
         rd_data2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal wr_en : std_logic := '0';
   signal rd_reg_num1 : std_logic_vector(4 downto 0) := (others => '0');
   signal rd_reg_num2 : std_logic_vector(4 downto 0) := (others => '0');
   signal wr_reg_num : std_logic_vector(4 downto 0) := (others => '0');
   signal wr_data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal rd_data1 : std_logic_vector(31 downto 0);
   signal rd_data2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reg_file PORT MAP (
          clk => clk,
          wr_en => wr_en,
          rd_reg_num1 => rd_reg_num1,
          rd_reg_num2 => rd_reg_num2,
          wr_reg_num => wr_reg_num,
          wr_data => wr_data,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2
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
	  for i in 0 to 31 loop
		wr_en <= '1';
		wr_reg_num <= std_logic_vector(to_unsigned(i, 5));
		wr_data <= std_logic_vector( X"ffffff00" + to_signed( i, 32));
		wait for clk_period;
	  end loop;
		
		wr_en <= '0';
	  -- test read from reg no.1
      for i in 0 to 31 loop
		rd_reg_num1 <= std_logic_vector(to_unsigned(i, 5));
		wait for clk_period;
		assert rd_data1 = std_logic_vector( X"ffffff00" + to_signed( i, 32)) report "reading test 1 failed" severity error;
	  end loop;
	  
	   -- test read from reg no.2
      for i in 0 to 31 loop
		rd_reg_num2 <= std_logic_vector(to_unsigned(i, 5));
		wait for clk_period;
		assert rd_data2 = std_logic_vector( X"ffffff00" + to_signed( i, 32)) report "reading test 2 failed" severity error;
	  end loop;
		
	assert false report "end of simulation" severity failure;
      wait;
   end process;

END;
