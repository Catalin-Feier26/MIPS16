library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mip is
    Port (
        clk: in std_logic;
        btn: in std_logic_vector(4 downto 0);
        sw: in std_logic_vector(15 downto 0);
        cat: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0);
        led: out std_logic_vector(15 downto 0)
    );
end mip;

architecture Behavioral of mip is
    signal btns: std_logic_vector(4 downto 0);

    signal pc, pc_IF_ID: std_logic_vector(15 downto 0);
    signal instruction, instruction_IF_ID: std_logic_vector(15 downto 0);
    signal branchAdr, branchAddr_EX_MEM: std_logic_vector(15 downto 0);
    signal jumpAdr: std_logic_vector(15 downto 0);
    signal jmpCtrl, pcSrc, pcSrc_EX_MEM: std_logic;
    
    signal rd1, rd1_ID_EX, rd2, rd2_ID_EX, rd2_EX_MEM, writeData, writeData_MEM_WB: std_logic_vector(15 downto 0);
    signal ALURes, ALURes_EX_MEM, ALURes_MEM_WB, ext_imm, ext_imm_ID_EX: std_logic_vector(15 downto 0);
    signal MemData, MemData_MEM_WB: std_logic_vector(15 downto 0);
    signal zero, zero_EX_MEM: std_logic;
    
    signal func, func_ID_EX: std_logic_vector(2 downto 0);
    signal sa, sa_ID_EX: std_logic;
    
    signal RegDst, RegDst_ID_EX, ExtOp, ExtOp_ID_EX, ALUSrc, ALUSrc_ID_EX, Branch, Branch_ID_EX, Branch_EX_MEM, Jump, MemWrite, MemWrite_ID_EX, MemWrite_EX_MEM, MemtoReg, MemtoReg_ID_EX, MemtoReg_EX_MEM, MemtoReg_MEM_WB, RegWrite, RegWrite_ID_EX, RegWrite_EX_MEM, RegWrite_MEM_WB: std_logic;
    signal ALUOp, ALUOp_ID_EX: std_logic_vector(2 downto 0);
    signal mux3: std_logic_vector(15 downto 0);
    
    signal ss: std_logic_vector(15 downto 0);
begin
    ssd: entity work.SSD(Behavioral)
    port map(
        digit => ss,
        clk => clk,
        cat => cat,
        an => an
    );

    deb1: entity work.debouncer(Behavioral)
    port map(
        clk => clk,
        btn => btn(0),
        en => btns(0)
    );

    deb2: entity work.debouncer(Behavioral)
    port map(
        clk => clk,
        btn => btn(1),
        en => btns(1)
    );

    deb3: entity work.debouncer(Behavioral)
    port map(
        clk => clk,
        btn => btn(2),
        en => btns(2)
    );

    deb4: entity work.debouncer(Behavioral)
    port map(
        clk => clk,
        btn => btn(3),
        en => btns(3)
    );

    deb5: entity work.debouncer(Behavioral)
    port map(
        clk => clk,
        btn => btn(4),
        en => btns(4)
    );

    -- Instruction Fetch
    IFetch: entity work.InstructionFetch(Behavioral)
    port map (
        clk => btns(0),
        en => '1',  
        pcReset => btns(1),
        branchAdr => branchAddr_EX_MEM,
        jumpAdr => jumpAdr,
        jmpCtrl => jmpCtrl,
        pcSrc => pcSrc_EX_MEM,
        instruction => instruction,
        pc_out => pc
    );

    -- IF/ID Pipeline Register
    IF_ID: entity work.pipeline_IF_ID(Behavioral)
    port map (
        clk => clk,
        instruction => instruction,
        pc_in => pc,
        instr_out => instruction_IF_ID,
        pc_out => pc_IF_ID
    );

    -- Main Control Unit
    MCtrl: entity work.MainControl(Behavioral)
    port map (
        input => instruction_IF_ID(15 downto 13), 
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
        instr => instruction_IF_ID,
        writeData => writeData_MEM_WB,
        en => '1', 
        regWrite => RegWrite_MEM_WB,
        regDst => RegDst,
        extOp => ExtOp,
        rd1 => rd1,
        rd2 => rd2,
        ext_imm => ext_imm,
        func => func,
        sa => sa
    );

    -- ID/EX Pipeline Register
    ID_EX: entity work.pipeline_ID_EX(Behavioral)
    port map (
        clk => clk,
        MemToReg => MemtoReg,
        RegWrite => RegWrite,
        MemWrite => MemWrite,
        branch => Branch,
        ALUop => ALUOp,
        ALUSrc => ALUSrc,
        RegDst => RegDst,
        pc_in => pc_IF_ID,
        rd1_in => rd1,
        rd2_in => rd2,
        ext_imm_in => ext_imm,
        func_in => func,
        sa_in => sa,
        imm_in => instruction_IF_ID(6 downto 0),
        MemToReg_out => MemtoReg_ID_EX,
        RegWrite_out => RegWrite_ID_EX,
        MemWrite_out => MemWrite_ID_EX,
        branch_out => Branch_ID_EX,
        ALUop_out => ALUOp_ID_EX,
        ALUSrc_out => ALUSrc_ID_EX,
        RegDst_out => RegDst_ID_EX,
        pc_out => pc_IF_ID,
        rd1_out => rd1_ID_EX,
        rd2_out => rd2_ID_EX,
        ext_imm_out => ext_imm_ID_EX,
        func_out => func_ID_EX,
        sa_out => sa_ID_EX,
        imm_out => instruction_IF_ID(6 downto 0)
    );

    -- Execute Unit
    ExecUnit: entity work.executeUnit(Behavioral)
    port map (
        pc_1 => pc_IF_ID,
        rd1 => rd1_ID_EX,
        rd2 => rd2_ID_EX,
        ext_imm => ext_imm_ID_EX,
        func => func_ID_EX,
        sa => sa_ID_EX,
        ALUsrc => ALUSrc_ID_EX,
        ALUOp => ALUOp_ID_EX,
        br_Addr => branchAdr,
        ALURes => ALURes,
        zero => zero
    );

    -- EX/MEM Pipeline Register
    EX_MEM: entity work.pipeline_EX_MEM(Behavioral)
    port map (
        clk => clk,
        MemToReg => MemtoReg_ID_EX,
        RegWrite => RegWrite_ID_EX,
        MemWrite => MemWrite_ID_EX,
        branch => Branch_ID_EX,
        branchAddr => branchAdr,
        zero => zero,
        ALURes => ALURes,
        rd2 => rd2_ID_EX,
        writeAdr => instruction_IF_ID(6 downto 4), -- Assuming 3-bit register addresses
        MemToReg_out => MemtoReg_EX_MEM,
        RegWrite_out => RegWrite_EX_MEM,
        MemWrite_out => MemWrite_EX_MEM,
        branch_out => Branch_EX_MEM,
        branchAddr_out => branchAddr_EX_MEM,
        zero_out => zero_EX_MEM,
        ALURes_out => ALURes_EX_MEM,
        rd2_out => rd2_EX_MEM,
        writeAdr_out => instruction_IF_ID(6 downto 4)
    );

    -- Memory Unit
    MemUnit: entity work.mem(Behavioral)
    port map (
        clk => clk,
        MemWrite => MemWrite_EX_MEM,
        ALURes => ALURes_EX_MEM,
        rd2 => rd2_EX_MEM,
        MemData => MemData
    );

    -- MEM/WB Pipeline Register
    MEM_WB: entity work.pipeline_MEM_WB(Behavioral)
    port map (
        clk => clk,
        MemToReg => MemtoReg_EX_MEM,
        RegWrite => RegWrite_EX_MEM,
        MemData => MemData,
        ALURes => ALURes_EX_MEM,
        writeAdr => instruction_IF_ID(6 downto 4),
        MemToReg_out => MemtoReg_MEM_WB,
        RegWrite_out => RegWrite_MEM_WB,
        MemData_out => MemData_MEM_WB,
        AluRes_out => ALURes_MEM_WB,
        writeAdr_out => instruction_IF_ID(6 downto 4)
    );

    process(Branch_EX_MEM, zero_EX_MEM)
    begin
        pcSrc_EX_MEM <= Branch_EX_MEM and zero_EX_MEM;
    end process;
    
    process(MemtoReg_MEM_WB, MemData_MEM_WB, ALURes_MEM_WB)
    begin
        if MemtoReg_MEM_WB = '1' then
            mux3 <= MemData_MEM_WB;
        else
            mux3 <= ALURes_MEM_WB;
        end if;
    end process;
    writeData <= mux3;
    
    process(sw)
    begin
        case sw(7 downto 5) is
            when "000" => ss <= instruction;
            when "001" => ss <= pc;
            when "010" => ss <= rd1;
            when "011" => ss <= rd2;
            when "100" => ss <= ext_imm;
            when "101" => ss <= ALURes;
            when "110" => ss <= MemData;
            when others => ss <= writeData;
        end case;
    end process;
    
end Behavioral;