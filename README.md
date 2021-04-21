# TicTacToe-on-FPGA
This is a TicTacToe game on FPGA. A VGA screen and a matrix keypad are needed to implement.

Two modes:
* Human vs Human
* Human vs Simple AI

By toggling the switch, you can choose which mode to play: To play against your friend or an AI that would probably never lose (neither side will win)

[demo video](https://youtu.be/EIPxszzuzhw)

## PLL is needed
I'm setting the output frequency to 25MHz to drive 640*480 pixels' screen


## Basic Logic of simple AI
At first I was planning to implement a famous Dynamic Programming method called Minimax to find the strategy of how AI is going to move in order to win the Tic Tac Toe game, but in fact this is pretty hard because we aren't able to call recursive function in Verilog or any other HDL like we did in C or Python etc., and the memory consumed will be huge if we store all of the chessboard patterns in advance and then do fetch-evalute-decide like the Python tabulation implementation of Dynamic Programming.

But luckily the game itself is super simple, so will be the AI player. I designed a list of moves with different ranks as well as several patterns that AI needs to memorize so the AI can move according to priority hierarchy and given patterns.

Our AI player will make its decision in only 1 clock cycle.


More details are about to come...
