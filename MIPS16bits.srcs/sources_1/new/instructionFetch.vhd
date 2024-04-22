

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity InstructionFetch is
Port ( 
        clk:in std_logic;
        en: in std_logic;
        pcReset:in std_logic;
        branchAdr:in std_logic_vector(15 downto 0);
        jumpAdr: in std_logic_vector(15 downto 0);
        jmpCtrl: in std_logic; 
        pcSrc:in std_logic;
        
        instruction:out std_logic_vector(15 downto 0);
        pc_out:out std_logic_vector(15 downto 0)
);
end InstructionFetch;

architecture Behavioral of InstructionFetch is
signal mux1, mux2: std_logic_vector(15 downto 0);
signal ad:std_logic_vector(15 downto 0);
signal pc:std_logic_vector(15 downto 0);
component Memory is 
Port 
  ( 
    address:in std_logic_vector(3 downto 0);
    clk: in std_logic;
    en:in std_logic;
    instr:out std_logic_vector(15 downto 0) 
  );
  end component;
  
begin
mem:Memory port map(
        address=>pc(3 downto 0),
        clk=>clk,
        en=> en,
        instr=>instruction);

process(pcSrc)
begin
    if(pcSrc='1') then 
    mux1<=branchAdr;
    else
    mux1<=ad;
    end if;
end process;

process(jmpCtrl)
begin
    if(jmpCtrl='1') then 
        mux2<=jumpAdr;
    else
        mux2<=mux1;
     end if;
end process;

process(clk, pcReset, en)
begin
    if(pcReset='1') then 
        pc<=x"0000";
    elsif(rising_edge(clk)) then 
     if(en='1') then
        pc<=mux2;
    end if;
    end if;
end process;
   
   ad<=pc+1;
   pc_out<=ad;


end Behavioral;
