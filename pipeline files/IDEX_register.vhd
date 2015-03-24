library ieee; 
use ieee.std_logic_1164.all; 
 
entity IDEX_register is 
  port(Clk, reset : in  std_logic;
  		sign_extended_i, pc_i, data1_i, data2_i: in std_logic_vector(31 downto 0);
        sign_extended_o, pc_o, data1_o, data2_o: out std_logic_vector(31 downto 0);
		register_address_0_i, register_address_1_i: in std_logic_vector(4 downto 0);
		register_address_0_o, register_address_1_o: out std_logic_vector(4 downto 0);
		RegDst_i, Jump_i, Branch_i, MemRead_i, MemtoReg_i, ALUOp_i, MemWrite_i, ALUSrc_i, RegWrite_i: in std_logic;	 
		RegDst_o, Jump_o, Branch_o, MemRead_o, MemtoReg_o, ALUOp_o, MemWrite_o, ALUSrc_o, RegWrite_o: out std_logic);
end IDEX_register;

architecture IDEX_register_a of IDEX_register is 
type tmp_array is array (0 to 1) of  std_logic_vector(31 downto 0);
type tmp_array_short is array (0 to 1) of std_logic_vector(4 downto 0);
type tmp_array_logic is array (0 to 1) of std_logic;
signal pc_tmp, sign_extended_tmp, data1_tmp, data2_tmp: tmp_array; 
signal register_address_0_tmp, register_address_1_tmp: tmp_array_short;
signal RegDst_tmp, Jump_tmp ,Branch_tmp, MemRead_tmp, MemtoReg_tmp, ALUOp_tmp, MemWrite_tmp, ALUSrc_tmp, RegWrite_tmp: tmp_array_logic;



  	begin 
    process (Clk) 
	begin
		if (reset = '1') then
			pc_tmp(1) <= (others => '0'); 
			sign_extended_tmp(1) <= (others => '0');
			data1_tmp(1) <= (others => '0');
			data2_tmp(1) <= (others => '0');
			register_address_0_tmp(1) <= (others => '0');
			register_address_1_tmp(1) <= (others => '0');
			RegDst_tmp(1) <= '0';	
			Jump_tmp(1) <= '0';	
			Branch_tmp(1) <= '0';	
			MemRead_tmp(1) <= '0';	
			MemtoReg_tmp(1) <= '0';
			ALUOp_tmp(1) <= '0';	
			MemWrite_tmp(1) <= '0';
			ALUSrc_tmp(1) <= '0';	
			RegWrite_tmp(1) <= '0';
			
        elsif (rising_edge(clk)) then
			pc_tmp(0) <= pc_tmp(1);	 
			sign_extended_tmp(0) <= sign_extended_tmp(1);
			data1_tmp(0) <= data1_tmp(1);
			data2_tmp(0) <= data2_tmp(1);
			register_address_0_tmp(0) <= register_address_0_tmp(1);
			register_address_1_tmp(0) <= register_address_1_tmp(1);
			RegDst_tmp(0) <= RegDst_tmp(1); 
			Jump_tmp(0) <= Jump_tmp(1);  
			Branch_tmp(0) <= Branch_tmp(1); 
			MemRead_tmp(0) <= MemRead_tmp(1); 
			MemtoReg_tmp(0) <= MemtoReg_tmp(1);
			ALUOp_tmp(0) <= ALUOp_tmp(1); 
			MemWrite_tmp(0) <= MemWrite_tmp(1);
			ALUSrc_tmp(0) <= ALUSrc_tmp(1); 
			RegWrite_tmp(0) <= RegWrite_tmp(1);
			
		  	pc_tmp(1) <= pc_i; 
			sign_extended_tmp(1) <= sign_extended_i;
			data1_tmp(1) <= data1_i;
			data2_tmp(1) <= data2_i;
			register_address_0_tmp(1) <= register_address_0_i;
			register_address_1_tmp(1) <= register_address_1_i;
			RegDst_tmp(1) <= RegDst_i; 
			Jump_tmp(1) <= Jump_i;  
			Branch_tmp(1) <= Branch_i;
			MemRead_tmp(1) <= MemRead_i; 
			MemtoReg_tmp(1) <= MemtoReg_i;
			ALUOp_tmp(1) <= ALUOp_i; 
			MemWrite_tmp(1) <= MemWrite_i;
			ALUSrc_tmp(1) <= ALUSrc_i; 
			RegWrite_tmp(1) <= RegWrite_i;
			
			
        end if; 
    end process; 
	pc_o <= pc_tmp(0);
	sign_extended_o <= sign_extended_tmp(0);
	data1_o <= data1_tmp(0);
	data2_o <= data2_tmp(0);
	register_address_0_o <= register_address_0_tmp(0);
	register_address_1_o <= register_address_1_tmp(0);
	RegDst_o <= RegDst_tmp(0); 
	Jump_o <= Jump_tmp(0);  
	Branch_o <= Branch_tmp(0); 
	MemRead_o <= MemRead_tmp(0);  
	MemtoReg_o <= MemtoReg_tmp(0);
	ALUOp_o <= ALUOp_tmp(0); 
	MemWrite_o <= MemWrite_tmp(0);
	ALUSrc_o <= ALUSrc_tmp(0); 
	RegWrite_o <= RegWrite_tmp(0);
	
	
end IDEX_register_a; 