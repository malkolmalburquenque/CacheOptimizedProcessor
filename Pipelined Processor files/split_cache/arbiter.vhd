--Data arbiter


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter is
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
	s_waitrequest_data : out std_logic:= '1';
	
	s_addr_instruct : in integer range 0 to ram_size-1;
	s_read_instruct : in std_logic;
	s_readdata_instruct : out std_logic_vector (31 downto 0);
	s_write_instruct : in std_logic;
	s_writedata_instruct : in std_logic_vector (31 downto 0);
	s_waitrequest_instruct : out std_logic:='1';

	m_addr : out integer range 0 to ram_size-1;
	m_read : out std_logic;
	m_readdata : in std_logic_vector (31 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (31 downto 0);
	m_waitrequest : in std_logic
);
end arbiter;
architecture arch of arbiter is

	signal control: std_logic;
	signal inUse: std_logic := '0';
begin
	
process (m_waitrequest)
begin
	if inUse = '1' then
		if control <= '0' then
			s_waitrequest_data <= m_waitrequest;
			s_waitrequest_instruct <= '1';
		elsif control <= '1' then
			s_waitrequest_instruct <= m_waitrequest;
			s_waitrequest_data <= '1';
		end if;
	end if;
end process;

process (s_write_data, s_write_instruct, s_read_data, s_read_instruct, m_waitrequest)

begin
	if m_waitrequest = '1' and inUse = '0' then
		if s_write_data = '1' or s_read_data = '1' then
			control <= '0';
			inUse <= '1';
		elsif s_write_instruct = '1' or s_read_instruct = '1' then
			control <= '1';
			inUse <= '1';
		end if;
	end if;
	
	if m_waitrequest'event and m_waitrequest = '1' then
		if (s_write_data = '1' or s_read_data = '1') and control = '1' then
			control <= '0';
			inUse <= '1';
		elsif (s_write_instruct = '1' or s_read_instruct = '1')and control = '0' then
			control <= '1';
			inUse <= '1';
		else
			inUse <= '0';
		end if;
	end if;
		
end process;

process (s_write_data, s_write_instruct, s_read_data, s_read_instruct, inUse, control)
begin
	if inUse = '1' then
		if control = '0' then
			m_write <= s_write_data;
			m_read <= s_read_data;
			m_addr <= s_addr_data + 1024; 
			s_readdata_data <= m_readdata;
			m_writedata <= s_writedata_data;
		elsif control = '1' then
			m_write <= s_write_instruct;
			m_read <= s_read_instruct;
			m_addr <= s_addr_instruct/4;
			s_readdata_instruct <= m_readdata;
			m_writedata <= s_writedata_instruct;
		end if;
	end if;
end process;


end arch;
