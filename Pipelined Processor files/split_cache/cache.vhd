--This is a 16 bit cache implementation
--Consider how it will run with a clock

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache is
generic(
	ram_size : INTEGER := 8192
);
port(

	clock : in std_logic;
	reset : in std_logic;

	-- Avalon interface --
	s_addr : in std_logic_vector (31 downto 0);
	s_read : in std_logic;
	s_readdata : out std_logic_vector (31 downto 0);
	s_write : in std_logic;
	s_writedata : in std_logic_vector (31 downto 0);
	s_waitrequest : out std_logic;

	m_addr : out integer range 0 to ram_size-1;
	m_read : out std_logic;
	m_readdata : in std_logic_vector (31 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (31 downto 0);
	m_waitrequest : in std_logic
);
end cache;

architecture arch of cache is
type state_type is (start, r, w, r_memread, r_memwrite, r_memwait, w_memwrite);
signal state : state_type;
signal next_state : state_type;

--Address struct
--26 bits of tag
--4 bits of index
--2 bits of offset


-- Cache struct [16]
type cache_def is array (0 to 15) of std_logic_vector (154 downto 0);
signal cache2 : cache_def;
--1 bit valid
--1 bit dirty
--26 bit tag
--128 bit data

begin
process (clock, reset)
begin
	if reset = '1' then
		state <= start;
	elsif (clock'event and clock = '1') then
		state <= next_state;
	end if;
end process;	

process (s_read, s_write, m_waitrequest, state)
	variable index : INTEGER;	
	variable Offset : INTEGER := 0;
	variable off : INTEGER := Offset - 1;
	variable count : INTEGER := 0;
	variable addr : std_logic_vector (12 downto 0);
begin
	index := to_integer(unsigned(s_addr(5 downto 2)));
	Offset := to_integer(unsigned(s_addr(1 downto 0))) + 1;
	off :=  Offset - 1;

	case state is
	
		when start =>
			s_waitrequest <= '1';
			if s_read = '1' then --READ
				next_state <= r;
			elsif s_write = '1' then --WRITE
				next_state <= w;
			else
				next_state <= start;
			end if;
			
		when r =>
			-- if valid and tags match
			if cache2(index)(154) = '1' and cache2(index)(152 downto 127) = s_addr (31 downto 6) then --HIT     address = tag of cache index
				s_readdata <= cache2(index)(127 downto 0) ((Offset * 32) -1 downto 32*off);  -- output 32 bits of data block depending on offset of last 2 bits of address)
				s_waitrequest <= '0';
				next_state <= start;
			elsif cache2(index)(153) = '1' then --MISS DIRTY
				next_state <= r_memwrite;
			elsif cache2(index)(153) = '0' or  cache2(index)(153) = 'U' then --MISS CLEAN
				next_state <= r_memread;
			else
				next_state <= r;
			end if;
				
		when r_memwrite =>
			if count < 4 and m_waitrequest = '1' and next_state /= r_memread then -- EVICT
				addr := cache2(index)(133 downto 127) & s_addr (5 downto 0);   -- create new address with last 8 bits of tag  + 7 bits of address
				m_addr <= to_integer(unsigned (addr));	-- set the address to memory
				m_write <= '1'; -- write into memory
				m_read <= '0';
				m_writedata <= cache2(index)(127 downto 0)((Offset * 32) -1 downto 32*off); -- write into memory  4 byte = 1 word 
				count := 4; -- go to mem read next CC 
				next_state <= r_memwrite;  -- after letting the memory write, read the value 
			
			elsif count = 4 then 
				count := 0;
				next_state <= r_memread;
			else
				m_write <= '0';
				next_state <= r_memwrite;
			end if;
		-- Need to test this part 
		when r_memread =>
			if m_waitrequest = '1' then -- READ FROM MEM FIRST PART
				m_addr <= to_integer(unsigned(s_addr (12 downto 0)));
				m_read <= '1';
				m_write <= '0';
				next_state <= r_memwait;
			else
				next_state <= r_memread;
			end if;
			
		when r_memwait =>
			if count < 3 and m_waitrequest = '0' then -- READ FROM MEM SECOND PART
				count := 4;	
				m_read <= '0';
				next_state <= r_memwait;
			elsif count = 4 then -- PLACE DATA READ FROM MEM ONTO OUTPUT
				cache2(index)(127 downto 0)((Offset * 32) -1 downto 32* off) <= m_readdata;
				s_readdata <= m_readdata;
				cache2(index)(152 downto 127) <= s_addr (31 downto 6); --Tag
				cache2(index)(154) <= '1'; --Valid
				cache2(index)(153) <= '0'; --Clean
				m_read <= '0';
				m_write <= '0';
				s_waitrequest <= '0';
				count := 0;
				next_state <= start;
			else
				next_state <= r_memwait;
			end if;
		
		when w =>
			if cache2(index)(153) = '1' and next_state /= start and ( cache2(index)(154) /= '1' or cache2(index)(152 downto 127) /= s_addr (31 downto 6)) then --DIRTY AND MISS
				next_state <= w_memwrite;
			else
				cache2(index)(153) <= '1'; -- DIRTY	
				cache2(index)(154) <= '1'; --Valid
				cache2(index)(127 downto 0)((Offset * 32) -1 downto 32*off) <= s_writedata; --DATA
				cache2(index)(152 downto 127) <= s_addr (31 downto 6); --TAG
				s_waitrequest <= '0';
				next_state <= start;
					
				end if;
		
		when w_memwrite => 	
			if count < 4 and m_waitrequest = '1' then -- EVICT
				addr := cache2(index)(133 downto 127) & s_addr (5 downto 0);
				m_addr <= to_integer(unsigned (addr)) ;
				m_write <= '1';
				m_read <= '0';
				m_writedata <= cache2(index)(127 downto 0) ((Offset * 32) -1 downto 32*off);
				count := 4;
				next_state <= w_memwrite;
			elsif count = 4 then --WRITE TO CACHE AND SET CONTROL BITS
				cache2(index)(127 downto 0)((Offset * 32) -1 downto 32*off) <= s_writedata (31 downto 0); --DATA  
				cache2(index)(152 downto 127) <= s_addr (31 downto 6); --TAG
				cache2(index)(153) <= '1'; --DIRTY
				cache2(index)(154) <= '1'; --Valid
				count := 0;
				s_waitrequest <= '0';
				m_write <= '0';
				next_state <=start;
			else
				m_write <= '0';
				next_state <= w_memwrite;
			end if;
	end case;
end process;


end arch;
