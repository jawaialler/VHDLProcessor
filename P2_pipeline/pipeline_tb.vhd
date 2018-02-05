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

CONSTANT clk_period : time := 1 ns;

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
--first begin testing for input that wait the whole clock cycle to end
	REPORT "Testing for 5 clock cycles, with no pipelining";
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
	ASSERT (s_final_output = 174) REPORT "Final output, final_output should be 174" SEVERITY ERROR;

--test for 0 inputs	
	REPORT "Inputs set to 0";	
	s_a <= 0;
	s_b <= 0;
	s_c <= 0;
	s_d <= 0;
	s_e <= 0;
	WAIT FOR 1 * clk_period;
	--check for first clock cycle
	ASSERT (s_op1 = 0) REPORT "First clock cycle, op1 should be 0" SEVERITY ERROR;
  	ASSERT (s_op3 = 0) REPORT "First clock cycle, op3 should be 0" SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "First clock cycle, op4 should be 0" SEVERITY ERROR;
  
	--check for second clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op2 = 0) REPORT "Second clock cycle, op2 should be 0" SEVERITY ERROR;
 	ASSERT (s_op5 = 0) REPORT "Second clock cycle, op5 should be 0" SEVERITY ERROR;
  
	--check for third clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_final_output = 0) REPORT "Third clock cycle, final_output should be 0" SEVERITY ERROR;


--test for 3 clock cycles
	REPORT "Testing for 3 iterations";
	s_a <= 1;
	s_b <= 2;
	s_c <= 3;
	s_d <= 4;
	s_e <= 5;
	--check for first clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 3) REPORT "First clock cycle, op1 should be 3" SEVERITY ERROR;
  	ASSERT (s_op3 = 12) REPORT "First clock cycle, op3 should be 12" SEVERITY ERROR;
  	ASSERT (s_op4 = -4) REPORT "First clock cycle, op4 should be -4" SEVERITY ERROR;
  
	--check for second clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op2 = 126) REPORT "Second clock cycle, op2 should be 126" SEVERITY ERROR;
 	ASSERT (s_op5 = -48) REPORT "Second clock cycle, op5 should be -48" SEVERITY ERROR;
  
	--check for third clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_final_output = 174) REPORT "Third clock cycle, final_output should be 174" SEVERITY ERROR;

--test for 3 clock cycles
	REPORT "Testing for 3 iterations";
	s_a <= 6;
	s_b <= 7;
	s_c <= 8;
	s_d <= 9;
	s_e <= 15;
	--check for first clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 13) REPORT "First clock cycle, op1 should be 13" SEVERITY ERROR;
  	ASSERT (s_op3 = 72) REPORT "First clock cycle, op3 should be 72" SEVERITY ERROR;
  	ASSERT (s_op4 = -9) REPORT "First clock cycle, op4 should be -9" SEVERITY ERROR;
  
	--check for second clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op2 = 546) REPORT "Second clock cycle, op2 should be 546" SEVERITY ERROR;
 	ASSERT (s_op5 = -648) REPORT "Second clock cycle, op5 should be -648" SEVERITY ERROR;
  
	--check for third clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_final_output = 1194) REPORT "Third clock cycle, final_output should be 1194" SEVERITY ERROR;

--test for negative inputs
	REPORT "Inputs set to -1, -2, -3, -4, -5";	
	s_a <= -1;
	s_b <= -2;
	s_c <= -3;
	s_d <= -4;
	s_e <= -5;
	WAIT FOR 1 * clk_period;
	--check for first clock cycle
	ASSERT (s_op1 = 0) REPORT "First clock cycle, op1 should be " SEVERITY ERROR;
  	ASSERT (s_op3 = 0) REPORT "First clock cycle, op3 should be " SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "First clock cycle, op4 should be " SEVERITY ERROR;
  
	--check for second clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op2 = 0) REPORT "Second clock cycle, op2 should be " SEVERITY ERROR;
 	ASSERT (s_op5 = 0) REPORT "Second clock cycle, op5 should be " SEVERITY ERROR;
  
	--check for third clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_final_output = 0) REPORT "Third clock cycle, final_output should be " SEVERITY ERROR;





--second, test for "draining" the pipeline with 0 inputs
	REPORT "Testing for draining the pipeline";
	s_a <= 1;
	s_b <= 2;
	s_c <= 3;
	s_d <= 4;
	s_e <= 5;
	WAIT FOR 1 * clk_period;
	s_a <= 0;
	s_b <= 0;
	s_c <= 0;
	s_d <= 0;
	s_e <= 0;
	--check for first clock cycle
	ASSERT (s_op1 = 3) REPORT "First clock cycle, op1 should be 3" SEVERITY ERROR;
  	ASSERT (s_op3 = 12) REPORT "First clock cycle, op3 should be 12" SEVERITY ERROR;
  	ASSERT (s_op4 = -4) REPORT "First clock cycle, op4 should be -4" SEVERITY ERROR;
  
	--check for second clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 0) REPORT "Second clock cycle, op1 should be 0" SEVERITY ERROR;
  	ASSERT (s_op3 = 0) REPORT "Second clock cycle, op3 should be 0" SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "Second clock cycle, op4 should be 0" SEVERITY ERROR;

	ASSERT (s_op2 = 126) REPORT "Second clock cycle, op2 should be 126" SEVERITY ERROR;
 	ASSERT (s_op5 = -48) REPORT "Second clock cycle, op5 should be -48" SEVERITY ERROR;
  
	--check for third clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 0) REPORT "Second clock cycle, op1 should be 0" SEVERITY ERROR;
  	ASSERT (s_op3 = 0) REPORT "Second clock cycle, op3 should be 0" SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "Second clock cycle, op4 should be 0" SEVERITY ERROR;

	ASSERT (s_op2 = 0) REPORT "Second clock cycle, op2 should be 0" SEVERITY ERROR;
	ASSERT (s_op5 = 0) REPORT "Second clock cycle, op5 should be 0" SEVERITY ERROR;
	 
	ASSERT (s_final_output = 174) REPORT "Third clock cycle, final_output should be 174" SEVERITY ERROR;

	--check for fourth clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 0) REPORT "Second clock cycle, op1 should be 0" SEVERITY ERROR;
  	ASSERT (s_op3 = 0) REPORT "Second clock cycle, op3 should be 0" SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "Second clock cycle, op4 should be 0" SEVERITY ERROR;

	ASSERT (s_op2 = 0) REPORT "Second clock cycle, op2 should be 0" SEVERITY ERROR;
	ASSERT (s_op5 = 0) REPORT "Second clock cycle, op5 should be 0" SEVERITY ERROR;
	 
	ASSERT (s_final_output = 0) REPORT "Third clock cycle, final_output should be 0" SEVERITY ERROR;





--third, test for filling up the pipeline as previous input from clock cycles are processed
	REPORT "Testing for 5 clock cycles, with pipelining";
	REPORT "Set input to a=1, b=2, c=3, d=4, d=5";
	s_a <= 1;
	s_b <= 2;
	s_c <= 3;
	s_d <= 4;
	s_e <= 5;
	--check for first clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 3) REPORT "First clock cycle, op1 should be 3" SEVERITY ERROR; --first set of inputs
  	ASSERT (s_op3 = 12) REPORT "First clock cycle, op3 should be 12" SEVERITY ERROR;
  	ASSERT (s_op4 = -4) REPORT "First clock cycle, op4 should be -4" SEVERITY ERROR;

	--change inputs
	REPORT "Set input to a=6, b=7, c=8, d=9, d=10";
	s_a <= 6;
	s_b <= 7;
	s_c <= 8;
	s_d <= 9;
	s_e <= 15;
	--check for second clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 13) REPORT "Second clock cycle, op1 should be 13" SEVERITY ERROR; --second set of inputs
  	ASSERT (s_op3 = 72) REPORT "Second clock cycle, op3 should be 72" SEVERITY ERROR;
  	ASSERT (s_op4 = -9) REPORT "Second clock cycle, op4 should be -9" SEVERITY ERROR;
	
	ASSERT (s_op2 = 126) REPORT "Second clock cycle, op2 should be 126" SEVERITY ERROR; --first set of inputs
 	ASSERT (s_op5 = -48) REPORT "Second clock cycle, op5 should be -48" SEVERITY ERROR;

	--change inputs
	REPORT "Set input to a=11, b=12, c=13, d=14, d=15";
	s_a <= 11;
	s_b <= 12;
	s_c <= 13;
	s_d <= 14;
	s_e <= 10;
	--check for third clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 23) REPORT "Second clock cycle, op1 should be 23" SEVERITY ERROR; --third set of inputs
  	ASSERT (s_op3 = 182) REPORT "Second clock cycle, op3 should be 182" SEVERITY ERROR;
  	ASSERT (s_op4 = 1) REPORT "Second clock cycle, op4 should be 1" SEVERITY ERROR;

	ASSERT (s_op2 = 546) REPORT "Second clock cycle, op2 should be 546" SEVERITY ERROR; --second set of inputs
 	ASSERT (s_op5 = -648) REPORT "Second clock cycle, op5 should be -648" SEVERITY ERROR;

	ASSERT (s_final_output = 174) REPORT "Third clock cycle, final_output should be 174" SEVERITY ERROR; --first set of inputs

	--change inputs
	REPORT "Set input to 0 for 'draining'";
	s_a <= 0;
	s_b <= 0;
	s_c <= 0;
	s_d <= 0;
	s_e <= 0;

	--check for fourth clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 0) REPORT "Second clock cycle, op1 should be 0" SEVERITY ERROR; --empty set of inputs
  	ASSERT (s_op3 = 0) REPORT "Second clock cycle, op3 should be 0" SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "Second clock cycle, op4 should be 0" SEVERITY ERROR;

	ASSERT (s_op2 = 966) REPORT "Second clock cycle, op2 should be 966" SEVERITY ERROR; --third set of inputs
 	ASSERT (s_op5 = 182) REPORT "Second clock cycle, op5 should be 182" SEVERITY ERROR;

	ASSERT (s_final_output = 1194) REPORT "Third clock cycle, final_output should be 1194" SEVERITY ERROR; --second set of inputs

	--check for fifth clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 0) REPORT "Second clock cycle, op1 should be 0" SEVERITY ERROR; --empty set of inputs
  	ASSERT (s_op3 = 0) REPORT "Second clock cycle, op3 should be 0" SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "Second clock cycle, op4 should be 0" SEVERITY ERROR;

	ASSERT (s_op2 = 0) REPORT "Second clock cycle, op2 should be 0" SEVERITY ERROR; --empty set of inputs
	ASSERT (s_op5 = 0) REPORT "Second clock cycle, op5 should be 0" SEVERITY ERROR;
	
	ASSERT (s_final_output = 784) REPORT "Third clock cycle, final_output should be 784" SEVERITY ERROR; --third set of inputs

	--check for sixth clock cycle
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 0) REPORT "Second clock cycle, op1 should be 0" SEVERITY ERROR; --empty set of inputs
  	ASSERT (s_op3 = 0) REPORT "Second clock cycle, op3 should be 0" SEVERITY ERROR;
  	ASSERT (s_op4 = 0) REPORT "Second clock cycle, op4 should be 0" SEVERITY ERROR;

	ASSERT (s_op2 = 0) REPORT "Second clock cycle, op2 should be 0" SEVERITY ERROR; --empty set of inputs
	ASSERT (s_op5 = 0) REPORT "Second clock cycle, op5 should be 0" SEVERITY ERROR;
	 
	ASSERT (s_final_output = 0) REPORT "Third clock cycle, final_output should be 0" SEVERITY ERROR; --empty set of inputs

	WAIT;
END PROCESS stim_process;
END;
