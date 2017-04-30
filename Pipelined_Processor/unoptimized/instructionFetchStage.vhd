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
	
	-- UNIFIED CACHE OUTPUT
	pcOutput : out Integer range 0 to 1024-1;
	readOutput : out std_logic;
	memoryValue : in std_logic_vector(31 downto 0);
	writeOutput : out std_logic;
	writeDataOutput : out std_logic_vector(31 downto 0);
	waitRequestInput : in std_logic
	
	);

END instructionFetchStage;

architecture instructionFetchStage_arch of instructionFetchStage is

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
    signal address: INTEGER RANGE 0 TO 1024-1;
    
	signal memwrite: STD_LOGIC := '0';
    signal memread: STD_LOGIC := '1';
    signal readdata: STD_LOGIC_VECTOR (31 DOWNTO 0);
	
	signal pcOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal internal_selectOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal addOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
		
	--SIGNAL FOR STALLS 
	signal stallValue : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000100000";
	--signal memoryValue : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal pcInput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
begin

selectOutput <= internal_selectOutput;
--address <= to_integer(unsigned(addOutput(9 downto 0)))/4;

pcCounter : pc 
port map(
	clk => clk,
	reset => rst,
	counterOutput => pcOut,
	counterInput => pcInput
);

add : adder
port map(
	 
	 plusFour => four,
	 counterOutput => pcOut,
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
input1 => pcOut,
selectInput => pcStall,
selectOutput => pcInput
);

process (waitRequestInput,clk)
begin
	
	if (waitRequestInput'event and waitRequestInput = '1') then
		memread <= '0';
	end if;

	if (clk'event and clk = '1') then
		memread <= '1';
	end if;
	
end process;

-- UNIFIED CACHE MODIFICATION
readOutput <= memread;
writeOutput <= memwrite;
writeDataOutput <= writedata;
pcOutput <= to_integer(unsigned(pcOut(9 downto 0)))/4;
	
end instructionFetchStage_arch;