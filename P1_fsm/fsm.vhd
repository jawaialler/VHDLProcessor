library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Do not modify the port map of this structure
entity comments_fsm is
port (clk : in std_logic;
	reset : in std_logic;
	input : in std_logic_vector(7 downto 0);
	output : out std_logic
	);
end comments_fsm;

architecture behavioral of comments_fsm is

-- The ASCII value for the '/', '*' and end-of-line characters
constant SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
constant STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
constant NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";

--have to define the states
type state_type is (notcomment, firstslash, firststar, linecomment, blockcomment);
	signal state : state_type;
--end states

--end of state declaration

begin

-- Insert your processes here
process (clk, reset)
begin
	if (reset = '1') then	--reset to first state, assume not a comment yet
		state <= notcomment;
		output <= '0';
	elsif rising_edge(clk) then 
	
		--begin case statement for fsm
		case state is
	--1st state is when it is actual code and not a comment
			when notcomment =>
			output <= '0';
			if input = SLASH_CHARACTER then --if we encounter a slash, it may indicate the beginning of a comment
				state <= firstslash; --must go to firstslash state to check what follows, as one slash may not be a comment, dependent on what follows
			end if;

			when firstslash =>
			output <= '0';
			if input = STAR_CHARACTER then --if the next character is a star, this indicates a block comment
				state <= blockcomment; --go to appropriate block comment state
			elsif input = SLASH_CHARACTER then --if it is a slash, it indicates a line comment
				state <= linecomment; --go to appropriate line comment state
			else --if the input is anything else, then there is no comment
				state <= notcomment;--return back to not comment state
			end if;

			when linecomment =>
			output <= '1';
			if input = NEW_LINE_CHARACTER then --new line indicates the end of a line comment
				state <= notcomment;
			end if;

			when blockcomment =>
			output <= '1';
			if input = STAR_CHARACTER then --a star whilst inside a block comment may indicate then end of the block comment
				state <= firststar; --go to new state
			end if;

			when firststar =>
			output <= '1';
			if input = SLASH_CHARACTER then --if the next character is a slash, this confirms the end of the block comment
				state <= notcomment; --return to not comment state
			else
				state <= blockcomment; --otherwise, the block comment continues
			end if;

		end case;
	end if;

end process;

end behavioral;