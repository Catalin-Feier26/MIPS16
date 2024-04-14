library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mip is
    Port (
        clk: in std_logic;
        reset: in std_logic

    );
end mip;

architecture Behavioral of mip is
    signal pc: std_logic_vector(15 downto 0);
    signal instruction: std_logic_vector(15 downto 0);
    signal branchAdr: std_logic_vector(15 downto 0);
    signal jumpAdr: std_logic_vector(15 downto 0);
    signal jmpCtrl, pcSrc: std_logic;
    
    signal rd1, rd2, writeData, ALURes, ext_imm, MemData: std_logic_vector(15 downto 0);
    signal zero: std_logic;
    
    signal func: std_logic_vector(2 downto 0);
    signal sa: std_logic;
    
    signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite: std_logic;
    signal ALUOp: std_logic_vector(2 downto 0);
    signal mux3: std_logic_vector(15 downto 0);
begin

    -- Instruction Fetch
    IFetch: entity work.InstructionFetch(Behavioral)
        port map (
            clk => clk,
            en => '1',  -- Assuming always enabled for simplicity
            pcReset => reset,
            branchAdr => branchAdr,
            jumpAdr => jumpAdr,
            jmpCtrl => jmpCtrl,
            pcSrc => pcSrc,
            instruction => instruction,
            pc_out => pc
        );
        
    -- Main Control Unit
    MCtrl: entity work.MainControl(Behavioral)
        port map (
            input => instruction(15 downto 13), -- Adjust the bit range as per your instruction format
            RegDst => RegDst,
            ExtOp => ExtOp,
            ALUSrc => ALUSrc,
            Branch => Branch,
            Jump => Jump,
            ALUOp => ALUOp,
            MemWrite => MemWrite,
            MemtoReg => MemtoReg,
            RegWrite => RegWrite
        );
        
    -- Instruction Decode
    IDecode: entity work.InstructionDecode(Behavioral)
        port map (
            clk => clk,
            instr => instruction,
            writeData => writeData,
            en => '1',  -- Assuming always enabled for simplicity
            regWrite => RegWrite,
            regDst => RegDst,
            extOp => ExtOp,
            rd1 => rd1,
            rd2 => rd2,
            ext_imm => ext_imm,
            func => func,
            sa => sa
        );
        
    -- Execute Unit
    ExecUnit: entity work.executeUnit(Behavioral)
        port map (
            pc_1 => pc,
            rd1 => rd1,
            rd2 => rd2,
            ext_imm => ext_imm,
            func => func,
            sa => sa,
            ALUsrc => ALUSrc,
            ALUOp => ALUOp,
            br_Addr => branchAdr,
            ALURes => ALURes,
            zero => zero
        );
        
    -- Memory Unit
    MemUnit: entity work.mem(Behavioral)
        port map (
            clk => clk,
            MemWrite => MemWrite,
            ALURes => ALURes,
            rd2 => rd2,
            MemData => MemData
        );
        
    process(Branch, zero)
    begin
        PCSrc<=Branch and zero;
    end process;
    
    process(MemtoReg, rd2, ALURes)
    begin
        if(MemtoReg='1') then
            mux3<=MemData;
        else
            mux3<=ALURes;
        end if;
    end process;
    writeData<=mux3;

end Behavioral;
