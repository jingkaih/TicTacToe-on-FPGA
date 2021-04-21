`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module top(
    clk, reset_n, winner, over, keyboard_row_x4_i, keyboard_col_x4_o, 



        VGA_RGB,//TFT数据输出
        VGA_HS, //TFT行同步信号
        VGA_VS, //TFT场同步信号
        VGA_BLK,//VGA 场消隐信号
        VGA_CLK,


        mode_switch
    );
    input mode_switch;//0: human vs human
                      //1. human vs AI


    output wire [23:0] VGA_RGB;//TFT数据输出
    output wire VGA_HS; //TFT行同步信号
    output wire VGA_VS; //TFT场同步信号
    output wire VGA_BLK;//VGA 场消隐信号
    output wire VGA_CLK;


    input clk, reset_n;
    
    input [3:0] keyboard_row_x4_i;

    wire move_P1_i, move_P2_i;

    wire illegal_move;

    wire [3:0] move_P1;
    wire [3:0] move_P2;
    wire key_flag;

    wire [3:0] key_value_keyborad_in;//实际键盘按键输入
    reg [3:0] key_value;//将键盘实际输入map到1~9的期望输入

    always @(*) begin
        case (key_value_keyborad_in)
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
        .move_P2(move_P2),
        .over(over),
        .mode_switch(mode_switch)
    );



    VGA_driver VGA_driver_inst(
        .Clk(clk),
        .Reset_n(reset_n),
        .VGA_RGB(VGA_RGB),//TFT数据输出
        .VGA_HS(VGA_HS), //TFT行同步信号
        .VGA_VS(VGA_VS),//TFT场同步信号
        .VGA_BLK(VGA_BLK),//VGA 场消隐信号
        .VGA_CLK(VGA_CLK),
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
