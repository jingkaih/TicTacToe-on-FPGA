`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module top(
    clk, reset_n, winner, over, keyboard_row_x4_i, keyboard_col_x4_o, 
        TFT_rgb,
        TFT_hs,
        TFT_vs,
        TFT_clk,
        TFT_de,
        TFT_pwm
    );


	output wire [15:0]TFT_rgb;  //TFT数据输出
	output wire TFT_hs;   //TFT行同步信号
	output wire TFT_vs;   //TFT场同步信号
	output wire TFT_clk;  //TFT像素时钟
	output wire TFT_de;   //TFT数据使能
	output wire TFT_pwm;  //TFT背光控制



    input clk, reset_n;
    
    input [3:0] keyboard_row_x4_i;

    wire move_P1_i, move_P2_i;

    wire illegal_move;

    wire [3:0] move_P1;
    wire [3:0] move_P2;
    wire key_flag;

    wire [3:0] key_value_keyborad_in;
    reg [3:0] key_value;

    always @(*) begin
        case (key_value_keyborad_in)
            // 4'h0: key_value = 4'h1;
            // 4'h1: key_value = 4'h2;
            // 4'h2: key_value = 4'h3;
            // 4'h4: key_value = 4'h4;
            // 4'h5: key_value = 4'h5;
            // 4'h6: key_value = 4'h6;
            // 4'h8: key_value = 4'h7;
            // 4'h9: key_value = 4'h8;
            // 4'ha: key_value = 4'h9;
            // default: key_value = 4'h0;
            4'hf: key_value = 4'h1;
            4'he: key_value = 4'h2;
            4'hd: key_value = 4'h3;
            4'hb: key_value = 4'h4;
            4'ha: key_value = 4'h5;
            4'h9: key_value = 4'h6;
            4'h7: key_value = 4'h7;
            4'h6: key_value = 4'h8;
            4'h5: key_value = 4'h9;
            default: key_value = 4'h0;
        endcase
    end

    wire [1:0] position_1, position_2, position_3,
               position_4, position_5, position_6,
               position_7, position_8, position_9;
    
    
    output wire over;
    output wire [1:0] winner;
    output wire [3:0] keyboard_col_x4_o;

    tictactoe tictactoe_inst(
        .clk(clk),
        .reset_n(reset_n),
        .move_P1_i(move_P1_i),
        .move_P2_i(move_P2_i),
        .move_P1(move_P1),
        .move_P2(move_P2),
        .illegal_move(illegal_move),
        .over(over),
        .winner(winner),
        .position_1(position_1),
        .position_2(position_2),
        .position_3(position_3),
        .position_4(position_4),
        .position_5(position_5),
        .position_6(position_6),
        .position_7(position_7),
        .position_8(position_8),
        .position_9(position_9)
    );

    keyboard_driver keyboard_driver_inst(
        .clk(clk),
        .reset_n(reset_n),

        .keyboard_row_x4_i(keyboard_row_x4_i),
        .keyboard_col_x4_o(keyboard_col_x4_o),

        .key_flag(key_flag),
        .key_value(key_value_keyborad_in)
    );

    game_ctrl game_ctrl_inst(
        .clk(clk),
        .reset_n(reset_n),
        .key_flag(key_flag),
        .key_value(key_value),
        .illegal_move(illegal_move),
        .move_P1_i(move_P1_i),
        .move_P2_i(move_P2_i),
        .move_P1(move_P1),
        .move_P2(move_P2)
    );

    tft_ctrl_test tft_ctrl_test_inst(
        .clk50M(clk),
        .reset_n(reset_n),

        .TFT_rgb(TFT_rgb),
        .TFT_hs(TFT_hs),
        .TFT_vs(TFT_vs),
        .TFT_clk(TFT_clk),
        .TFT_de(TFT_de),
        .TFT_pwm(TFT_pwm),

        .position_1(position_1),
        .position_2(position_2),
        .position_3(position_3),
        .position_4(position_4),
        .position_5(position_5),
        .position_6(position_6),
        .position_7(position_7),
        .position_8(position_8),
        .position_9(position_9)
    );

endmodule
