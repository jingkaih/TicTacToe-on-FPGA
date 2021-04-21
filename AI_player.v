`timescale 1ns / 1ps

//1.要赢，2.要防守，3.要布局（占中间）
//if(我AI有两连子，且人类没有占用另一子)
//  我落子，并赢下比赛
//else if(某条线上有人类有两连子，且我不曾占用剩下的位置)
//  我落子，防守（虽然仍有可能输）
//else if（中间没被占领）
//  我占了
//else if（人类第一子落子中间）
//  我抢任意角落，之后所有情况都是我的对于2连子的防守，且我必不会输
//else if（某几路仅有我的一子，人类不曾涉足，一般在开局比较常见）
//  if(出现两类共8种L型pattern)：L型的边框，人类在每条边占据了不同时为角的两个位置
//      堵住那个交汇点角落，否则我必输
//  else if(非L型pattern，两类共4种)
//      if（是对边型）
//          抢任意角，必赢
//      else if（是对角型）
//          抢任意边，必不会输
//  else
//      随机pick一个落点
//      
//       







module AI_player(
    clk, reset_n, chessboard_human, chessboard_AI, key_flag_AI, key_value_AI, key_flag, over, mode_switch
    );


    input clk, reset_n;
    input [8:0] chessboard_human;
    input key_flag;
    input over;
    input mode_switch;
    //input illegal_move;
    
    output reg key_flag_AI;
    output reg [3:0] key_value_AI;


    assign reset = ~reset_n;

    output reg [8:0] chessboard_AI;

    //key_flag后一拍，chessboard_human才会变
    //chessboard_human和key_flag_dly1同时变
    //occupied与chessboard_human同时改变
    //occupied计数器first vacant的值在下一个拍才能被使用
    //occupied计数器的值和key_flag_dly2同时变
    reg key_flag_dly1;
    reg key_flag_dly2;
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            key_flag_dly1 <= 0;
            key_flag_dly2 <= 0;
        end
        else begin
            key_flag_dly1 <= key_flag;
            key_flag_dly2 <= key_flag_dly1;
        end
    end







    wire [8:0] occupied;
    assign occupied = chessboard_AI | chessboard_human;

    reg [3:0] first_vacant;

    always @(posedge clk, posedge reset) begin
        if(reset)
            first_vacant <= 0;
        else if(occupied[8] == 0)
            first_vacant <= 1;
        else if(occupied[7] == 0)
            first_vacant <= 2;
        else if(occupied[6] == 0)
            first_vacant <= 3;
        else if(occupied[5] == 0)
            first_vacant <= 4;
        else if(occupied[4] == 0)
            first_vacant <= 5;
        else if(occupied[3] == 0)
            first_vacant <= 6;
        else if(occupied[2] == 0)
            first_vacant <= 7;
        else if(occupied[1] == 0)
            first_vacant <= 8;
        else if(occupied[0] == 0)
            first_vacant <= 9;
        else
            first_vacant <= first_vacant;
    end


//判断逻辑
//I have only one move left to win, human are so stupid
    assign priority1_move1 = (chessboard_AI[7] && chessboard_AI[6] && !chessboard_human[8])//it's wise for me to place at position 1
                          || (chessboard_AI[5] && chessboard_AI[2] && !chessboard_human[8])
                          || (chessboard_AI[4] && chessboard_AI[0] && !chessboard_human[8]);

    assign priority1_move2 = (chessboard_AI[8] && chessboard_AI[6] && !chessboard_human[7])
                          || (chessboard_AI[4] && chessboard_AI[1] && !chessboard_human[7]);

    assign priority1_move3 = (chessboard_AI[8] && chessboard_AI[7] && !chessboard_human[6])
                          || (chessboard_AI[3] && chessboard_AI[0] && !chessboard_human[6])
                          || (chessboard_AI[2] && chessboard_AI[4] && !chessboard_human[6]);

    assign priority1_move4 = (chessboard_AI[3] && chessboard_AI[4] && !chessboard_human[5])
                          || (chessboard_AI[8] && chessboard_AI[2] && !chessboard_human[5]);
    
    assign priority1_move5 = (chessboard_AI[3] && chessboard_AI[5] && !chessboard_human[4])
                          || (chessboard_AI[7] && chessboard_AI[1] && !chessboard_human[4])
                          || (chessboard_AI[8] && chessboard_AI[0] && !chessboard_human[4])
                          || (chessboard_AI[2] && chessboard_AI[6] && !chessboard_human[4]);

    assign priority1_move6 = (chessboard_AI[5] && chessboard_AI[4] && !chessboard_human[3])
                          || (chessboard_AI[6] && chessboard_AI[0] && !chessboard_human[3]);

    assign priority1_move7 = (chessboard_AI[1] && chessboard_AI[0] && !chessboard_human[2])
                          || (chessboard_AI[8] && chessboard_AI[5] && !chessboard_human[2])
                          || (chessboard_AI[6] && chessboard_AI[4] && !chessboard_human[2]);

    assign priority1_move8 = (chessboard_AI[2] && chessboard_AI[0] && !chessboard_human[1])
                          || (chessboard_AI[7] && chessboard_AI[4] && !chessboard_human[1]);

    assign priority1_move9 = (chessboard_AI[2] && chessboard_AI[1] && !chessboard_human[0])
                          || (chessboard_AI[6] && chessboard_AI[3] && !chessboard_human[0])
                          || (chessboard_AI[8] && chessboard_AI[4] && !chessboard_human[0]);

//human are about to win in the next move and I should prevent that
    assign priority2_move1 = (chessboard_human[7] && chessboard_human[6] && !chessboard_AI[8])
                          || (chessboard_human[2] && chessboard_human[5] && !chessboard_AI[8])
                          || (chessboard_human[4] && chessboard_human[0] && !chessboard_AI[8]);

    assign priority2_move2 = (chessboard_human[8] && chessboard_human[6] && !chessboard_AI[7])
                          || (chessboard_human[4] && chessboard_human[1] && !chessboard_AI[7]);

    assign priority2_move3 = (chessboard_human[8] && chessboard_human[7] && !chessboard_AI[6])
                          || (chessboard_human[3] && chessboard_human[0] && !chessboard_AI[6])
                          || (chessboard_human[4] && chessboard_human[2] && !chessboard_AI[6]);
                        
    assign priority2_move4 = (chessboard_human[8] && chessboard_human[2] && !chessboard_AI[5])
                          || (chessboard_human[4] && chessboard_human[3] && !chessboard_AI[5]);

    assign priority2_move5 = (chessboard_human[5] && chessboard_human[3] && !chessboard_AI[4])
                          || (chessboard_human[7] && chessboard_human[1] && !chessboard_AI[4])
                          || (chessboard_human[8] && chessboard_human[0] && !chessboard_AI[4])
                          || (chessboard_human[6] && chessboard_human[2] && !chessboard_AI[4]);

    assign priority2_move6 = (chessboard_human[4] && chessboard_human[5] && !chessboard_AI[3])
                          || (chessboard_human[6] && chessboard_human[0] && !chessboard_AI[3]);

    assign priority2_move7 = (chessboard_human[0] && chessboard_human[1] && !chessboard_AI[2])
                          || (chessboard_human[8] && chessboard_human[5] && !chessboard_AI[2])
                          || (chessboard_human[4] && chessboard_human[6] && !chessboard_AI[2]);

    assign priority2_move8 = (chessboard_human[2] && chessboard_human[0] && !chessboard_AI[1])
                          || (chessboard_human[7] && chessboard_human[4] && !chessboard_AI[1]);

    assign priority2_move9 = (chessboard_human[2] && chessboard_human[1] && !chessboard_AI[0])
                          || (chessboard_human[6] && chessboard_human[3] && !chessboard_AI[0])
                          || (chessboard_human[8] && chessboard_human[4] && !chessboard_AI[0]);


//中间>四角>四边，如果人类第一手不是中间，我就抢中间
    assign priority3_move_midpoint = (!chessboard_human[4] && !chessboard_AI[4]);

//人类第一手落子是中间，我抢角落
    assign priority4_move_corner = (chessboard_human == 9'b000_010_000);

//当我占据了中心点时，有如下12种开局方式
//两类8种L型开局
    assign priority5_move_7_human_1_8 = (chessboard_human == 9'b100_000_010 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_1_human_3_4 = (chessboard_human == 9'b001_100_000 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_3_human_2_9 = (chessboard_human == 9'b010_000_001 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_9_human_6_7 = (chessboard_human == 9'b000_001_100 && chessboard_AI == 9'b000_010_000);

    assign priority5_move_1_human_4_8 = (chessboard_human == 9'b000_100_010 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_3_human_2_4 = (chessboard_human == 9'b010_100_000 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_9_human_2_6 = (chessboard_human == 9'b010_001_000 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_7_human_6_8 = (chessboard_human == 9'b000_001_010 && chessboard_AI == 9'b000_010_000);

//两类4种非L型开局
    assign priority5_move_corner_human_2_8 = (chessboard_human == 9'b010_000_010 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_corner_human_4_6 = (chessboard_human == 9'b000_101_000 && chessboard_AI == 9'b000_010_000);

    assign priority5_move_edge_human_1_9 = (chessboard_human == 9'b100_000_001 && chessboard_AI == 9'b000_010_000);
    assign priority5_move_edge_human_3_7 = (chessboard_human == 9'b001_000_100 && chessboard_AI == 9'b000_010_000);


    always @(posedge clk, posedge reset) begin
        if(reset) begin
            chessboard_AI <= 9'b000_000_000;
            key_flag_AI <= 0;
            key_value_AI <= 4'h0;
        end
        else if(!mode_switch) begin//when human vs human
            chessboard_AI <= 9'b000_000_000;
            key_flag_AI <= 0;
            key_value_AI <= 4'h0;
        end
        else if(key_flag_dly2 && !over) begin
            if(priority1_move1) begin
                chessboard_AI <= {1'b1, chessboard_AI[7:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h1;
            end
            else if(priority1_move2) begin
                chessboard_AI <= {chessboard_AI[8], 1'b1, chessboard_AI[6:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h2;
            end
            else if(priority1_move3) begin
                chessboard_AI <= {chessboard_AI[8:7], 1'b1, chessboard_AI[5:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h3;
            end
            else if(priority1_move4) begin
                chessboard_AI <= {chessboard_AI[8:6], 1'b1, chessboard_AI[4:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h4;
            end
            else if(priority1_move5) begin
                chessboard_AI <= {chessboard_AI[8:5], 1'b1, chessboard_AI[3:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h5;
            end
            else if(priority1_move6) begin
                chessboard_AI <= {chessboard_AI[8:4], 1'b1, chessboard_AI[2:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h6;
            end
            else if(priority1_move7) begin
                chessboard_AI <= {chessboard_AI[8:3], 1'b1, chessboard_AI[1:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h7;
            end
            else if(priority1_move8) begin
                chessboard_AI <= {chessboard_AI[8:2], 1'b1, chessboard_AI[0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h8;
            end
            else if(priority1_move9) begin
                chessboard_AI <= {chessboard_AI[8:1], 1'b1};
                key_flag_AI <= 1;
                key_value_AI <= 4'h9;
            end
            ///////////////////////////////
            //当人类玩家连两子，AI只好去堵
            ///////////////////////////////
            else if(priority2_move1) begin
                chessboard_AI <= {1'b1, chessboard_AI[7:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h1;
            end
            else if(priority2_move2) begin
                chessboard_AI <= {chessboard_AI[8], 1'b1, chessboard_AI[6:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h2;
            end
            else if(priority2_move3) begin
                chessboard_AI <= {chessboard_AI[8:7], 1'b1, chessboard_AI[5:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h3;
            end
            else if(priority2_move4) begin
                chessboard_AI <= {chessboard_AI[8:6], 1'b1, chessboard_AI[4:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h4;
            end
            else if(priority2_move5) begin
                chessboard_AI <= {chessboard_AI[8:5], 1'b1, chessboard_AI[3:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h5;
            end
            else if(priority2_move6) begin
                chessboard_AI <= {chessboard_AI[8:4], 1'b1, chessboard_AI[2:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h6;
            end
            else if(priority2_move7) begin
                chessboard_AI <= {chessboard_AI[8:3], 1'b1, chessboard_AI[1:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h7;
            end
            else if(priority2_move8) begin
                chessboard_AI <= {chessboard_AI[8:2], 1'b1, chessboard_AI[0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h8;
            end
            else if(priority2_move9) begin
                chessboard_AI <= {chessboard_AI[8:1], 1'b1};
                key_flag_AI <= 1;
                key_value_AI <= 4'h9;
            end
            ////////////////////////
            //抢占中心点，最佳守势
            //我可能不会赢，但我一定不会输
            ////////////////////////
            else if(priority3_move_midpoint) begin
                chessboard_AI <= {chessboard_AI[8:5], 1'b1, chessboard_AI[3:0]};
                key_flag_AI <= 1;
                key_value_AI <= 4'h5;
            end
            /////////////////////
            //中心点被抢了，夺取9号位角落（能随机不？？？？）
            /////////////////////
            else if(priority4_move_corner) begin
                chessboard_AI <= 9'b000_000_001;
                key_flag_AI <= 1;
                key_value_AI <= 4'h9;
            end
            //
            /////////////////////
            //我夺了中心点后，人类第二子落位可能导致的几种（未构成二连子的）开局情况
            /////////////////////
            else begin
                ////////////////////
                // L型pattern
                ////////////////////
                if(priority5_move_7_human_1_8 || priority5_move_7_human_6_8) begin
                    chessboard_AI <= {chessboard_AI[8:3], 1'b1, chessboard_AI[1:0]};
                    key_flag_AI <= 1;
                    key_value_AI <= 4'h7;
                end
                else if(priority5_move_1_human_3_4 || priority5_move_1_human_4_8) begin
                    chessboard_AI <= {1'b1, chessboard_AI[7:0]};
                    key_flag_AI <= 1;
                    key_value_AI <= 4'h1;
                end
                else if(priority5_move_3_human_2_9 || priority5_move_3_human_2_4) begin
                    chessboard_AI <= {chessboard_AI[8:7], 1'b1, chessboard_AI[5:0]};
                    key_flag_AI <= 1;
                    key_value_AI <= 4'h3;
                end
                else if(priority5_move_9_human_6_7 || priority5_move_9_human_2_6) begin
                    chessboard_AI <= {chessboard_AI[8:1], 1'b1};
                    key_flag_AI <= 1;
                    key_value_AI <= 4'h9;
                end
                ////////////////////
                //非L型pattern
                ////////////////////
                else if(priority5_move_corner_human_2_8 || priority5_move_corner_human_4_6) begin
                    chessboard_AI <= {chessboard_AI[8:1], 1'b1};
                    key_flag_AI <= 1;
                    key_value_AI <= 4'h9;
                end
                else if(priority5_move_edge_human_1_9 || priority5_move_edge_human_3_7) begin
                    chessboard_AI <= {chessboard_AI[8], 1'b1, chessboard_AI[6:0]};
                    key_flag_AI <= 1;
                    key_value_AI <= 4'h2;//夺边
                end


                //必平局的残局垃圾时间，随机即可
                //放心吧随机不了的，只能选1~9中的第一个空位
                else begin
                    chessboard_AI[9 - first_vacant] <= 1'b1;
                    key_flag_AI <= 1;
                    key_value_AI <= first_vacant;
                end
            end

        end


        else begin
            key_flag_AI <= 0;
        end
    end

endmodule







