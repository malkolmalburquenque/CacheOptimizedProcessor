LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY signextender IS
    PORT (
        immediate_in: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        immediate_out: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END signextender;

ARCHITECTURE Behavioral OF signextender IS

BEGIN
process (immediate_in)
begin
	--Only Sign extend at the moment
	if immediate_in(15) = '1' then
		immediate_out(31 downto 16) <= "1000000000000000";
	else
		immediate_out(31 downto 16) <= "0000000000000000";
	end if;
	immediate_out(15 downto 0) <= immediate_in;
end process;
END Behavioral;
