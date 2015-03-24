																														  library ieee; 
use ieee.std_logic_1164.all; 
 
entity EXMEM_register is 
  port(Clk, reset : in  std_logic;
  		pc_i, data2_i, ALU_ressult_i: in std_logic_vector(31 downto 0);
        pc_o, data2_o, ALU_ressult_o: out std_logic_vector(31 downto 0);
		register_address_i: in std_logic_vector(4 downto 0);
		register_address_o: out std_logic_vector(4 downto 0);
		Branch_i, MemRead_i, MemtoReg_i, MemWrite_i, RegWrite_i: in std_logic;	 
		Branch_o, MemRead_o, MemtoReg_o, MemWrite_o, RegWrite_o: out std_logic);
end EXMEM_register;

architecture EXMEM_register_a of EXMEM_register is 
type tmp_array is array (0 to 1) of  std_logic_vector(31 downto 0);
type tmp_array_short is array (0 to 1) of std_logic_vector(4 downto 0);	
type tmp_array_logic is array (0 to 1) of std_logic;
signal pc_tmp, data2_tmp, ALU_ressult_tmp: tmp_array; 
signal register_address_tmp: tmp_array_short;		
signal Branch_tmp, MemRead_tmp, MemtoReg_tmp, MemWrite_tmp, RegWrite_tmp: tmp_array_logic;
  	begin 
    process (Clk) 
	begin
		if (reset = '1') then
			pc_tmp(1) <= (others => '0'); 
			data2_tmp(1) <= (others => '0');
			register_address_tmp(1) <= (others => '0');
			ALU_ressult_tmp(1) <= (others => '0'); 
			Branch_tmp(1) <= '0';	
			MemRead_tmp(1) <= '0';	
			MemtoReg_tmp(1) <= '0';	
			MemWrite_tmp(1) <= '0';
			RegWrite_tmp(1) <= '0';
			
        elsif (rising_edge(clk)) then
			pc_tmp(0) <= pc_tmp(1);	 
			data2_tmp(0) <= data2_tmp(1);
			register_address_tmp(0) <= register_address_tmp(1);
			ALU_ressult_tmp(0) <= ALU_ressult_tmp(1);  
			Branch_tmp(0) <= Branch_tmp(1); 
			MemRead_tmp(0) <= MemRead_tmp(1); 
			MemtoReg_tmp(0) <= MemtoReg_tmp(1); 
			MemWrite_tmp(0) <= MemWrite_tmp(1);
			RegWrite_tmp(0) <= RegWrite_tmp(1);
			
		  	pc_tmp(1) <= pc_i; 
			data2_tmp(1) <= data2_i;
			register_address_tmp(1) <= register_address_i;
			ALU_ressult_tmp(1) <= ALU_ressult_i;  
			Branch_tmp(1) <= Branch_i;
			MemRead_tmp(1) <= MemRead_i; 
			MemtoReg_tmp(1) <= MemtoReg_i;
			MemWrite_tmp(1) <= MemWrite_i; 
			RegWrite_tmp(1) <= RegWrite_i;
			
        end if; 
    end process; 
	pc_o <= pc_tmp(0);
	data2_o <= data2_tmp(0);
	register_address_o <= register_address_tmp(0);
	ALU_ressult_o <= ALU_ressult_tmp(0);  
	Branch_o <= Branch_tmp(0); 
	MemRead_o <= MemRead_tmp(0);  
	MemtoReg_o <= MemtoReg_tmp(0);
	MemWrite_o <= MemWrite_tmp(0); 
	RegWrite_o <= RegWrite_tmp(0);
	
end EXMEM_register_a; 