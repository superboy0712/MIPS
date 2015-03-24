																														  library ieee; 
use ieee.std_logic_1164.all; 
 
entity EXMEM_register is 
  port(Clk, reset : in  std_logic;
  		ALU_ressult_i, data_mem_i: in std_logic_vector(31 downto 0);
        ALU_ressult_o, data_mem_o: out std_logic_vector(31 downto 0);
		register_address_i: in std_logic_vector(4 downto 0);
		register_address_o: out std_logic_vector(4 downto 0);
		MemtoReg_i, RegWrite_i: in std_logic;	 
		MemtoReg_o, RegWrite_o: out std_logic);
end EXMEM_register;

architecture EXMEM_register_a of EXMEM_register is 
type tmp_array is array (0 to 1) of  std_logic_vector(31 downto 0);
type tmp_array_short is array (0 to 1) of std_logic_vector(4 downto 0);
type tmp_array_logic is array (0 to 1) of std_logic;
signal data_mem_tmp, ALU_ressult_tmp: tmp_array; 
signal register_address_tmp: tmp_array_short;		
signal MemtoReg_tmp, RegWrite_tmp: tmp_array_logic;
  	begin 
    process (Clk) 
	begin
		if (reset = '1') then 
			data_mem_tmp(1) <= (others => '0');
			register_address_tmp(1) <= (others => '0');
			ALU_ressult_tmp(1) <= (others => '0');
			MemtoReg_tmp(1) <= '0';	
			RegWrite_tmp(1) <= '0';
			
        elsif (rising_edge(clk)) then
			data_mem_tmp(0) <= data_mem_tmp(1);
			register_address_tmp(0) <= register_address_tmp(1);
			ALU_ressult_tmp(0) <= ALU_ressult_tmp(1);
			MemtoReg_tmp(0) <= MemtoReg_tmp(1); 
			RegWrite_tmp(0) <= RegWrite_tmp(1);
			 
			data_mem_tmp(1) <= data_mem_i;
			register_address_tmp(1) <= register_address_i;
			ALU_ressult_tmp(1) <= ALU_ressult_i;
			MemtoReg_tmp(1) <= MemtoReg_i;
			RegWrite_tmp(1) <= RegWrite_i;
			
        end if; 
    end process; 
	data_mem_o <= data_mem_tmp(0);
	register_address_o <= register_address_tmp(0);
	ALU_ressult_o <= ALU_ressult_tmp(0);
	MemtoReg_o <= MemtoReg_tmp(0);
	RegWrite_o <= RegWrite_tmp(0);
	
end EXMEM_register_a; 