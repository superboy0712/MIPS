----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:59 10/18/2014 
-- Design Name: 
-- Module Name:    MIPS_PC_with_src_select - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPS_PC_with_src_select is
    Port ( 	
			reset : in std_logic;
			PC_en : in std_logic;
			clk	: in std_logic;
			PCSrc : in  STD_LOGIC;
			Jump : in STD_LOGIC;
			offeset_address : in  STD_LOGIC_VECTOR (31 downto 0);
			instruction : in STD_LOGIC_VECTOR(25 downto 0);
			
			PC : out std_logic_vector (31 downto 0 ));
			
end MIPS_PC_with_src_select;

architecture Behavioral of MIPS_PC_with_src_select is
	signal PC_register : signed( 31 DOWNTO 0 ) := ( others => '0');
	signal branch_selector_outupt : std_logic_vector( 31 downto 0);
begin
	process(tmp_PC)
	begin
	--initialization variable
	--
		if reset = '1' then tmp_PC := ( others => '0');
		elsif reset = '0' and rising_edge(clk) then
			if PC_en = '1' then
				if PCSrc = '0' then branch_selector_outupt <= tmp_PC + 1;
				elsif PCSrc = '1' then branch_selector_outupt <=  tmp_PC + 1 + signed(offeset_address);
				end if;
			end if;
		end if;
	PC <= std_logic_vector(tmp_PC);
	end process;
	
	Jump_address_generator : process(instr_reg(25 downto 0)) 
	-- to simplify,  the 4msb always 0. becoz PC only 8bits
	begin
		Jump_address <= std_logic_vector(resize(unsigned(instr_reg(25 downto 0)), Jump_address'length));
	end process;
	
	PC_output_logic : process(PC_register, PCSrc, Jump, offeset_address, instruction)
	begin
	
	end process;
end Behavioral;

