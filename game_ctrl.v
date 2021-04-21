`timescale 1ns / 1ps



module game_ctrl(
    clk, reset_n, key_flag, key_value, illegal_move, move_P1_i, move_P2_i, move_P1, move_P2, over, mode_switch
    );

    input clk, reset_n;
    input key_flag;
    input [3:0] key_value;
    input illegal_move;//input from a low level module
    input over;
    input mode_switch;

    output reg move_P1_i, move_P2_i;
    output reg [3:0] move_P1;
    output reg [3:0] move_P2;//never make illegal move if it's AI player
    
    assign reset = ~reset_n;

    reg expect_player;


    //AI pretending keyboard input
    wire [3:0] key_value_AI;
    wire key_flag_AI;






    always @(posedge clk, posedge reset) begin
        if(reset)
            expect_player <= 0;
        else if(illegal_move)
            expect_player <= ~expect_player;//检测到illegal，回退
        else if(key_flag || key_flag_AI)
            expect_player <= ~expect_player;
        else    
            expect_player <= expect_player;
    end

    reg key_flag_reg;
    reg key_flag_AI_reg;
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            key_flag_reg <= 0;
            key_flag_AI_reg <= 0;
        end
        else begin
            key_flag_reg <= key_flag;
            key_flag_AI_reg <= key_flag_AI;
        end
    end

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            move_P1 <= 4'd0;
            move_P1_i <= 1'b0;
            move_P2 <= 4'd0;
            move_P2_i <= 1'b0;
        end
        else if(!mode_switch) begin//mode = 0, human vs human
            if(key_flag_reg && expect_player) begin
                move_P1_i <= 1'b1;
                move_P1 <= key_value;
            end
            else if(key_flag_reg && ~expect_player) begin
                move_P2_i <= 1'b1;
                move_P2 <= key_value;
            end
            else begin
                move_P1_i <= 0;
                move_P2_i <= 0;
            end
        end
        else if(mode_switch) begin//mode = 1, human vs AI
            if(key_flag_reg && expect_player) begin
                move_P1_i <= 1'b1;
                move_P1 <= key_value;
            end
            else if(key_flag_AI_reg && ~expect_player) begin
                move_P2_i <= 1'b1;
                move_P2 <= key_value_AI;
            end
            else begin
                move_P1_i <= 0;
                move_P2_i <= 0;
            end
        end
        
            
    end






    //AI pretending P2
    reg [8:0] chessboard_human;//if human move, set to 1, otherwise 0
    wire [8:0] chessboard_AI;
    
    reg invalid_human;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            invalid_human <= 0;
            chessboard_human <= 9'b000_000_000;//chessboard_human[8] = position1, chessboard_human[7] = position2, ..., chessboard_human[1] = position8, chessboard_human[0] = position9 
        end
        else if(!mode_switch)
            chessboard_human <= 9'b000_000_000;
        else if(key_flag && !chessboard_AI[9 - key_value] && !chessboard_human[9 - key_value])
            chessboard_human[9 - key_value] <= 1'b1;
        else if(key_flag && (chessboard_AI[9 - key_value] || chessboard_human[9 - key_value]))
            invalid_human <= 1;
        else begin
            invalid_human <= 0;
            chessboard_human <= chessboard_human;
        end
    end

    
    AI_player AI_player_inst(
        .clk(clk),
        .reset_n(reset_n),
        .chessboard_human(chessboard_human),
        .chessboard_AI(chessboard_AI),
        .key_flag_AI(key_flag_AI),
        .key_value_AI(key_value_AI),
        .key_flag(key_flag),
        .over(over),
        .mode_switch(mode_switch)
    );


endmodule
