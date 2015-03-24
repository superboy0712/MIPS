----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:30:31 10/19/2014 
-- Design Name: 
-- Module Name:    MIPS_main_controller - Behavioral 
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

entity MIPS_main_controller is
    Port ( 	proc_en : in std_logic;
			clk		: in std_logic;
			Opcode : in  STD_LOGIC_VECTOR (31 downto 26);
			PC_en : out STD_LOGIC;
			IF_en : out STD_LOGIC; -- instruction register enable
           ALUOp : out  STD_LOGIC_VECTOR (1 downto 0);
           RegDst : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemWrite : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
		   Jump : out STD_LOGIC;
		   RF_WriteSrc : OUT std_logic
		   );
end MIPS_main_controller;

architecture Behavioral of MIPS_main_controller is
	type state_type is (IDLE, IFCH, ID, EX, MEM, WB);
	signal state : state_type := IDLE;
	
begin

	decoder_and_output : process(state, Opcode) -- using asynchronous or synchronous ? the  control signals for function units are mostly synchronous
		variable PC_en_tmp, IF_en_tmp, regdst_tmp, alusrc_tmp, memtoreg_tmp, regwrite_tmp, memread_tmp, memwrite_tmp, branch_tmp, jump_tmp, rf_writesrc_tmp : std_logic := '0';
		variable aluop_tmp : std_logic_vector ( 1 downto 0 ) := "00";
	begin
		decode : case Opcode is
			-- R format
			when "000000" => 
			regdst_tmp := '1'; alusrc_tmp := '0'; memtoreg_tmp := '0';
			regwrite_tmp := '1'; memread_tmp := '0'; memwrite_tmp := '0';
			branch_tmp := '0'; jump_tmp := '0';
			aluop_tmp := "10"; rf_writesrc_tmp := '0';
			-- LW
			when "100011" => 
			regdst_tmp := '0'; alusrc_tmp := '1'; memtoreg_tmp := '1';
			regwrite_tmp := '1'; memread_tmp := '1'; memwrite_tmp := '0';
			branch_tmp := '0'; jump_tmp := '0'; rf_writesrc_tmp := '0';
			aluop_tmp := "00";
			-- SW
			when "101011" => 
			regdst_tmp := '-'; alusrc_tmp := '1'; memtoreg_tmp := '-';
			regwrite_tmp := '0'; memread_tmp := '0'; memwrite_tmp := '1';
			branch_tmp := '0'; jump_tmp := '0'; rf_writesrc_tmp := '0';
			aluop_tmp := "00";
			-- BEQ
			when "000100" => 
			regdst_tmp := '-'; alusrc_tmp := '0'; memtoreg_tmp := '-';
			regwrite_tmp := '0'; memread_tmp := '0'; memwrite_tmp := '0';
			branch_tmp := '1'; jump_tmp := '0'; rf_writesrc_tmp := '0';
			aluop_tmp := "01";
			-- JUMP
			when "000010" =>
			regdst_tmp := '-'; alusrc_tmp := '-'; memtoreg_tmp := '-';
			regwrite_tmp := '0'; memread_tmp := '0'; memwrite_tmp := '0';
			branch_tmp := '-'; jump_tmp := '1'; rf_writesrc_tmp := '0';
			aluop_tmp := "--";
			-- LUI
			when "001111" =>
			regdst_tmp := '-'; alusrc_tmp := '-'; memtoreg_tmp := '-';
			regwrite_tmp := '1'; memread_tmp := '0'; memwrite_tmp := '0';
			branch_tmp := '0'; jump_tmp := '0'; -- PC add 1
			rf_writesrc_tmp := '1';
			aluop_tmp := "--";
			-- EXCEPTION 
			when others => 
			regdst_tmp := '0'; alusrc_tmp := '0'; memtoreg_tmp := '0';
			regwrite_tmp := '0'; memread_tmp := '0'; memwrite_tmp := '0';
			branch_tmp := '0'; jump_tmp := '0'; rf_writesrc_tmp := '0';
			aluop_tmp := "00";
		end case;
		
		output : case state is
			when IDLE => 
			PC_en <= '0';
			IF_en <= '0';
			regdst <= '0';
			alusrc <= '0';
			memtoreg <= '0';
			regwrite <= '0';
			memread <= '0';
			memwrite <= '0';
			branch <= '0';
			Jump <= '0';
			RF_WriteSrc <= '0';
			ALUOp <= "00";
			
			when IFCH =>
			PC_en <= '0';
			IF_en <= '1';
			regdst <= '0';
			alusrc <= '0';
			memtoreg <= '0';
			regwrite <= '0';
			memread <= '0';
			memwrite <= '0';
			branch <= '0';
			Jump <= '0';
			RF_WriteSrc <= '0';
			ALUOp <= "00";
			
			when ID =>
			PC_en <= '0';
			IF_en <= '0';
			regdst <= regdst_tmp;
			alusrc <= alusrc_tmp;
			memtoreg <= memtoreg_tmp;
			regwrite <= '0';
			memread <= '0';
			memwrite <= '0';
			branch <= branch_tmp;
			Jump <= jump_tmp;
			RF_WriteSrc <= rf_writesrc_tmp;
			ALUOp <= "00";
			
			when EX =>
			PC_en <= '0';
			IF_en <= '0';
			regdst <= regdst_tmp;
			alusrc <= alusrc_tmp;
			memtoreg <= memtoreg_tmp;
			regwrite <= '0';
			memread <= '0';
			memwrite <= '0';
			branch <= branch_tmp;
			Jump <= jump_tmp;
			RF_WriteSrc <= rf_writesrc_tmp;
			ALUOp <= aluop_tmp;
			
			when MEM =>
			PC_en <= '0';
			IF_en <= '0';
			regdst <= regdst_tmp;
			alusrc <= alusrc_tmp;
			memtoreg <= memtoreg_tmp;
			regwrite <= '0';
			memread <= memread_tmp;
			memwrite <= memwrite_tmp;
			branch <= branch_tmp;
			Jump <= jump_tmp;
			RF_WriteSrc <= rf_writesrc_tmp;
			ALUOp <= aluop_tmp;
			
			when WB =>
			PC_en <= '1';
			IF_en <= '0';
			regdst <= regdst_tmp;
			alusrc <= alusrc_tmp;
			memtoreg <= memtoreg_tmp;
			regwrite <= regwrite_tmp;
			memread <= memread_tmp;
			memwrite <= memwrite_tmp;
			branch <= branch_tmp;
			Jump <= jump_tmp;
			RF_WriteSrc <= rf_writesrc_tmp;
			ALUOp <= aluop_tmp;
			
			when others =>
			PC_en <= '0';
			IF_en <= '0';
			regdst <= '0';
			alusrc <= '0';
			memtoreg <= '0';
			regwrite <= '0';
			memread <= '0';
			memwrite <= '0';
			branch <= '0';
			Jump <= '0';
			RF_WriteSrc <= '0';
			ALUOp <= "00";
			
		end case;
	end process;
	
	next_state: process(clk)
	begin
		if rising_edge(clk) then 
			if(proc_en = '0') then state <= IDLE;
			elsif proc_en = '1' then
				if state = IDLE then state <= IFCH;
				elsif state = IFCH then state <= ID;
				elsif state = ID then state <= EX;
				elsif state = EX then state <= MEM;
				elsif state = MEM then state <= WB;
				elsif state = WB then state <= IFCH; -- don't forget
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

