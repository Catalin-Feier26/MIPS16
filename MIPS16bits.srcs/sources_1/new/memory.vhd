library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
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
    signal mem: rom := (
        -- ADD - Add
        0 => B"000_000_001_010_0_000", -- add $1, $0, $2    0x00A0
        -- SUB - Sub
        1 => B"000_001_010_011_0_001", -- sub $2, $3, $1    0x0531
        -- SLL - Shift left logical
        2 => B"000_010_010_011_0_010", -- sll $2, $3, 2     0x0932
        -- SRL- Shift right logical
        3 => B"000_011_010_011_0_011", -- srl $2, $3, 3     0x0d33
        -- AND - bitwise and
        4 => B"000_100_001_010_0_100", -- and $1, $0, $2    0x10A4
        -- OR - bitwise OR
        5 => B"000_101_010_011_0_101", -- or $2, $3, $1     0x1535
        -- XOR - bitwise XOR
        6 => B"000_110_001_010_0_110", -- xor $1, $0, $2    0x18A6
        -- XNOR - bitwise XNOR
        7 => B"000_111_010_011_0_111", -- xnor $2, $3, $1   0x1D37
        -- ADDI - add immediate
        8 => B"001_001_010_0000001", -- addi $1, $0, 1      0x2501
        -- LW - load word
        9 => B"010_001_010_0000001", -- lw $2, 1($0)        0x4501
        -- SW - store word
        10 => B"011_001_010_0000010", -- sw $1, 2($0)       0x6502
        -- Branch on Equal
        11 => B"100_001_010_0000011", -- beq $1, $0, 3      0x8503
        -- ANDI - Bitwise and immediate
        12 => B"101_001_010_0000100", -- andi $2, $1, 4     0xA504
        -- ORI - Bitwise OR immediate
        13 => B"110_010_010_0000101", -- ori $1, $0, 5      0xC905
        -- J - Jump     
        14 => B"111_0000000001111", -- j 15         0xE00F
        -- Default instruction
        others => B"000_000_000_000_0_000" -- Default NOP instruction 0x0000
    );
begin
    process(clk, en)
    begin
        if rising_edge(clk) then
            if en = '1' then
                instr <= mem(conv_integer(address));
            end if;
        end if;
    end process;
end Behavioral;
