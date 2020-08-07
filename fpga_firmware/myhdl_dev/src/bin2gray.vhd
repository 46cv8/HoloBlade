-- File: bin2gray.vhd
-- Generated by MyHDL 0.11
-- Date: Fri Feb 28 09:49:20 2020


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.pck_myhdl_011.all;

entity bin2gray is
    port (
        B: in unsigned(7 downto 0);
        G: out unsigned(7 downto 0)
    );
end entity bin2gray;
-- Gray encoder.
-- 
-- B -- binary input 
-- G -- Gray encoded output

architecture MyHDL of bin2gray is




begin





G <= (shift_right(B, 1) xor B);

end architecture MyHDL;