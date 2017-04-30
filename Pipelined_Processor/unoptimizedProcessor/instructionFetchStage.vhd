LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY instructionFetchStage IS

--MIGHT NEED TO MODIFY IF STAGE TO THE WHOLE CPU PIPELINE

port(
	clk : in std_logic;
	muxInput0 : in std_logic_vector(31 downto 0);
	selectInputs : in std_logic;
	four : in INTEGER;
	structuralStall : IN STD_LOGIC := '0';
	pcStall : IN STD_LOGIC := '0';
	
	selectOutput : out std_logic_vector(31 downto 0);
	instructionMemoryOutput : out std_logic_vector(31 downto 0)
	);

END instructionFetchStage;

architecture instructionFetchStage_arch of instructionFetchStage is

--INSTRUCTION MEMORY 
component instructionMemory IS
	GENERIC(
	-- might need to change it 
		ram_size : INTEGER := 1024;
		mem_delay : time := 1 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO ram_size-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
END component;

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
    signal waitrequest: STD_LOGIC;
	
	
	signal pcOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal internal_selectOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal addOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
		
	--SIGNAL FOR STALLS 
	signal stallValue : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000100000";
	signal memoryValue : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal pcInput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
begin

selectOutput <= internal_selectOutput;
address <= to_integer(unsigned(addOutput(9 downto 0)))/4;


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
	 
iMem : instructionMemory
	GENERIC MAP(
            ram_size => 1024
                )
                PORT MAP(
                    clk,
                    writedata,
                    address,
                    memwrite,
                    memread,
                    memoryValue,
                    waitrequest
                );
				
	
				
end instructionFetchStage_arch;