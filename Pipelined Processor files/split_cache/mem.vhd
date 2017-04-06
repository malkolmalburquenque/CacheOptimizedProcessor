library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
GENERIC(
	ram_size : INTEGER := 8192; 
	mem_delay : time := 10 ns;
	clock_period : time := 1 ns
);
port (clk: in std_logic;
	-- Control lines
	ctrl_write : in std_logic;
	ctrl_read: in std_logic;
	ctrl_memtoreg_in: in std_logic;
	ctrl_memtoreg_out: out std_logic;
	ctrl_regwrite_in: in std_logic;
	ctrl_regwrite_out: out std_logic;
	ctrl_jal: in std_logic;
		
	--Ports of stage
	alu_in : in std_logic_vector (31 downto 0);
	alu_out : out std_logic_vector (31 downto 0);
	mem_data_in: in std_logic_vector (31 downto 0);
	mem_data_out: out std_logic_vector (31 downto 0);
	write_addr_in: in std_logic_vector (4 downto 0);
	write_addr_out: out std_logic_vector (4 downto 0);
	
	--Memory signals
	writedata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	address: OUT INTEGER RANGE 0 TO ram_size-1;
	memwrite: OUT STD_LOGIC := '0';
	memread: OUT STD_LOGIC := '0';
	readdata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	waitrequest: IN STD_LOGIC
	
  );
end mem;

architecture behavioral of mem is


signal mem_data_next, alu_next, address_next: std_logic_vector (31 downto 0);
signal write_addr_next: std_logic_vector (4 downto 0);
signal ctrl_memtoreg_next, ctrl_regwrite_next: std_logic;
			
begin

process (clk)
begin
	if (clk'event and clk = '1') then
		write_addr_out <= write_addr_next;
		mem_data_out <= mem_data_next;
		alu_out <= alu_next;
		
		
		ctrl_regwrite_out <= ctrl_regwrite_next;
		ctrl_memtoreg_out <= ctrl_memtoreg_next;

	end if;
end process;


process (write_addr_in , ctrl_memtoreg_in, ctrl_regwrite_in, alu_in)
begin
	memwrite <= '0';
	memread <= '0';
	
	--Propogate signals
	write_addr_next <= write_addr_in;
	ctrl_memtoreg_next <= ctrl_memtoreg_in;
	ctrl_regwrite_next <= ctrl_regwrite_in;
	
	--FOR JAL
	if ctrl_jal = '1' then
		alu_next <= mem_data_in;
	else
		alu_next <= alu_in;
	end if;

	--Access memory
	
	if ctrl_write = '1' then
		address <= to_integer(unsigned(alu_in));	
		memwrite <= '1'; 	
		writedata <= mem_data_in;
	elsif ctrl_read = '1' then
		address <= to_integer(unsigned(alu_in));	
		memread <= '1';
		
	end if;
end process;
mem_data_next <= readdata;
end behavioral;