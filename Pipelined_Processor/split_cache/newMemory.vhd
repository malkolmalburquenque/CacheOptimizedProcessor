--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY newMemory IS
	GENERIC(
	-- might need to change it 
		ram_size : INTEGER := 8192;
		mem_delay : time := 20 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO ram_size-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC;
		writeToText : IN STD_LOGIC
	);
END newMemory;

ARCHITECTURE rtl OF newMemory IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg: INTEGER RANGE 0 to ram_size-1;
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';
	
BEGIN
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
	
	FILE f : text;
	variable row : line;
	variable rowData : std_logic_vector(31 downto 0);
	variable rowCounter : integer:=0;
	
	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		IF(now < 1 ps)THEN
			For i in 0 to ram_size-1 LOOP
				ram_block(i) <= std_logic_vector(to_unsigned(0,32));
			END LOOP;	
			file_open(f,"program.txt.",READ_MODE);
		while (not endfile(f)) loop
			
			readline(f,row);
			read(row,rowData);
			ram_block(rowCounter) <= rowData;
			rowCounter := rowCounter + 1;
			
		end loop;
			
		end if;
		file_close(f);

		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			IF (memwrite = '1') THEN
				ram_block(address) <= writedata;
			END IF;
		read_address_reg <= address;
		END IF;
	END PROCESS;
	readdata <= ram_block(read_address_reg);

	--The waitrequest signal is used to vary response time in simulation
	--Read and write should never happen at the same time.
	waitreq_w_proc: PROCESS (memwrite)
	BEGIN
		IF(memwrite'event AND memwrite = '1')THEN
			write_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;

		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (memread)
	BEGIN
		IF(memread'event AND memread = '1')THEN
			read_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;
	waitrequest <= write_waitreq_reg and read_waitreq_reg;
	
	process(writeToText)
		file memoryFile : text open write_mode is "memory.txt";
		variable outLine : line;	
		variable rowLine : integer := 0;

		begin
		if writeToText = '1' then
		
		while (rowLine < 8192) loop 
		
			write(outLine, ram_block(rowLine));
			writeline(memoryFile, outLine);
			rowLine := rowLine + 1;
			
		end loop;
	end if;	
	end process;

END rtl;
