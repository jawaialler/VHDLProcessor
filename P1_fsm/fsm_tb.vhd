LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE behaviour OF fsm_tb IS

COMPONENT comments_fsm IS
PORT (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk, s_reset, s_output: STD_LOGIC := '0';
SIGNAL s_input: std_logic_vector(7 downto 0) := (others => '0');

CONSTANT clk_period : time := 1 ns;
CONSTANT SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
CONSTANT STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
CONSTANT NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";

BEGIN
dut: comments_fsm
PORT MAP(clk, s_reset, s_input, s_output);

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

--8/8 state transitions tested

--random character test
	REPORT "Example case, reading a meaningless character";
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;

--put one slash and then nothing to check if we stay in no comment state
	REPORT "fake comment test";
	s_input <= SLASH_CHARACTER;--slash
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "first slash test should output 0" SEVERITY ERROR;
	--put two random characters to ensure we are indeed not in a comment
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "random character inside comment, should output 1" SEVERITY ERROR;
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "random character inside comment, should output 1" SEVERITY ERROR;


--line comment test
	REPORT "Enter line comment test";
	s_input <= SLASH_CHARACTER;--slash
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "first slash test should output 0" SEVERITY ERROR;
    s_input <= SLASH_CHARACTER;--slash
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "second slash test should output 0" SEVERITY ERROR;
	--anything after should output a 1 because it is a comment
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "random character inside comment, should output 1" SEVERITY ERROR;

--trying to end a line comment with a block comment ender
	REPORT "Block comment ender inside a line comment test";
	s_input <= STAR_CHARACTER;--star
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "star in line comment should still output 1" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;--slash
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "slash after star in line comment, should output 1" SEVERITY ERROR;
	--ensure we are still in the comment
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "random character inside comment 2, should output 1" SEVERITY ERROR;
	
--ending the line comment
	REPORT "End of line comment test";
	s_input <= NEW_LINE_CHARACTER; --new line
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "end of line inside comment, should output 1" SEVERITY ERROR;
	--ensure we are out of the comment
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "random character outside comment, should output 0" SEVERITY ERROR;

--block comment test
	REPORT "Enter block comment test";
	s_input <= SLASH_CHARACTER;--slash
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "first slash test should output 0" SEVERITY ERROR;
	s_input <= "00101010";--star
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "star after slash test should output 0" SEVERITY ERROR;
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "this should be a block comment character, should output 1" SEVERITY ERROR;

--new line inside block comment test
	REPORT "New line inside block comment test";
	s_input <= NEW_LINE_CHARACTER; --new line
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "new line inside block comment, should output 1" SEVERITY ERROR;
	--ensure we are still inside the comment even after a new line
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "after new line should still be a comment, should output 1" SEVERITY ERROR;

--random star inside block comment test
	REPORT "random star inside block comment test";
	s_input <= STAR_CHARACTER; --new line
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "star inside block comment, should output 1" SEVERITY ERROR;
	--should be in first star state, put two random characters to check if we went back to the right state
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "random character to trigger back to block comment, should output 1" SEVERITY ERROR;
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "after random star and random character, should still be a comment, should output 1" SEVERITY ERROR;
	
--ending the block comment
	REPORT "End of block comment test";
	s_input <= STAR_CHARACTER;--star
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "star in comment should still output 1" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;--slash
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "slash after star, still outputs 1" SEVERITY ERROR;
	--ensure we are out of the comment
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "random character outside comment, should output 0" SEVERITY ERROR;

--reset test case
	REPORT "Reset test case within comment"; --check if reset works, begin by creatng a comment, then reset, then should continue getting 0 as output
	s_input <= SLASH_CHARACTER;--slash
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "first slash test should output 0" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;--star
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "star after slash test should output 0" SEVERITY ERROR;
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "this should be a block comment character, should output 1" SEVERITY ERROR;
	s_reset <= '1'; --reset
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reset is high, output should be 0" SEVERITY ERROR;
  	s_reset <= '0';
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "This should have been reset, so random character out of comment should be 0" SEVERITY ERROR;

--try to reset when not in a comment
	REPORT "Reset test case outside comment";
	s_reset <= '1'; --reset
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reset is high, output should be 0" SEVERITY ERROR;
  	s_reset <= '0';
	s_input <= "00000000"; --random
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "This should have been reset, so random character out of comment should be 0" SEVERITY ERROR;



	WAIT;
END PROCESS stim_process;
END;
