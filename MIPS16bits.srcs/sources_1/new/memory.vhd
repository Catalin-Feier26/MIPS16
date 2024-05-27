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
        -- NOP - No Operation
        1 => B"000_000_000_000_0_000", -- NOP               0x0000
        -- SUB - Sub
        2 => B"000_001_010_011_0_001", -- sub $2, $3, $1    0x0531
        -- NOP - No Operation
        3 => B"000_000_000_000_0_000", -- NOP               0x0000
        -- SLL - Shift left logical
        4 => B"000_010_010_011_0_010", -- sll $2, $3, 2     0x0932
        -- NOP - No Operation
        5 => B"000_000_000_000_0_000", -- NOP               0x0000
        -- SRL- Shift right logical
        6 => B"000_011_010_011_0_011", -- srl $2, $3, 3     0x0d33
        -- NOP - No Operation
        7 => B"000_000_000_000_0_000", -- NOP               0x0000
        -- AND - bitwise and
        8 => B"000_100_001_010_0_100", -- and $1, $0, $2    0x10A4
        -- NOP - No Operation
        9 => B"000_000_000_000_0_000", -- NOP               0x0000
        -- OR - bitwise OR
        10 => B"000_101_010_011_0_101", -- or $2, $3, $1    0x1535
        -- NOP - No Operation
        11 => B"000_000_000_000_0_000", -- NOP              0x0000
        -- XOR - bitwise XOR
        12 => B"000_110_001_010_0_110", -- xor $1, $0, $2   0x18A6
        -- NOP - No Operation
        13 => B"000_000_000_000_0_000", -- NOP              0x0000
        -- XNOR - bitwise XNOR
        14 => B"000_111_010_011_0_111", -- xnor $2, $3, $1  0x1D37
        -- NOP - No Operation
        15 => B"000_000_000_000_0_000"  -- NOP              0x0000
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
