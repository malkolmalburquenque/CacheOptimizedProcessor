library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache_tb is
end cache_tb;

architecture behaviour of cache_tb is

	component cache is
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
	end component;
	
	component arbiter is
		generic(
			ram_size : INTEGER := 8192
		);
		port(
			-- Avalon interface --
			s_addr_data : in integer range 0 to ram_size-1;
			s_read_data : in std_logic;
			s_readdata_data : out std_logic_vector (31 downto 0);
			s_write_data : in std_logic;
			s_writedata_data : in std_logic_vector (31 downto 0);
			s_waitrequest_data : out std_logic;
			
			s_addr_instruct : in integer range 0 to ram_size-1;
			s_read_instruct : in std_logic;
			s_readdata_instruct : out std_logic_vector (31 downto 0);
			s_write_instruct : in std_logic;
			s_writedata_instruct : in std_logic_vector (31 downto 0);
			s_waitrequest_instruct : out std_logic;
			
			m_addr : out integer range 0 to ram_size-1;
			m_read : out std_logic;
			m_readdata : in std_logic_vector (31 downto 0);
			m_write : out std_logic;
			m_writedata : out std_logic_vector (31 downto 0);
			m_waitrequest : in std_logic
		);
	end component;

component memory is 
GENERIC(
    ram_size : INTEGER := 8192;
    mem_delay : time := 10 ns;
    clock_period : time := 1 ns
);
PORT (
    clock: IN STD_LOGIC;
    writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    address: IN INTEGER RANGE 0 TO ram_size-1;
    memwrite: IN STD_LOGIC;
    memread: IN STD_LOGIC;
	writeToText : IN STD_LOGIC;
	
    readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    waitrequest: OUT STD_LOGIC
);
end component;
	
-- test signals 
signal reset : std_logic := '0';
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;
constant ram_size : INTEGER := 8192;

signal s_addr_data : std_logic_vector (31 downto 0);
signal s_read_data : std_logic;
signal s_readdata_data : std_logic_vector (31 downto 0);
signal s_write_data : std_logic;
signal s_writedata_data : std_logic_vector (31 downto 0);
signal s_waitrequest_data : std_logic;

signal s_addr_instruct : std_logic_vector (31 downto 0);
signal s_read_instruct : std_logic;
signal s_readdata_instruct : std_logic_vector (31 downto 0);
signal s_write_instruct : std_logic;
signal s_writedata_instruct : std_logic_vector (31 downto 0);
signal s_waitrequest_instruct : std_logic;

signal m_addr_data : integer range 0 to ram_size-1;
signal m_read_data : std_logic;
signal m_readdata_data : std_logic_vector (31 downto 0);
signal m_write_data : std_logic;
signal m_writedata_data : std_logic_vector (31 downto 0);
signal m_waitrequest_data : std_logic;
       
signal m_addr_instruct : integer range 0 to ram_size-1;
signal m_read_instruct : std_logic;
signal m_readdata_instruct : std_logic_vector (31 downto 0);
signal m_write_instruct : std_logic;
signal m_writedata_instruct : std_logic_vector (31 downto 0);
signal m_waitrequest_instruct : std_logic;

signal m_addr : integer range 0 to ram_size-1;
signal m_read : std_logic;
signal m_readdata : std_logic_vector (31 downto 0);
signal m_write : std_logic;
signal m_writedata : std_logic_vector (31 downto 0);
signal m_waitrequest : std_logic; 

signal m_writeToText : std_logic := '0';

begin

-- Connect the components which we instantiated above to their
-- respective signals.
instruct: cache 
port map(
    clock => clk,
    reset => reset,

    s_addr => s_addr_instruct,
    s_read => s_read_instruct,
    s_readdata => s_readdata_instruct,
    s_write => s_write_instruct,
    s_writedata => s_writedata_instruct,
    s_waitrequest => s_waitrequest_instruct,

    m_addr => m_addr_instruct,
    m_read => m_read_instruct,
    m_readdata => m_readdata_instruct,
    m_write => m_write_instruct,
    m_writedata => m_writedata_instruct,
    m_waitrequest => m_waitrequest_instruct
);

data: cache
port map(
    clock => clk,
    reset => reset,

    s_addr => s_addr_data,
    s_read => s_read_data,
    s_readdata => s_readdata_data,
    s_write => s_write_data,
    s_writedata => s_writedata_data,
    s_waitrequest => s_waitrequest_data,

    m_addr => m_addr_data,
    m_read => m_read_data,
    m_readdata => m_readdata_data,
    m_write => m_write_data,
    m_writedata => m_writedata_data,
    m_waitrequest => m_waitrequest_data
);


MEM : memory
port map (
    clock => clk,
    writedata => m_writedata,
    address => m_addr,
    memwrite => m_write,
    memread => m_read,
    writeToText => m_writeToText,
	readdata => m_readdata,
    waitrequest => m_waitrequest
);

arb: arbiter
port map (
	s_addr_data => m_addr_data, 
	s_read_data => m_read_data,
	s_readdata_data => m_readdata_data,
	s_write_data => m_write_data, 
	s_writedata_data => m_writedata_data,
	s_waitrequest_data => m_waitrequest_data,
	
	s_addr_instruct => m_addr_instruct, 
	s_read_instruct => m_read_instruct,
	s_readdata_instruct => m_readdata_instruct,
	s_write_instruct => m_write_instruct, 
	s_writedata_instruct => m_writedata_instruct,
	s_waitrequest_instruct => m_waitrequest_instruct,

	m_addr => m_addr,
	m_read => m_read,
	m_readdata => m_readdata,
	m_write => m_write,
	m_writedata => m_writedata,
	m_waitrequest => m_waitrequest
);
				

clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;

test_process : process                                                 
begin                                                                  
                        
                   
	WAIT FOR clk_period;                                           
	-- Attempt to write to cache                                     	
	
	
	s_writedata_data <= x"0000ff01";
	s_addr_data <= "11111111111111111111111111111111";  
	s_read_data <= '0';                                                       
	s_write_data <= '1'; 
	
	wait until rising_edge(s_waitrequest_data);
	-- INVALID  - WRITE MISS CLEAN and  VALID - READ HIT (CLEAN/DIRTY)  
	s_addr_data <= "11111111111111111111111101111111"; 
	s_addr_instruct <= "11111111111111111111111001111001"; 
	s_writedata_data <= x"0000ff00";
                           
	s_read_data <= '0';                                                       
	s_write_data <= '1'; 
	s_read_instruct <= '1';                                                       
	s_write_instruct <= '0'; 	
	
	wait until (rising_edge(s_waitrequest_data) or rising_edge(s_waitrequest_instruct));
	
	if rising_edge(s_waitrequest_data) then
	s_read_data <= '0';                                                       
	s_write_data <= '0';     
	end if;
	
	wait until (rising_edge(s_waitrequest_data) or rising_edge(s_waitrequest_instruct));
	
	if rising_edge(s_waitrequest_data) then
	s_read_data <= '0';                                                       
	s_write_data <= '0';     
	end if;
	
	wait for clk_period;
	

	wait;
	
end process;
	
end;