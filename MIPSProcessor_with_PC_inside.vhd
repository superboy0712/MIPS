-- Part of TDT4255 Computer Design laboratory exercises
-- Group for Computer Architecture and Design
-- Department of Computer and Information Science
-- Norwegian University of Science and Technology

-- MIPSProcessor.vhd
-- The MIPS processor component to be used in Exercise 1 and 2.

-- TODO replace the architecture DummyArch with a working Behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPSProcessor is
	generic (
		ADDR_WIDTH : integer := 8;
		DATA_WIDTH : integer := 32
	);
	port (
		clk, reset 				: in std_logic;
		processor_enable		: in std_logic;
		imem_data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0); -- instruction memory in
		imem_address			: out std_logic_vector(ADDR_WIDTH-1 downto 0);-- instruction memory address
		dmem_data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0); -- data memory in
		dmem_address			: out std_logic_vector(ADDR_WIDTH-1 downto 0);-- data memory address
		dmem_data_out			: out std_logic_vector(DATA_WIDTH-1 downto 0);-- data memory out
		dmem_write_enable		: out std_logic
	);
end MIPSProcessor;

architecture behavioral of MIPSProcessor is	
	-- component declaration
	COMPONENT MIPS_main_controller
	PORT(
		proc_en : IN std_logic;
		clk : IN std_logic;
		Opcode : IN std_logic_vector(31 downto 26);          
		PC_en : OUT std_logic;
		IF_en : OUT std_logic;
		ALUOp : OUT std_logic_vector(1 downto 0);
		RegDst : OUT std_logic;
		ALUSrc : OUT std_logic;
		MemtoReg : OUT std_logic;
		RegWrite : OUT std_logic;
		MemRead : OUT std_logic;
		MemWrite : OUT std_logic;
		Branch : OUT std_logic;
		Jump : OUT std_logic;
		RF_WriteSrc : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT reg_file
	PORT(
		clk : IN std_logic;
		wr_en : IN std_logic;
		rd_reg_num1 : IN std_logic_vector(4 downto 0);
		rd_reg_num2 : IN std_logic_vector(4 downto 0);
		wr_reg_num : IN std_logic_vector(4 downto 0);
		wr_data : IN std_logic_vector(31 downto 0);          
		rd_data1 : OUT std_logic_vector(31 downto 0);
		rd_data2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT alu
	PORT(
		alu_ctrl : IN std_logic_vector(3 downto 0);
		alu_src1 : IN std_logic_vector(31 downto 0);
		alu_src2 : IN std_logic_vector(31 downto 0);          
		alu_zero : OUT std_logic;
		alu_result : OUT std_logic_vector(31 downto 0);
		alu_carry : OUT std_logic
		);
	END COMPONENT;
	
	-- COMPONENT MIPS_PC_with_src_select
	-- PORT(
		-- reset : IN std_logic;
		-- PC_en : IN std_logic;
		-- clk : IN std_logic;
		-- PCSrc : IN std_logic;
		-- offeset_address : IN std_logic_vector(31 downto 0);          
		-- PC : OUT std_logic_vector(31 downto 0)
		-- );
	-- END COMPONENT;
	
	COMPONENT MIPS_ALU_ctrl
	PORT(
		funct_code : IN std_logic_vector(5 downto 0);
		ALU_op : IN std_logic_vector(1 downto 0);          
		ALU_ctrl : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	-- signals declaration
	-- instruction register, for stable fetch instruction
	signal instr_reg : std_logic_vector (31 downto 0);
	-- for stable processor_enable signal, delays half cycle
	signal inside_clk : std_logic;
	-- for address length compatible
	signal dmem_address_32bit : std_logic_vector (31 downto 0);
	signal imem_address_32bit : std_logic_vector (31 downto 0);
	-- for reg_file
	signal reg_file_WrReg : std_logic_vector (4 downto 0);
	signal mem_to_reg_mux_output : std_logic_vector (31 downto 0);
	signal reg_file_wrDat_Mux_output : std_logic_vector(31 downto 0);
	signal reg_file_Rd1_to_ALUSrc1 : std_logic_vector(31 downto 0);
	signal reg_file_Rd2 : std_logic_vector(31 downto 0); -- actually connected to dmem_data_out
	signal upper_immediate : std_logic_vector(31 downto 0);
	-- for ALU
	signal ALU_Src2 : std_logic_vector(31 downto 0);
	signal ALU_to_ALUCtrl : std_logic_vector(3 downto 0);
	signal ALU_result : std_logic_vector(31 downto 0);
	signal ALU_zero : std_logic;
	signal ALU_carry : std_logic; -- not connected yet!! not implemented
	-- for PC_with_MUX_and_shifter
	signal PC : std_logic_vector (31 downto 0);
	signal PC_output : std_logic_vector (31 downto 0);
	signal PC_add_1 : std_logic_vector (31 downto 0);
	signal PCSrc : std_logic;
	signal PC_offeset_address : std_logic_vector (31 downto 0);
	signal PC_branch_address : std_logic_vector (31 downto 0);
	signal branch_tmp : std_logic_vector (31 downto 0);
	signal Jump_address : std_logic_vector(31 downto 0);
	-- for Main Controller
	signal PC_en, IF_en, RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jump, RF_WriteSrc: std_logic;
	signal ALUOp : std_logic_vector(1 downto 0);
	
begin
	-- component instantiation
	Inst_MIPS_main_controller: MIPS_main_controller PORT MAP(
		proc_en => processor_enable,
		clk => inside_clk,
		Opcode => instr_reg(31 downto 26),
		PC_en => PC_en,
		IF_en => IF_en, 
		ALUOp => ALUOp,
		RegDst => RegDst,
		ALUSrc => ALUSrc,
		MemtoReg => MemtoReg,
		RegWrite => RegWrite,
		MemRead => MemRead,
		MemWrite => MemWrite,
		Branch => Branch,
		Jump => Jump,
		RF_WriteSrc => RF_WriteSrc
	);
	dmem_write_enable <= MemWrite;-- AND (NOT MemRead); -- no read_enable port from dmem
	Inst_reg_file: reg_file PORT MAP(
		clk => inside_clk,
		wr_en => RegWrite,
		rd_reg_num1 => instr_reg(25 downto 21),
		rd_reg_num2 => instr_reg(20 downto 16),
		wr_reg_num => reg_file_WrReg,
		wr_data => reg_file_wrDat_Mux_output,
		rd_data1 => reg_file_Rd1_to_ALUSrc1,
		rd_data2 => reg_file_Rd2
	);
	
	Inst_alu: alu PORT MAP(
		alu_ctrl => ALU_to_ALUCtrl,
		alu_src1 => reg_file_Rd1_to_ALUSrc1,
		alu_src2 => ALU_Src2,
		alu_zero => ALU_zero,
		alu_result => ALU_result,
		alu_carry => ALU_carry
	);
	dmem_address_32bit <= ALU_result;
	
	-- Inst_MIPS_PC_with_src_select: MIPS_PC_with_src_select PORT MAP(
		-- reset => reset,
		-- PC_en => PC_en,
		-- clk => inside_clk,
		-- PCSrc => PCSrc,
		-- offeset_address => PC_offeset_address,
		-- PC => imem_address_32bit
	-- );
	-- FOR PC
	imem_address_32bit <= PC;
	PC_add_1 <= std_logic_vector(unsigned(PC) + X"00000001");
	Jump_address <= PC_add_1(31 downto 28) & "00" & instr_reg(25 downto 0); -- not shifting, becoz the actual mem_in is word address/ not byte address
	PC_branch_address <= std_logic_vector(signed(PC_add_1) + signed(PC_offeset_address));
	
		branch_tmp <= PC_add_1 when PCSrc = '0' else
						PC_branch_address;
		
		PC_output <= branch_tmp when Jump = '0' else
						Jump_address;
	
	PC_update : process(inside_clk)
	begin
		if rising_edge(inside_clk) then
			if reset = '1' then PC <= X"00000000";
			elsif reset = '0' then
				if PC_en = '1' then PC <= PC_output;
				end if;
			end if;
		end if;
	end process;
	--
	PCSrc <= Branch AND ALU_zero;
	
	inside_clk_generator : process(clk) -- change to delay 0.5 cycle after PC_CLK
	begin
		inside_clk <= NOT clk;
	end process;
	
	Inst_MIPS_ALU_ctrl: MIPS_ALU_ctrl PORT MAP(
		funct_code => instr_reg(5 downto 0),
		ALU_op => ALUOp,
		ALU_ctrl => ALU_to_ALUCtrl
	);
	-- 
	Instru_reg_fetch: process(inside_clk)
	begin
		if rising_edge(inside_clk) then 
			if IF_en = '1' then instr_reg <= imem_data_in;
			end if;
		end if;
	end process;
	
	MUX_RegDst : process(instr_reg(20 downto 16),instr_reg(15 downto 11),RegDst)
	begin 
		if RegDst = '1' then reg_file_WrReg <= instr_reg(15 downto 11);
		else reg_file_WrReg <= instr_reg(20 downto 16);
		end if;
	end process;
	
	MUX_MemtoReg : process(MemtoReg, ALU_result, dmem_data_in)
	begin
		if MemtoReg = '1' then mem_to_reg_mux_output <= dmem_data_in;
		else mem_to_reg_mux_output <= ALU_result;
		end if;
	end process;
	
	-- for LUI upper immediate covert 
	upper_immediate <= instr_reg(15 downto 0) & X"0000";
	MUX_regfile_WriteDat : reg_file_wrDat_Mux_output <= upper_immediate when RF_WriteSrc = '1' else
													mem_to_reg_mux_output;
													
	MUX_ALUSrc : process(ALUSrc, PC_offeset_address, reg_file_Rd2)
	begin
		if ALUSrc = '1' then ALU_Src2 <= PC_offeset_address;
		else ALU_Src2 <= reg_file_Rd2;
		end if;
	end process;
	
	Sign_extend : process(instr_reg(15 downto 0))
	begin
		PC_offeset_address <= std_logic_vector(resize(signed(instr_reg(15 downto 0)), PC_offeset_address'length));
	end process;
	
	dmem_data_out <= reg_file_Rd2;
	-- use a register to delay half a cycle
	--dmem_address <= std_logic_vector(resize(unsigned(dmem_address_32bit), dmem_address'length));
	--imem_address <= std_logic_vector(resize(unsigned(imem_address_32bit), imem_address'length));
	dmem_address <= dmem_address_32bit(7 downto 0); -- only use 8 least significant bits
	imem_address <= imem_address_32bit(7 downto 0);
	--ALU_carry <= '0'; -- not used
end architecture;