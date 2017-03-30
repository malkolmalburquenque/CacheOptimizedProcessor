library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity alu is
 Port ( input_a : in STD_LOGIC_VECTOR (31 downto 0);
 input_b : in STD_LOGIC_VECTOR (31 downto 0);
 SEL : in STD_LOGIC_VECTOR (4 downto 0);
 out_alu : out STD_LOGIC_VECTOR(31 downto 0));
end alu;
 
architecture Behavioral of alu is

signal shift, hi, lo, mul_result, div_result, div_rem  : std_logic_vector (31 downto 0);

begin
process(input_a, input_b, SEL) 	
variable hilo_buffer : std_logic_vector(63 downto 0);
begin
case SEL is
 
 when "00000" =>
 out_alu<= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) +   to_integer (unsigned(input_b)), out_alu'length)) ; --ADD
 
 when "00001" => 
 out_alu<= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) -   to_integer (unsigned(input_b)), out_alu'length)); --SUB 
 
 when "00010" => 
  out_alu<= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) +   to_integer (unsigned(input_b)), out_alu'length)) ; --ADDI
 
 when "00011" => 
 mul_result<= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) *   to_integer (unsigned(input_b)), out_alu'length)); --MULT
 hilo_buffer := std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) *   to_integer (unsigned(input_b)), 64));
 hi<= hilo_buffer(63 downto 32);
 lo<= hilo_buffer(31 downto 0);
 out_alu<= mul_result;
 
 when "00100" =>  
 div_result <= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) /   to_integer (unsigned(input_b)), div_result'length));   --DIV
 div_rem <= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) mod to_integer (unsigned(input_b)), div_rem'length));
 lo <= div_result;
 hi <= div_rem;
 out_alu <= div_result;

 when "00101" =>  
 if (unsigned(input_a) < unsigned(input_b)) then  --SLT
	out_alu <= x"00000001";
	else
	out_alu <= x"00000000";
 end if;
 
 when "00110" => 
  if (unsigned(input_a) < unsigned(input_b)) then  --SLTI
	out_alu <= x"00000001";
	else
	out_alu <= x"00000000";
 end if;
 
 when "00111" => 
 out_alu<= input_a and input_b; --AND

 when "01000" =>
 out_alu<= input_a or input_b; --OR

 when "01001" => 
 out_alu<= input_a nor input_b; --NOR
 
 when "01010" =>
 out_alu<= input_a xor input_b; --XOR 

 when "01011" =>
 out_alu<= input_a and input_b; --ANDI
 
 when "01100" =>
 out_alu<= input_a or input_b; --ORI

 when "01101" => 
 out_alu<= input_a xor input_b; --xORI
 
 when "01110" => --MOVE FROM HIGH
 out_alu<= hi;

 when "01111" => -- MOVE FROM LOW
 out_alu<= lo;
 
 when "10000" => -- LUI
	out_alu <= input_b (15 downto 0)  & std_logic_vector(to_unsigned(0, 16));
 
 when "10001" => --sll
	out_alu <= input_a ((31 - to_integer(unsigned(input_b(10 downto 6)))) downto 0)  & std_logic_vector(to_unsigned(0, to_integer(unsigned(input_b(10 downto 6)))));

 
 when "10010" => --srl
	out_alu <= std_logic_vector(to_unsigned(0, to_integer(unsigned(input_b(10 downto 6))))) & input_a (31 downto (0 + to_integer(unsigned(input_b(10 downto 6)))));
	
 when "10011" => -- sra
	if input_a(31) = '0' then
		out_alu <= std_logic_vector(to_unsigned(0, to_integer(unsigned(input_b(10 downto 6))))) & input_a (31 downto (0 + to_integer(unsigned(input_b(10 downto 6)))));
	else
		out_alu <= std_logic_vector(to_unsigned(1, to_integer(unsigned(input_b(10 downto 6))))) & input_a (31 downto (0 + to_integer(unsigned(input_b(10 downto 6)))));
	end if;	
 
 when "10100" => -- lw
 out_alu<= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) +   to_integer (unsigned(input_b)), out_alu'length)) ; 
 when "10101" => -- sw
	out_alu<= std_logic_vector(to_unsigned(to_integer (unsigned(input_a)) +   to_integer (unsigned(input_b)), out_alu'length)) ; 
 
 when "10110" => -- beq
 out_alu<= std_logic_vector(to_unsigned((to_integer (unsigned(input_a)) +   to_integer (unsigned(input_b)) * 4), out_alu'length));
 
 when "10111" => -- bne
 out_alu<= std_logic_vector(to_unsigned((to_integer (unsigned(input_a)) +   to_integer (unsigned(input_b)) * 4), out_alu'length));
 
 when "11000" => -- j ASSUME input b is lower 26 bits 0 padded
	out_alu<= input_a(31 downto 28) & input_b(25 downto 0) & "00";
 when "11001" => -- jr
	out_alu <= input_a;
 when "11010" => -- jal
	out_alu<= input_a(31 downto 28) & input_b(25 downto 0) & "00";
 when others =>
  NULL;
end case; 
  
end process; 
 
end Behavioral;