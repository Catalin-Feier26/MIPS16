
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MainControl is
  Port (
        input: in std_logic_vector(2 downto 0);
        
        RegDst: out std_logic;
        Extop: out std_logic;
        ALUSrc: out std_logic;
        branch: out std_logic;
        jump: out std_logic;
        ALUOp: out std_logic_vector(2 downto 0);
        MemWrite: out std_logic;
        MemtoReg: out std_logic;
        RegWrite: out std_logic
   );
end MainControl;

architecture Behavioral of MainControl is
begin
    process(input)
    begin
        -- Reset all control signals by default
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        ALUOp <= "000";
        MemWrite <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';

        case input is
            when "000" => -- R-type instruction (e.g., add, sub, and, or, etc.)
                RegDst <= '1';
                ALUSrc <= '0';
                MemtoReg <= '0';
                RegWrite <= '1';
                ALUOp <= input; 

            when "001" => -- I-type instruction (e.g., addi, andi, ori, etc.)
                RegDst <= '0';
                ALUSrc <= '1';
                MemtoReg <= '0';
                RegWrite <= '1';
                ALUOp <= input; -- ALUOp for immediate instructions

            when "010" => -- Load instruction (lw)
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                ALUOp <= input; -- ALUOp for load

            when "011" => -- Store instruction (sw)
                ALUSrc <= '1';
                MemWrite <= '1';
                ALUOp <= input; -- ALUOp for store

            when "100" => -- Branch equal (beq)
                Branch <= '1';
                ALUOp <= input; -- ALUOp for branch
                        
            when "101" => 
                RegDst <= '0';
                ALUSrc <= '1';
                MemtoReg <= '0';
                RegWrite <= '1';
                ALUOp <= input; -- ALUOp for immediate instructions
            when "110" => -- ORI
                    RegDst <= '0';
                    ALUSrc <= '1';
                    MemtoReg <= '0';
                    RegWrite <= '1';
                    ALUOp <= input;

            when others => -- Default case or undefined opcodes
                Jump<='1';
                ALUOp<=input;
        end case;
    end process;
end Behavioral;

