 ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:15 10/19/2014 
-- Design Name: 
-- Module Name:    MIPS_sign_extender_and_shifter - Behavioral 
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

entity MIPS_sign_extender_and_shifter is
    Port ( instruction : in  STD_LOGIC_VECTOR (15 downto 0);
           sign_extend : out  STD_LOGIC_VECTOR (32 downto 0);
           shift_left_2 : out  STD_LOGIC_VECTOR (32 downto 0));
end MIPS_sign_extender_and_shifter;

architecture Behavioral of MIPS_sign_extender_and_shifter is

begin


end Behavioral;

