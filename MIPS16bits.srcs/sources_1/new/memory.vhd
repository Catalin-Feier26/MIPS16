

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity memory is
 Port (
     clk: in std_logic;
     en: in std_logic;
     address: in std_logic_vector(3 downto 0);
     
     instr: out std_logic_vector(15 downto 0)
 );
end memory;

architecture Behavioral of memory is
type rom is array(0 to 15) of std_logic_vector(15 downto 0);
signal mem: rom :=( others=> x"0000");

begin

process(clk,en)
begin
    if(rising_edge(clk)) then
        if(en='1') then
            instr<=mem(conv_integer(address));
        end if;
    end if;
end process;

end Behavioral;
