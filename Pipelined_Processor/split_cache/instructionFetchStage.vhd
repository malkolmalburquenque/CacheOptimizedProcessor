LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY instructionFetchStage IS

port(
	clk : in std_logic;
	globalClk : in std_logic;
	muxInput0 : in std_logic_vector(31 downto 0);
	selectInputs : in std_logic;
	four : in INTEGER;
	structuralStall : IN STD_LOGIC := '0';
	pcStall : IN STD_LOGIC := '0';
	
	selectOutput : out std_logic_vector(31 downto 0);
	instructionMemoryOutput : out std_logic_vector(31 downto 0);
	
	waitrequest: out std_logic;
	
	-- CACHE port 
	Caddr : out integer range 0 to 1024-1;
	Cread : out std_logic;
	Creaddata : in std_logic_vector (31 downto 0);
	Cwrite : out std_logic;
	Cwritedata : out std_logic_vector (31 downto 0);
	Cwaitrequest : in std_logic
	
	
	);

END instructionFetchStage;

architecture instructionFetchStage_arch of instructionFetchStage is

--CACHE 

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

--PC 

component pc is
port(clk : in std_logic;
	 reset : in std_logic;
	 counterOutput : out std_logic_vector(31 downto 0);
	 counterInput : in std_logic_vector(31 downto 0)
	 );
end component;

--MUX 

component mux is
port(
	 input0 : in std_logic_vector(31 downto 0);
	 input1 : in std_logic_vector(31 downto 0);
	 selectInput : in std_logic;
	 selectOutput : out std_logic_vector(31 downto 0)
	 );
	 
end component;

--ADDER 

component adder is
port(
	 plusFour : in integer;
	 counterOutput : in std_logic_vector(31 downto 0);
	 adderOutput : out std_logic_vector(31 downto 0)
	 );
end component;

-- SET SIGNALS 
	signal rst : std_logic := '0';
    signal writedata: std_logic_vector(31 downto 0);
    signal address: INTEGER;
    
	signal memwrite: STD_LOGIC := '0';
    signal memread: STD_LOGIC;
    signal readdata: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal waitrequestSig: STD_LOGIC;
	
	signal pcOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal internal_selectOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal addOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
		
	--SIGNAL FOR STALLS 
	signal stallValue : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000100000";
	signal memoryValue : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal pcInput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
begin

selectOutput <= internal_selectOutput;
--address <= to_integer(unsigned(addOutput(9 downto 0)))/4;


pcCounter : pc 
port map(
	clk => clk,
	reset => rst,
	counterOutput => pcOutput,
	counterInput => pcInput
);

add : adder
port map(
	 
	 plusFour => four,
	 counterOutput => pcOutput,
	 adderOutput => addOutput
);

fetchMux : mux 
port map(
	 input0 => addOutput,
	 input1 => muxInput0,
	 selectInput => selectInputs,
	 selectOutput => internal_selectOutput
	 );
	 
structuralMux : mux 
port map (
input0 => memoryValue,
input1 => stallValue,
selectInput => structuralStall,
selectOutput => instructionMemoryOutput
);

pcMux : mux 
port map (
input0 => internal_selectOutput,
input1 => pcOutput,
selectInput => pcStall,
selectOutput => pcInput
);

memCache : cache
port map(
	clock => globalClk,
	reset => rst,

	s_addr => pcOutput,
	s_read => memread,
	s_readdata => memoryValue,
	s_write => memwrite,
	s_writedata => writedata,
	s_waitrequest => waitrequestSig,

	m_addr =>address,
	m_read =>cread,
	m_readdata => creaddata,
	m_write => cwrite,
	m_writedata => cwritedata,
	m_waitrequest => cwaitrequest
);

process (waitrequestSig,clk)
begin
	
	if (waitrequestSig'event and waitrequestSig = '1') then
		memread <= '0';
	end if;

	if (clk'event and clk = '1') then
		memread <= '1';
	end if;
	
end process;

process (address)
begin
	if address >= 1024 then
		caddr <= 0;
	else
		caddr <= address;
	end if;
end process;

waitrequest <= waitrequestSig;
	
end instructionFetchStage_arch;