library ieee; 
use ieee.std_logic_1164.all; 
 
entity IFID_register is 
  port(Clk, reset : in  std_logic;
  		instruction_i, pc_i: in std_logic_vector(31 downto 0);
        instruction_o, pc_o : out std_logic_vector(31 downto 0)); 
end IFID_register;

architecture IFID_register_a of IFID_register is 
	type tmp_array is array (0 to 1) of  std_logic_vector(31 downto 0);
	signal instruction_tmp, pc_tmp: tmp_array;
  	begin 
    process (Clk) 
	begin
		if (reset = '1') then
			instruction_tmp(0) <= (others => '0');
			instruction_tmp(1) <= (others => '0');
			pc_tmp(0) <= (others => '0');
			pc_tmp(1) <= (others => '0');
        elsif (rising_edge(clk)) then
			instruction_tmp(0) <= instruction_tmp(1);
			pc_tmp(0) <= pc_tmp(1);
          	instruction_tmp(1) <= instruction_i;
		  	pc_tmp(1) <= pc_i;
        end if; 
    end process; 
    instruction_o <= instruction_tmp(0);
	pc_o <= pc_tmp(0);
end IFID_register_a; 