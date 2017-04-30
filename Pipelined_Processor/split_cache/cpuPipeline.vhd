library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpuPipeline is
port 
(
clk : in std_logic;
reset : in std_logic;
four : INTEGER;
writeToRegisterFile : in std_logic := '0';
writeToMemoryFile : in std_logic := '0'

);

end cpuPipeline;

architecture cpuPipeline_arch of cpuPipeline is

component instructionFetchStage IS
	port(
		clk : in std_logic;
		globalClk : in std_logic;
		muxInput0 : in std_logic_vector(31 downto 0);
		selectInputs : in std_logic;
		four : in INTEGER;
		structuralStall : IN STD_LOGIC;
		pcStall : IN STD_LOGIC;

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
		
	end component;
		
component controller is
	port(clk : in std_logic;
		 opcode : in std_logic_vector(5 downto 0);
		 funct : in std_logic_vector(5 downto 0);
		 branch: in std_logic;
		 oldBranch: in std_logic;
		 ALU1src : out STD_LOGIC;
		 ALU2src : out STD_LOGIC;
		 MemRead : out STD_LOGIC;
		 MemWrite : out STD_LOGIC;
		 RegWrite : out STD_LOGIC;
		 MemToReg : out STD_LOGIC;
		 RType : out std_logic;
		 JType : out std_logic;
		 Shift : out std_logic;
		 structuralStall : out std_logic;
		 ALUOp : out STD_LOGIC_VECTOR(4 downto 0)
		 );
end component;

component register_file is

PORT(
		
		clock: IN STD_LOGIC;
		rs: IN STD_LOGIC_VECTOR (4 downto 0);
		rt: IN STD_LOGIC_VECTOR (4 downto 0);
		write_enable: IN STD_LOGIC; 
		rd: IN STD_LOGIC_VECTOR (4 downto 0);
		rd_data: IN STD_LOGIC_VECTOR (31 downto 0); 
		writeToText : IN STD_LOGIC := '0';

		ra_data: OUT STD_LOGIC_VECTOR (31 downto 0);
		rb_data: OUT STD_LOGIC_VECTOR (31 downto 0) 
	);

end component;


component signextender is 
	PORT (
        immediate_in: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        immediate_out: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
end component;
	
component mux is
port(
	 input0 : in std_logic_vector(31 downto 0);
	 input1 : in std_logic_vector(31 downto 0);
	 selectInput : in std_logic;
	 selectOutput : out std_logic_vector(31 downto 0)
	 );
	 	
	
end component;

component alu is
 Port ( input_a : in STD_LOGIC_VECTOR (31 downto 0);
 input_b : in STD_LOGIC_VECTOR (31 downto 0);
 SEL : in STD_LOGIC_VECTOR (4 downto 0);
 out_alu : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component zero is
port (input_a : in std_logic_vector (31 downto 0);
	input_b : in std_logic_vector (31 downto 0);
	optype : in std_logic_vector (4 downto 0);
	result: out std_logic
  );
end component;

--MEMORY OBJ FOR MEM STAGE
COMPONENT newMemory IS
	GENERIC(
		ram_size : INTEGER := 8192;
		mem_delay : time := 20 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO ram_size-1;
		memwrite: IN STD_LOGIC := '0';
		memread: IN STD_LOGIC := '0';
		writeToText : IN STD_LOGIC := '0';
		
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
END COMPONENT;

--MEM STAGE
component mem is  
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
	address: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	memwrite: OUT STD_LOGIC := '0';
	memread: OUT STD_LOGIC := '0';
	readdata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	cpuStall : IN STD_LOGIC ;
	waitrequest: IN STD_LOGIC
	
  );
end component;
 
component wb is
port (ctrl_memtoreg_in: in std_logic;
	ctrl_regwrite_in: in std_logic;
	ctrl_regwrite_out: out std_logic;
	
	alu_in : in std_logic_vector (31 downto 0);
	mem_in: in std_logic_vector (31 downto 0);
	mux_out : out std_logic_vector (31 downto 0);
	write_addr_in: in std_logic_vector (4 downto 0);
	write_addr_out: out std_logic_vector (4 downto 0)
);
 end component;
 
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


 -- CLOCK SIGNAL 
signal clock : std_logic := clk;
 
 -- STALL SIGNALS 
signal IDEXStructuralStall : std_logic;
signal EXMEMStructuralStall : std_logic;
signal structuralStall : std_logic;
signal pcStall : std_logic;
signal cpuStall : std_logic := '0';
signal stopStall : std_logic_vector (1 downto 0) := "00";

-- TEST SIGNALS 
signal muxInput : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
signal selectInput : std_logic := '1';
signal fourInt : INTEGER := 4;
signal IFwaitrequest: std_logic;

-- PIPELINE IFID
--address goes to both IFID and IDEX
signal address : std_logic_vector(31 downto 0);
signal instruction : std_logic_vector(31 downto 0);
signal IFIDaddress : std_logic_vector(31 downto 0);
signal IFIDinstruction : std_logic_vector(31 downto 0);

--PIPELINE IDEX

signal IDEXaddress : std_logic_vector(31 downto 0);
signal IDEXra : std_logic_vector(31 downto 0);
signal IDEXrb : std_logic_vector(31 downto 0);
signal IDEXimmediate : std_logic_vector(31 downto 0);
signal IDEXrd : std_logic_vector (4 downto 0);
signal IDEXALU1srcO, IDEXALU2srcO, IDEXMemReadO, IDEXMeMWriteO, IDEXRegWriteO, IDEXMemToRegO: std_logic;
signal IDEXAluOp : std_logic_vector (4 downto 0);


-- SIGNALS FOR CONTROLLER
signal opcodeInput,functInput : std_logic_vector(5 downto 0);
signal ALU1srcO,ALU2srcO,MemReadO,MemWriteO,RegWriteO,MemToRegO,RType,Jtype,Shift: std_logic;
signal ALUOp : std_logic_vector(4 downto 0);

-- SIGNALS FOR REGISTERS
signal rs,rt,rd,WBrd : std_logic_vector (4 downto 0);
signal rd_data: std_logic_vector(31 downto 0);
signal write_enable : std_logic;
signal ra,rb : std_logic_vector(31 downto 0);
signal shamnt : std_logic_vector(4 downto 0);

signal immediate : std_logic_vector(15 downto 0); 
signal immediate_out : std_logic_vector(31 downto 0);

-- SIGNALS FOR EXECUTE STAGE  
signal muxOutput1 : std_logic_vector(31 downto 0);
signal muxOutput2 : std_logic_vector(31 downto 0);
signal aluOutput : std_logic_vector(31 downto 0);
signal zeroOutput : std_logic;

-- SIGNALS FOR EXMEM
signal EXMEMBranch : std_logic; -- need the zero variable 
signal ctrl_jal : std_logic;
signal EXMEMaluOutput : std_logic_vector(31 downto 0);
signal EXMEMregisterOutput : std_logic_vector(31 downto 0);
signal EXMEMrd : std_logic_vector(4 downto 0);
signal EXMEMMemReadO, EXMEMMeMWriteO, EXMEMRegWriteO, EXMEMMemToRegO: std_logic;

-- MEM SIGNALS 
signal MEMWBmemOutput : std_logic_vector(31 downto 0);
signal MEMWBaluOutput : std_logic_vector(31 downto 0);
signal MEMWBrd : std_logic_vector(4 downto 0);
signal memtoReg : std_logic;
signal regWrite : std_logic;

signal	MEMwritedata : std_logic_vector(31 downto 0);
signal	MEMaddress : std_logic_vector(31 downto 0);
signal	MEMmemwrite : STD_LOGIC;
signal	MEMmemread  : STD_LOGIC;
signal	MEMreaddata : std_logic_vector(31 downto 0);
signal	MEMwaitrequest : STD_LOGIC;

--SIGNALS FOR CACHE
signal m_addr_data : integer range 0 to 8192-1;
signal m_read_data : std_logic;
signal m_readdata_data : std_logic_vector (31 downto 0);
signal m_write_data : std_logic;
signal m_writedata_data : std_logic_vector (31 downto 0);
signal m_waitrequest_data : std_logic;
       
signal m_addr_instruct : integer range 0 to 1024-1;
signal m_read_instruct : std_logic;
signal m_readdata_instruct : std_logic_vector (31 downto 0);
signal m_write_instruct : std_logic;
signal m_writedata_instruct : std_logic_vector (31 downto 0);
signal m_waitrequest_instruct : std_logic;

signal m_addr : integer range 0 to 8192-1;
signal m_read : std_logic;
signal m_readdata : std_logic_vector (31 downto 0);
signal m_write : std_logic;
signal m_writedata : std_logic_vector (31 downto 0);
signal m_waitrequest : std_logic; 

signal m_writeToText : std_logic := '0';


begin

IFS : instructionFetchStage
port map(
	clk => clock,
	globalClk => clk,
	muxInput0 => EXMEMaluOutput,
	selectInputs => EXMEMBranch,
	four => fourInt,
	structuralStall => structuralStall,
	pcStall => pcStall,
	selectOutput => address,
	instructionMemoryOutput => instruction,
	
	waitrequest => IFwaitrequest,
				-- CACHE port 
	Caddr => m_addr_instruct,
	Cread => m_read_instruct,
	Creaddata => m_readdata_instruct,
	Cwrite => m_write_instruct,
	Cwritedata => m_writedata_instruct,
	Cwaitrequest => m_waitrequest_instruct
	
);
-- DECODE STAGE 
CT : controller 
port map(
	clk => clock,
	opcode => opcodeInput, 
	funct => functInput,
	branch => zeroOutput,
	oldBranch => EXMEMBranch,
	ALU1src => ALU1srcO,
	ALU2src => ALU2srcO,
	MemRead => MemReadO,
	MemWrite => MemWriteO,
	RegWrite => RegWriteO,
	MemToReg => MemToRegO,
	structuralStall => IDEXStructuralStall,
	ALUOp => ALUOp,
	Shift => Shift,
	RType => RType,
	JType => JType
	
);

RegisterFile : register_file
port map (
	clock => clock,
	rs => rs,
	rt => rt,
	write_enable => write_enable,
	rd => WBrd,
	rd_data => rd_data,
	writeToText => writeToRegisterFile,
	ra_data => ra,
	rb_data => rb
);

se : signextender
port map(
immediate_in => immediate,
immediate_out => immediate_out
);

-- EXECUTE STAGE 
exMux1 : mux 
port map (
input0 => IDEXra,
input1 => IDEXaddress,
selectInput => IDEXALU1srcO,
selectOutput => muxOutput1
);

exMux2 : mux 
port map (
input0 => IDEXimmediate,
input1 => IDEXrb,
selectInput => IDEXALU2srcO,
selectOutput => muxOutput2
);

operator : alu 
port map( 
input_a => muxOutput1,
input_b => muxOutput2,
SEL => IDEXAluOp,
out_alu => aluOutput
);

zr : zero 
port map (
input_a => IDEXra,
input_b => IDEXrb, 
optype => IDEXAluOp,  
result => zeroOutput
);

memStage : mem
port map (
	clk =>clock,
	-- Control lines
	ctrl_write => EXMEMMemWriteO,
	ctrl_read => EXMEMMemReadO,
	ctrl_memtoreg_in => EXMEMMemToRegO,
	ctrl_memtoreg_out => memtoReg,
	ctrl_regwrite_in => EXMEMRegWriteO,
	ctrl_regwrite_out => regWrite,
	ctrl_jal => ctrl_jal,

	--Ports of stage
	alu_in => EXMEMaluOutput,
	alu_out=>  MEMWBaluOutput,
	mem_data_in => EXMEMregisterOutput,
	mem_data_out => MEMWBmemOutput, 
	write_addr_in => EXMEMrd,
	write_addr_out => MEMWBrd,
	
	--Memory signals
	writedata => MEMwritedata,
	address => MEMaddress,
	memwrite => MEMmemwrite,
	memread  => MEMmemread,
	readdata => MEMreaddata,
	cpuStall => cpuStall,
	waitrequest => MEMwaitrequest
);

data: cache
port map(
    clock => clk,
    reset => reset,

    s_addr => MEMaddress,
    s_read => MEMmemread,
    s_readdata => MEMreaddata,
    s_write => MEMmemwrite,
    s_writedata => MEMwritedata,
    s_waitrequest => MEMwaitrequest,

    m_addr => m_addr_data,
    m_read => m_read_data,
    m_readdata => m_readdata_data,
    m_write => m_write_data,
    m_writedata => m_writedata_data,
    m_waitrequest => m_waitrequest_data
);

newMem : newMemory
port map (
    clock => clk,
    writedata => m_writedata,
    address => m_addr,
    memwrite => m_write,
    memread => m_read,
    writeToText => writeToMemoryFile,
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


wbStage: wb
port map (ctrl_memtoreg_in => memtoReg,
	ctrl_regwrite_in => regWrite,
	ctrl_regwrite_out => write_enable,
	
	alu_in  => MEMWBaluOutput,
	mem_in => MEMWBmemOutput,
	mux_out  => rd_data,
	write_addr_in => MEMWBrd,
	write_addr_out => WBrd
);


process(clk)
begin
if (cpuStall = '0') then
clock <= clk;
else
clock <= '0';
end if;
end process;

process (IFwaitrequest, MEMwaitrequest, EXMEMMemWriteO ,EXMEMMemReadO,clock)
begin
	if cpuStall = '1' then
		if (IFwaitrequest'event and IFwaitrequest = '1') then
			if (stopStall = "10") then
				cpuStall <= '0';
				stopStall <= "00";
			else
				stopStall <= "01";
			end if;
		end if;
		if (EXMEMMemWriteO = '1' or EXMEMMemReadO = '1')then
			if (EXMEMMemWriteO'event or EXMEMMemReadO'event) then
				stopStall (1) <= '0';
			end if;
			if MEMwaitrequest'event and MEMwaitrequest = '1' then
				if (stopStall = "01") then
					cpuStall <= '0';
					stopStall <= "00";
				else
					stopStall <= "10";
				end if;
			end if;
		else
			if (stopStall = "01") then
				cpuStall <= '0';
				stopStall <= "00";
			else
				stopStall <= "10";
			end if;
		end if;
	else
		cpuStall <= '1';
	end if;
end process;	
		

process(EXMEMStructuralStall)
begin
if EXMEMStructuralStall = '1' then 
	pcStall <= '1';
else 
	pcStall <= '0';
end if;

end process;

process (clock)
begin

if (clock'event and clock = '1') then
--PIPELINED VALUE 
--IFID 
IFIDaddress <= address;
IFIDinstruction <= instruction;

-- IDEX
IDEXaddress <= IFIDaddress;
IDEXrb <= rb;

--FOR IMMEDIATE VALUES
if RType = '1' then
	IDEXrd <= rd;
-- FOR JAL
elsif ALUOP = "11010" then
	IDEXrd <= "11111";
else
	IDEXrd <= rt;
end if;

--FOR SHIFT INSTRUCTIONS
if Shift = '1' then
	IDEXra <= rb;
else
	IDEXra <= ra;
end if;

--FOR JUMP INSTRUCTIONS
if JType = '1' then
	IDEXimmediate <= "000000" & IFIDinstruction(25 downto 0);
else
	IDEXimmediate <= immediate_out;
end if;

IDEXALU1srcO <= ALU1srcO;
IDEXALU2srcO <= ALU2srcO;
IDEXMemReadO <= MemReadO;
IDEXMeMWriteO <= MemWriteO;
IDEXRegWriteO <= RegWriteO;
IDEXMemToRegO <= MemToRegO;
IDEXAluOp <= ALUOp;

	
--EXMEM 
EXMEMBranch <= zeroOutput; 
EXMEMrd <= IDEXrd;
EXMEMMemReadO <= IDEXMemReadO;
EXMEMMeMWriteO <= IDEXMeMWriteO;
EXMEMRegWriteO <= IDEXRegWriteO;
EXMEMMemToRegO <= IDEXMemToRegO;
EXMEMaluOutput <= aluOutput;
EXMEMStructuralStall <= IDEXStructuralStall;
structuralStall <= EXMEMStructuralStall;
--FOR JAL
if IDEXAluOp = "11010" then
	EXMEMregisterOutput <= IDEXaddress;
	ctrl_jal <= '1';
else
	EXMEMregisterOutput <= IDEXrb;
	ctrl_jal <= '0';
end if;
	
end if ;
end process;

-- controller values
opcodeInput <= IFIDinstruction(31 downto 26);
functInput <= IFIDinstruction(5 downto 0);
-- register values
rs <= IFIDinstruction(25 downto 21);
rt <= IFIDinstruction(20 downto 16);
rd <= IFIDinstruction(15 downto 11);
shamnt <= IFIDinstruction(10 downto 6);
-- EXTENDED
immediate <= IFIDinstruction(15 downto 0);
-- MIGHT NEED TO PUT WRITE ENABLE HERE LATER 
-- AND JUMP ADDRESS HERE 

end cpuPipeline_arch;