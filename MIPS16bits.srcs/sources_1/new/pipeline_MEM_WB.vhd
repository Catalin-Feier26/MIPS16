library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipeline_MEM_WB is
  Port (
    clk: in std_logic;
    
    MemToReg: in std_logic;
    RegWrite:in std_logic;
    
    MemData:in std_logic_vector(15 downto 0);
    ALURes: in std_logic_vector(15 downto 0);
    writeAdr: in std_logic_vector(2 downto 0);
    
    
    MemToReg_out: out std_logic;
    RegWrite_out: out std_logic;
    MemData_out: out std_logic_vector(15 downto 0);
    AluRes_out: out  std_logic_vector(15 downto 0);
    writeAdr_out: out std_logic_vector(2 downto 0)
  );
end pipeline_MEM_WB;

architecture Behavioral of pipeline_MEM_WB is
signal memReg_inter, reg_inter: std_logic;
signal MemData_inter, Alu_inter: std_logic_vector(15 downto 0);
signal writeAdr_inter: std_logic_vector(2 downto 0);
begin
process(clk)
begin
    if rising_edge (clk) then
        memReg_inter<=MemToReg;
        reg_inter<=RegWrite;
        MemData_inter<=MemData;
        Alu_inter<=ALURes;
        writeAdr_inter<=writeAdr;
    end if;
end process;
MemToReg_out<=memReg_inter;
RegWrite_out<=reg_inter;
MemData_out<=MemData_inter;
AluRes_out<=Alu_inter;
writeAdr_out<=writeAdr_inter;
end Behavioral;
