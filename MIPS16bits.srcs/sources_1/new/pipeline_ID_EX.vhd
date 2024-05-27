library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pipeline_ID_EX is
    Port (
        clk: in std_logic;
        MemToReg: in std_logic;
        RegWrite: in std_logic;
        MemWrite: in std_logic;
        branch: in std_logic;
        ALUop: in std_logic_vector(2 downto 0);
        ALUSrc: in std_logic;
        RegDst: in std_logic;
        pc_in: in std_logic_vector(15 downto 0);
        rd1_in: in std_logic_vector(15 downto 0);
        rd2_in: in std_logic_vector(15 downto 0);
        ext_imm_in: in std_logic_vector(15 downto 0);
        func_in: in std_logic_vector(2 downto 0);
        sa_in: in std_logic;
        imm_in: in std_logic_vector(6 downto 0);
        MemToReg_out: out std_logic;
        RegWrite_out: out std_logic;
        MemWrite_out: out std_logic;
        branch_out: out std_logic;
        ALUop_out: out std_logic_vector(2 downto 0);
        ALUSrc_out: out std_logic;
        RegDst_out: out std_logic;
        pc_out: out std_logic_vector(15 downto 0);
        rd1_out: out std_logic_vector(15 downto 0);
        rd2_out: out std_logic_vector(15 downto 0);
        ext_imm_out: out std_logic_vector(15 downto 0);
        func_out: out std_logic_vector(2 downto 0);
        sa_out: out std_logic;
        imm_out: out std_logic_vector(6 downto 0)
    );
end pipeline_ID_EX;

architecture Behavioral of pipeline_ID_EX is
    signal mem_inter, reg_inter, memWrite_inter, branch_inter: std_logic;
    signal ALUOp_inter: std_logic_vector(2 downto 0);
    signal ALUSrc_inter, RegDst_inter: std_logic;
    signal pc_inter, rd1_inter, rd2_inter, ext_imm_inter: std_logic_vector(15 downto 0);
    signal func_inter: std_logic_vector(2 downto 0);
    signal imm_inter: std_logic_vector(6 downto 0);
    signal sa_inter: std_logic;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            mem_inter <= MemToReg;
            reg_inter <= RegWrite;
            memWrite_inter <= MemWrite;
            branch_inter <= branch;
            ALUOp_inter <= ALUop;
            ALUSrc_inter <= ALUSrc;
            RegDst_inter <= RegDst;
            pc_inter <= pc_in;
            rd1_inter <= rd1_in;
            rd2_inter <= rd2_in;
            ext_imm_inter <= ext_imm_in;
            func_inter <= func_in;
            imm_inter <= imm_in;
            sa_inter <= sa_in;
        end if;
    end process;

    MemToReg_out <= mem_inter;
    RegWrite_out <= reg_inter;
    MemWrite_out <= memWrite_inter;
    branch_out <= branch_inter;
    ALUop_out <= ALUOp_inter;
    ALUSrc_out <= ALUSrc_inter;
    RegDst_out <= RegDst_inter;
    pc_out <= pc_inter;
    rd1_out <= rd1_inter;
    rd2_out <= rd2_inter;
    ext_imm_out <= ext_imm_inter;
    func_out <= func_inter;
    sa_out <= sa_inter;
    imm_out <= imm_inter;
end Behavioral;