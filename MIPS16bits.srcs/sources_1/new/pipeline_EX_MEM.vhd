library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pipeline_EX_MEM is
 Port (
    clk: in std_logic;
    
    MemToReg: in std_logic;
    RegWrite: in std_logic;
    
    MemWrite: in std_logic;
    branch: in std_logic;
    
    branchAddr: in std_logic_vector(15 downto 0);
    zero: in std_logic;
    ALURes: in std_logic_vector(15 downto 0);
    rd2: in std_logic_vector(15 downto 0);
    writeAdr: in std_logic_vector(2 downto 0);
    
    MemToReg_out: out std_logic;
    RegWrite_out: out std_logic;
       
    MemWrite_out: out std_logic;
    branch_out: out std_logic;
        
    branchAddr_out: out std_logic_vector(15 downto 0);
    zero_out: out std_logic;
    ALURes_out: out std_logic_vector(15 downto 0);
    rd2_out: out std_logic_vector(15 downto 0);
    writeAdr_out: out std_logic_vector(2 downto 0)  
  );
end pipeline_EX_MEM;

architecture Behavioral of pipeline_EX_MEM is
signal memToReg_inter, RegWrite_inter, memWrite_inter, branch_inter: std_logic;
signal branchAddr_inter: std_logic_vector(15 downto 0);
signal zero_inter: std_logic;
signal rd2_inter, ALURes_inter: std_logic_vector(15 downto 0);
signal writeAdr_inter: std_logic_vector(2 downto 0);

begin
process(clk)
begin
  if rising_edge(clk) then
    memToReg_inter<=MemToReg;
    RegWrite_inter<=RegWrite;
    memWrite_inter<=MemWrite;
    branch_inter<=branch;
    branchAddr_inter<=branchAddr;
    zero_inter<=zero;
    rd2_inter<=rd2;
    ALURes_inter<=ALURes;
    writeAdr_inter<=writeAdr;
  end if;
end process;
MemToReg_out<=memToReg_inter;
RegWrite_out<=RegWrite_inter;
MemWrite_out<=memWrite_inter;
branch_out<=branch_inter;
branchAddr_out<=branchAddr_inter;
zero_out<=zero_inter;
rd2_out<=rd2_inter;
ALURes_out<=ALURes_inter;
writeAdr_out<=writeAdr_inter;

end Behavioral;
