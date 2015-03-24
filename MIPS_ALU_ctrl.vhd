----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:12:28 10/16/2014 
-- Design Name: 
-- Module Name:    MIPS_ALU_ctrl - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPS_ALU_ctrl is
    Port ( funct_code : in  STD_LOGIC_VECTOR (5 downto 0);
           ALU_op : in  STD_LOGIC_VECTOR (1 downto 0);
           ALU_ctrl : out  STD_LOGIC_VECTOR (3 downto 0));
end MIPS_ALU_ctrl;

architecture Behavioral of MIPS_ALU_ctrl is
	
begin
	process(funct_code, ALU_op)
	variable alu_ctrl_tmp : std_logic_vector (3 downto 0);
	begin
	--
	alu_ctrl_tmp := (others => 'X');
	--
	if ALU_op = "00" then -- LW/SW
	alu_ctrl_tmp := "0010";
	elsif ALU_op(0) = '1'	then -- BEQ
	alu_ctrl_tmp := "0110";
	elsif ALU_op(1) = '1' then -- R type
		if funct_code( 3 downto 0 ) = "0000" then -- add  
		alu_ctrl_tmp := "0010";
		elsif funct_code( 3 downto 0 ) = "0010" then-- sub
		alu_ctrl_tmp := "0110";
		elsif funct_code( 3 downto 0 ) = "0100" then-- and  
		alu_ctrl_tmp := "0000";
		elsif funct_code( 3 downto 0 ) = "0101" then-- or  
		alu_ctrl_tmp := "0001";
		elsif funct_code( 3 downto 0 ) = "1010" then-- slt
		alu_ctrl_tmp := "0111";
		--
	    end if;
	else alu_ctrl_tmp := (others => 'X');
	end if;
	
	ALU_ctrl <= alu_ctrl_tmp;
	end process;

end Behavioral;

