library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity pipeline_IF_ID is
Port ( 
    clk: in std_logic;
    instruction: in std_logic_vector(15 downto 0);
    pc_in: in std_logic_vector(15 downto 0);
    
    instr_out: out std_logic_vector(15 downto 0);
    pc_out: out std_logic_vector(15 downto 0)
);
end pipeline_IF_ID;

architecture Behavioral of pipeline_IF_ID is
signal instr_inter:std_logic_vector(15 downto 0):=X"0000";
signal pcout_inter:std_logic_vector(15 downto 0):=X"0000";

begin

process(clk)
begin
    if(rising_edge(clk))then
        instr_inter<=instruction;
        pcout_inter<=pc_in;
    end if;
end process;

instr_out<=instr_inter;
pc_out<=pcout_inter;

end Behavioral;
