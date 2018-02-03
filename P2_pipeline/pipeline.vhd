library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline is
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
end pipeline;

architecture behavioral of pipeline is

signal i : integer :=0;
signal temp1, temp2, temp3, temp4, temp5 : integer;

begin
process (clk, a, b, c, d, e)
begin
  if(rising_edge(Clk)) then
        for i in 0 to 5 loop 
            case i is 
                when 0 => temp1 <= a + b;
                when 1 => temp2 <= temp1 * 42;
                when 2 => temp3 <= c * d;
                when 3 => temp4 <= a - e;
                when 4 => temp5 <= temp3 * temp4;
                when 5 => final_output <= temp2 - temp5;
                when others => null;
            end case;
        end loop; 
    end if;

end process;

op1 <= temp1;
op2 <= temp2;
op3 <= temp3;
op4 <= temp4;
op5 <= temp5;

end behavioral;