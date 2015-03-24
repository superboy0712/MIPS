LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity  alu is
	port (
		alu_ctrl			: in std_logic_vector(3 downto 0);
        alu_src1, alu_src2	: in std_logic_vector(31 downto 0);
        alu_zero		    : out std_logic; 
        alu_result			: out std_logic_vector(31 downto 0);
		alu_carry			: out std_logic
	);
end alu;

architecture behavioral of alu is

begin
	process(alu_src1, alu_src2, alu_ctrl)
	
		variable src1, src2, result	: signed(31 downto 0 );
		variable zero				: std_logic;
	
	begin
	--
		src1 := signed(alu_src1);
		src2 := signed(alu_src2);
		result := (others => '0');
		zero := '0';
	--
		case alu_ctrl is
		--AND
			when "0000" =>
			result := src1 and src2;
		--OR
			when "0001" =>
			result := src1 or src2;
		--ADD
			when "0010" =>
			result := src1 + src2;
		--SUB
			when "0110" =>
			result := src1 - src2;
		--SLT
			when "0111" =>
			if src1 < src2 then result(0) := '1';
			else result(0) := '0';
			end if;
		--NOR
			when "1100" =>
			result := src1 nor src2;
		--error
			when others =>
			result := (others => '0');
		end case;
		
		if to_integer(result) = 0 then zero := '1';
		else zero := '0';
		end if;
		
		alu_result <= std_logic_vector(result);
		alu_zero <= zero;
	end process;	
	
end behavioral;