LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY pipeline_tb IS
END pipeline_tb;

ARCHITECTURE behaviour OF pipeline_tb IS

COMPONENT pipeline IS
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk: STD_LOGIC := '0';
SIGNAL s_a, s_b, s_c, s_d, s_e : INTEGER := 0;
SIGNAL s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output : INTEGER := 0;

CONSTANT clk_period : time := 20 ns;

BEGIN
dut: pipeline
PORT MAP(clk, s_a, s_b, s_c, s_d, s_e, s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
 

stim_process: PROCESS
BEGIN   
	--TODO: Stimulate the inputs for the pipelined equation ((a + b) * 42) - (c * d * (a - e)) and assert the results
	--assign the values required
	REPORT "Testing for a=1, b=2, c=3, d=4, e=5";
	s_a <= 1;
	s_b <= 2;
	s_c <= 3;
	s_d <= 4;
	s_e <= 5;
	--check for first intermediate stage
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 3) REPORT "First stage, op1 should be 3" SEVERITY ERROR;

	--check for second intermediate stage
	WAIT FOR 1 * clk_period;
	ASSERT (s_op2 = 126) REPORT "First stage, op2 should be 126" SEVERITY ERROR;

	--check for third intermediate stage
	WAIT FOR 1 * clk_period;
	ASSERT (s_op3 = 12) REPORT "First stage, op3 should be 12" SEVERITY ERROR;

	--check for fourth intermediate stage
	WAIT FOR 1 * clk_period;
	ASSERT (s_op4 = -4) REPORT "First stage, op4 should be -4" SEVERITY ERROR;
	
	--check for fifth intermediate stage
	WAIT FOR 1 * clk_period;
	ASSERT (s_op5 = -48) REPORT "Fifth stage, op5 should be -48" SEVERITY ERROR;

	--check for final output value
	WAIT FOR 1 * clk_period;
	ASSERT (s_final_output = 3) REPORT "Final output, final_output should be 174" SEVERITY ERROR;
	


--FINISH THE TESTING


	WAIT;
END PROCESS stim_process;
END;
