library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file is 
	generic(
		constant width		: natural := 32;
		constant depth		: natural := 32
	);
	port(
		clk			: in std_logic;
		wr_en		: in std_logic;
		-- input
		rd_reg_num1 : in std_logic_vector( 4 downto 0);
		rd_reg_num2 : in std_logic_vector( 4 downto 0);
		wr_reg_num  : in std_logic_vector( 4 downto 0);
		
		wr_data		: in std_logic_vector( width - 1 downto 0);
		-- output
		
		rd_data1	: out std_logic_vector( width - 1 downto 0);
		rd_data2	: out std_logic_vector( width - 1 downto 0)
	);
end reg_file;

architecture behavioral of reg_file is
	-- an array of size 32, width 32
	type reg_array is array( 0 to 31 ) of std_logic_vector ( 31 downto 0 );
	signal reg_file : reg_array := (others =>(others => '0'));
	
begin 

		write1 : process(clk)
			begin
			if rising_edge(clk) then
				if wr_en = '1' then
					if to_integer(unsigned(wr_reg_num)) /= 0 then
						reg_file(to_integer(unsigned(wr_reg_num))) <= wr_data;
					end if;
				end if;
			end if;
		end process;
		
		rd_data1 <= reg_file(to_integer(unsigned(rd_reg_num1)));	
		rd_data2 <= reg_file(to_integer(unsigned(rd_reg_num2)));
			
end behavioral;



