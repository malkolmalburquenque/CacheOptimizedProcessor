LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY register_file IS
	GENERIC(
		register_size: INTEGER := 32 --MIPS register size is 32 bit
	);

	PORT(
		-- ************** Do we need a standard enable input ? *****************
		clock: IN STD_LOGIC;
		rs: IN STD_LOGIC_VECTOR (4 downto 0); -- first source register
		rt: IN STD_LOGIC_VECTOR (4 downto 0); -- second source register
		write_enable: IN STD_LOGIC; -- signals that rd_data may be written into rd 					**********Unsure if neccessary*************
		rd: IN STD_LOGIC_VECTOR (4 downto 0); -- destination register
		rd_data: IN STD_LOGIC_VECTOR (31 downto 0); -- destination register data
		writeToText: IN STD_LOGIC := '0';
		
		ra_data: OUT STD_LOGIC_VECTOR (31 downto 0); -- data of register a
		rb_data: OUT STD_LOGIC_VECTOR (31 downto 0) -- data of register b
	);
END register_file;

ARCHITECTURE Behav OF register_file IS

TYPE registers IS ARRAY (0 to 31) OF STD_LOGIC_VECTOR(31 downto 0); -- MIPS has 32 registers. Size of data is 32 bits. => 32x32bits
SIGNAL register_store: registers := (OTHERS=> "00000000000000000000000000000000"); -- initialize all registers to 32 bits of 0.

BEGIN
	PROCESS (clock)
	BEGIN
		IF (clock'event) THEN
			ra_data <= register_store(to_integer(unsigned(rs))); -- data of ra is now the data associated with rs's register index in the register_store
			rb_data <= register_store(to_integer(unsigned(rt)));
			IF (write_enable = '1') THEN -- if write_enable is high, we have permission to update the data of rd
				IF (to_integer(unsigned(rd)) = 0) THEN -- if we are trying to write to R0, then deny the write
					NULL;
				ELSE
					register_store(to_integer(unsigned(rd))) <= rd_data; -- access the appropriate register in the register_store, and assign it rd_data
				END IF;
			END IF;
		END IF;
	END PROCESS;

	process(writeToText)
	file register_file : text open write_mode is "register_file.txt";
	variable outLine : line;	
	variable rowLine : integer := 0;
	variable test : std_logic_vector(31 downto 0) := "00100000000000010000000000000001";
	
	begin
	if writeToText = '1' then
	
	while (rowLine < 32) loop 
	
	write(outLine, register_store(rowLine));
	writeline(register_file, outLine);
	rowLine := rowLine + 1;
	
	end loop;
	
	
	end if;
	
	end process;
	
	
END Behav;
