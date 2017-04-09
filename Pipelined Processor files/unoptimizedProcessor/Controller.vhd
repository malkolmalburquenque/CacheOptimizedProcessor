library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
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
	 RType: out STD_LOGIC;
	 JType: out STD_LOGIC;
	 Shift: out STD_LOGIC;
	 structuralStall : out STD_LOGIC;
	 ALUOp : out STD_LOGIC_VECTOR(4 downto 0)
	 );
end controller;

architecture controller_arch of controller is

begin

process (opcode,funct)
begin
	
	--Send empty ctrl insturctions 
	if (branch = '1') or (oldBranch = '1') then
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemToReg <= '0';
		ALUOp <= "00000";
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
	else
	
	
	
		case opcode is
		-- SLL   PADED BY SIGN EXTEND TO DO   OUTPUT 17
		when "000000" =>
		if funct = "000000" then 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "10001";
		RType <= '1';
		Shift <= '1';
		JType <= '0';
		structuralStall <= '0';
		
		--SUB OUTPUT 1
		elsif funct  = "100010" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00001"; 
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--XOR OUTPUT 10
		elsif funct = "101000" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01010"; 
		RType <= '1';
		Shift <= '0';
		structuralStall <= '0';
		
		--AND OUTPUT 7
		elsif funct =  "100100" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00111"; 
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--ADD	OUTPUT 0
		elsif funct = "100000" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00000"; 
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--SLT OUTPUT 5
		elsif funct  = "101010" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00101"; 
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--SRL PADED BY SIGN EXTEND   OUTPUT 18
		elsif funct = "000010" then 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "10010";
		RType <= '1';
		Shift <= '1';
		JType <= '0';
		structuralStall <= '0';
		
			--OR OUTPUT 8
		elsif funct = "100101" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01000"; 
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
			--NOR OUTPUT 9
		elsif funct =  "100111" then 
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01001"; 
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--JUMP REGISTER OUTPUT 25
		elsif funct = "001000" then 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemToReg <= '0';
		ALUOp <= "11001";
		RType <= '1';
		Shift <= '0';
		JType <= '1';
		structuralStall <= '0';
		
		-- DIVIDING OUTPUT 4
		elsif funct = "011010" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00100";
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		-- MULT	OUTPUT 3
		elsif funct = "011000" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00011";
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--SRA OUTPUT 18
		elsif funct = "000011" then 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "10010";
		RType <= '1';
		JType <= '0';
		structuralStall <= '0';
		
		-- TO DO HIGH OUTPUT 14
		elsif funct = "001010" then
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01110";
		RType <= '1';
		Shift <= '1';
		JType <= '0';
		structuralStall <= '0';
		
		--TO DO LOW  OUTPUT 15
		elsif funct = "001100" then 
		ALU1src <= '0';
		ALU2src <= '1';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01111";
		RType <= '1';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		end if;
		
		--ADDI OUTPUT 2
		when "001000" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00010"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
			
		--SLTI OUTPUT 6
		when "001010" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "00110"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--ANDI OUTPUT 11
		when "001100" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01011"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--ORI OUTPUT 12
		
		when "001101" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01100"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--XORI OUTPUT 13
		
		when "001110" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "01101"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--LUI OUTPUT 16
		
		when "001111" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "10000"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';

		
		-- LW OUTPUT 20
		when "100011" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '1';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '1';
		ALUOp <= "10100"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '1';
		
		-- Store  OUTPUT 21
		
		when "101011" => 
		ALU1src <= '0';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '1';
		RegWrite <= '0';
		MemToReg <= '1';
		ALUOp <= "10101"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		-- BEQ	OUTPUT 22
		when "000100" => 
		ALU1src <= '1';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemToReg <= '0';
		ALUOp <= "10110"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		--BNE	OUTPUT 23
		
		when "000101" => 
		ALU1src <= '1';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemToReg <= '0';
		ALUOp <= "10111"; 
		RType <= '0';
		Shift <= '0';
		JType <= '0';
		structuralStall <= '0';
		
		-- JUMP OUTPUT 24 
		
		when "000010" => 
		ALU1src <= '1';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemToReg <= '0';
		ALUOp <= "11000";
		RType <= '0';
		Shift <= '0';
		JType <= '1';	
		structuralStall <= '0';
		
		-- JUMP AND LINK  OUTPUT 26
		when "000011" => 
		ALU1src <= '1';
		ALU2src <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemToReg <= '0';
		ALUOp <= "11010"; 
		RType <= '0';
		Shift <= '0';
		JType <= '1';
		structuralStall <= '0';
		
		when others =>
		
		end case;
	end if;
end process;
	
end controller_arch;
