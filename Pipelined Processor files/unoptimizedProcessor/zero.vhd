library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity zero is
port (input_a : in std_logic_vector (31 downto 0);
	input_b : in std_logic_vector (31 downto 0);
	optype : in std_logic_vector (4 downto 0);
	result: out std_logic := '0'
  );
end zero;

architecture behavioral of zero is

begin
process (input_a, input_b, optype)
begin
	case optype is
		when "10110" => -- beq
			if unsigned(input_a) = unsigned(input_b) then
				result <= '1';
			else
				result <= '0';
			end if;
		when "10111" => -- bne
			if unsigned(input_a) = unsigned(input_b) then
				result <= '0';
			else
				result <= '1';
			end if;
		when "11000" => -- j
			result <= '1';

		when "11001" => -- jr
			result <= '1';

		when "11010" => -- jal
			result <= '1';
		when others =>
			result <= '0';
	end case;
end process;

end behavioral;