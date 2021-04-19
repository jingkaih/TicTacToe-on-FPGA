`timescale 1ns / 1ps


module tictactoe(
    clk, reset_n, move_P1_i, move_P2_i, move_P1, move_P2, illegal_move, over, winner,
              position_1, position_2, position_3,
              position_4, position_5, position_6,
              position_7, position_8, position_9
    );

    input clk, reset_n;
    input move_P1_i;//P1 just moved, this signal comes at the same time of move_P1 being toggled
    input move_P2_i;
    input [3:0] move_P1;//4-9 encoder
    input [3:0] move_P2;//4-9 encoder

    assign reset = ~reset_n;

    output reg [1:0] position_1, position_2, position_3,
                     position_4, position_5, position_6,
                     position_7, position_8, position_9;

    reg [8:0] occupied;

    output reg illegal_move;
    output reg over;
    output reg [1:0] winner;


    always @(posedge clk, posedge reset) begin
        if(reset)
            position_1 <= 2'b00;
        else if(move_P1 == 4'd1 && !occupied[8])//玩家P1落子position_1
            position_1 <= 2'b01;
        else if(move_P2 == 4'd1 && !occupied[8])//玩家P2落子position_1
            position_1 <= 2'b10;
        else
            position_1 <= position_1;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_2 <= 2'b00;
        else if(move_P1 == 4'd2 && !occupied[7])//玩家P1落子position_2
            position_2 <= 2'b01;
        else if(move_P2 == 4'd2 && !occupied[7])//玩家P2落子position_2
            position_2 <= 2'b10;
        else
            position_2 <= position_2;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_3 <= 2'b00;
        else if(move_P1 == 4'd3 && !occupied[6])//玩家P1落子position_3
            position_3 <= 2'b01;
        else if(move_P2 == 4'd3 && !occupied[6])//玩家P2落子position_3
            position_3 <= 2'b10;
        else
            position_3 <= position_3;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_4 <= 2'b00;
        else if(move_P1 == 4'd4 && !occupied[5])//玩家P1落子position_4
            position_4 <= 2'b01;
        else if(move_P2 == 4'd4 && !occupied[5])//玩家P2落子position_4
            position_4 <= 2'b10;
        else
            position_4 <= position_4;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_5 <= 2'b00;
        else if(move_P1 == 4'd5 && !occupied[4])//玩家P1落子position_5
            position_5 <= 2'b01;
        else if(move_P2 == 4'd5 && !occupied[4])//玩家P2落子position_5
            position_5 <= 2'b10;
        else
            position_5 <= position_5;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_6 <= 2'b00;
        else if(move_P1 == 4'd6 && !occupied[3])//玩家P1落子position_6
            position_6 <= 2'b01;
        else if(move_P2 == 4'd6 && !occupied[3])//玩家P2落子position_6
            position_6 <= 2'b10;
        else
            position_6 <= position_6;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_7 <= 2'b00;
        else if(move_P1 == 4'd7 && !occupied[2])//玩家P1落子position_7
            position_7 <= 2'b01;
        else if(move_P2 == 4'd7 && !occupied[2])//玩家P2落子position_7
            position_7 <= 2'b10;
        else
            position_7 <= position_7;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_8 <= 2'b00;
        else if(move_P1 == 4'd8 && !occupied[1])//玩家P1落子position_8
            position_8 <= 2'b01;
        else if(move_P2 == 4'd8 && !occupied[1])//玩家P2落子position_8
            position_8 <= 2'b10;
        else
            position_8 <= position_8;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            position_9 <= 2'b00;
        else if(move_P1 == 4'd9 && !occupied[0])//玩家P1落子position_9
            position_9 <= 2'b01;
        else if(move_P2 == 4'd9 && !occupied[0])//玩家P2落子position_9
            position_9 <= 2'b10;
        else
            position_9 <= position_9;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            occupied <= 9'b000000000;
        else if(move_P1_i || move_P2_i) begin
            if((move_P1 == 4'd1 || move_P2 == 4'd1) && !occupied[8])
                occupied <= {1'b1, occupied[7:0]};
            else if((move_P1 == 4'd2 || move_P2 == 4'd2) && !occupied[7])
                occupied <= {occupied[8], 1'b1, occupied[6:0]};
            else if((move_P1 == 4'd3 || move_P2 == 4'd3) && !occupied[6])
                occupied <= {occupied[8:7], 1'b1, occupied[5:0]};
            else if((move_P1 == 4'd4 || move_P2 == 4'd4) && !occupied[5])
                occupied <= {occupied[8:6], 1'b1, occupied[4:0]};
            else if((move_P1 == 4'd5 || move_P2 == 4'd5) && !occupied[4])
                occupied <= {occupied[8:5], 1'b1, occupied[3:0]};
            else if((move_P1 == 4'd6 || move_P2 == 4'd6) && !occupied[3])
                occupied <= {occupied[8:4], 1'b1, occupied[2:0]};
            else if((move_P1 == 4'd7 || move_P2 == 4'd7) && !occupied[2])
                occupied <= {occupied[8:3], 1'b1, occupied[1:0]};
            else if((move_P1 == 4'd8 || move_P2 == 4'd8) && !occupied[1])
                occupied <= {occupied[8:2], 1'b1, occupied[0]};
            else if((move_P1 == 4'd9 || move_P2 == 4'd9) && !occupied[0])
                occupied <= {occupied[8:1], 1'b1};
            end
        else
            occupied <= occupied;
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            illegal_move <= 0;
        else if(move_P1_i) begin
            if(move_P1 == 4'd1 && (position_1 == 2'b10 || position_1 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd2 && (position_2 == 2'b10 || position_2 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd3 && (position_3 == 2'b10 || position_3 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd4 && (position_4 == 2'b10 || position_4 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd5 && (position_5 == 2'b10 || position_5 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd6 && (position_6 == 2'b10 || position_6 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd7 && (position_7 == 2'b10 || position_7 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd8 && (position_8 == 2'b10 || position_8 == 2'b01))
                illegal_move <= 1;
            else if(move_P1 == 4'd9 && (position_9 == 2'b10 || position_9 == 2'b01))
                illegal_move <= 1;
        end
        else if(move_P2_i) begin
            if(move_P2 == 4'd1 && (position_1 == 2'b10 || position_1 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd2 && (position_2 == 2'b10 || position_2 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd3 && (position_3 == 2'b10 || position_3 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd4 && (position_4 == 2'b10 || position_4 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd5 && (position_5 == 2'b10 || position_5 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd6 && (position_6 == 2'b10 || position_6 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd7 && (position_7 == 2'b10 || position_7 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd8 && (position_8 == 2'b10 || position_8 == 2'b01))
                illegal_move <= 1;
            else if(move_P2 == 4'd9 && (position_9 == 2'b10 || position_9 == 2'b01))
                illegal_move <= 1;
        end
        else
            illegal_move <= 0;
    end


    always @(*) begin
        if(reset) begin
            over <= 0;
            winner <= 2'b00;
        end
        else begin
            if(position_1 == 2'b01 && position_4 == 2'b01 && position_7 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_2 == 2'b01 && position_5 == 2'b01 && position_8 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_3 == 2'b01 && position_6 == 2'b01 && position_9 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_1 == 2'b01 && position_2 == 2'b01 && position_3 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_4 == 2'b01 && position_5 == 2'b01 && position_6 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_7 == 2'b01 && position_8 == 2'b01 && position_9 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_1 == 2'b01 && position_5 == 2'b01 && position_9 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_3 == 2'b01 && position_5 == 2'b01 && position_7 == 2'b01) begin
                over = 1;
                winner = 2'b01;
            end
            else if(position_1 == 2'b10 && position_4 == 2'b10 && position_7 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
            else if(position_2 == 2'b10 && position_5 == 2'b10 && position_8 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
            else if(position_3 == 2'b10 && position_6 == 2'b10 && position_9 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
            else if(position_1 == 2'b10 && position_2 == 2'b10 && position_3 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
            else if(position_4 == 2'b10 && position_5 == 2'b10 && position_6 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
            else if(position_7 == 2'b10 && position_8 == 2'b10 && position_9 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
            else if(position_1 == 2'b10 && position_5 == 2'b10 && position_9 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
            else if(position_3 == 2'b10 && position_5 == 2'b10 && position_7 == 2'b10) begin
                over = 1;
                winner = 2'b10;
            end
        end
        
    end


endmodule