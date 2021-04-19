`timescale 1ns / 1ps



module game_ctrl(
    clk, reset_n, key_flag, key_value, illegal_move, move_P1_i, move_P2_i, move_P1, move_P2
    );

    input clk, reset_n;
    input key_flag;
    input [3:0] key_value;
    input illegal_move;
    output reg move_P1_i, move_P2_i;
    output reg [3:0] move_P1;
    output reg [3:0] move_P2;
    
    assign reset = ~reset_n;

    reg expect_player;

    always @(posedge clk, posedge reset) begin
        if(reset)
            expect_player <= 0;
        else if(illegal_move)
            expect_player <= ~expect_player;//检测到illegal，回退
        else if(key_flag)
            expect_player <= ~expect_player;
        else    
            expect_player <= expect_player;
    end

    reg key_flag_reg;
    always @(posedge clk, posedge reset) begin
        if(reset)
            key_flag_reg <= 0;
        else
            key_flag_reg <= key_flag;
    end

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            move_P1 <= 4'd0;
            move_P1_i <= 1'b0;
            move_P2 <= 4'd0;
            move_P2_i <= 1'b0;
        end
        else if(key_flag_reg && expect_player) begin
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

endmodule
