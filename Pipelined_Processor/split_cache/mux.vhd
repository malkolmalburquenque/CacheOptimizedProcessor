library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
port(
	 input0 : in std_logic_vector(31 downto 0);
	 input1 : in std_logic_vector(31 downto 0);
	 selectInput : in std_logic;
	 selectOutput : out std_logic_vector(31 downto 0)
	 );
	 
end mux;

architecture mux_arch of mux is

begin

	selectOutput <= input1 when (selectInput = '1') else input0 ;
	
end mux_arch;
