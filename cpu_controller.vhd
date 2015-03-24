library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cpu_controller is
	port(
		clk					: in std_logic;
		instruction			: in std_logic_vector(31 downto 26);
		
		RegDst				: out std_logic;
		Jump				: out std_logic;
		Branch				: out std_logic;
		MemRead				: out std_logic;
		MemtoReg			: out std_logic;
		ALUOp				: out std_logic;
		MemWrite			: out std_logic;
		ALUSrc				: out std_logic;
		RegWrite			: out std_logic
	);
end cpu_controller;

architecture behavioral of cpu_controller is
	
end behavioral;