library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc is
port(clk : in std_logic;
	 reset : in std_logic;
	 counterOutput : out std_logic_vector(31 downto 0);
	 counterInput : in std_logic_vector(31 downto 0) := x"00000000"
	 );
end pc;

architecture pc_arch of pc is

signal test :std_logic ; 
begin


process (clk,reset)
begin
	
	if (reset = '1') then
		counterOutput <= x"00000000";
	elsif (clk'event and clk = '1') then 	
		counterOutput <= counterInput;
		test <= '1';
	end if;
	
	
	end process;


	
end pc_arch;
