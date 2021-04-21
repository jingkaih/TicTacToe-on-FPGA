module VGA_driver(
    Clk,    //50MHZ时钟
    Reset_n,
    VGA_RGB,//TFT数据输出
    VGA_HS, //TFT行同步信号
    VGA_VS, //TFT场同步信号
    VGA_BLK,//VGA 场消隐信号
    VGA_CLK,

    position_1,
	position_2,
	position_3,
    position_4,
	position_5,
	position_6,
    position_7,
	position_8,
	position_9



);


	input [1:0] position_1, position_2, position_3,
                position_4, position_5, position_6,
                position_7, position_8, position_9;





	wire disp_data_req;
    input Clk;
    input Reset_n;
    output [23:0]VGA_RGB;
    output VGA_HS;
    output VGA_VS;
    output VGA_BLK;     //VGA 场消隐信号
    output VGA_CLK; 
        
    reg [23:0]disp_data;
    wire [9:0]visible_hcount;
    wire [9:0]visible_vcount;
    wire Clk25M; 
	wire Data_Req;
	
	
	assign VGA_CLK= Clk25M;
	
	pll pll(
        .clk_out1(Clk25M),//able to drive 640*480 pixels screen
        .clk_in1(Clk)
    );      

    VGA_CTRL VGA_CTRL(
        .Clk(Clk25M),    //系统输入时钟25MHZ
        .Reset_n(Reset_n),
        .Data(disp_data),    //待显示数据
		.Data_Req(disp_data_req),
        .hcount(visible_hcount),        //VGA行扫描计数器
        .vcount(visible_vcount),        //VGA场扫描计数器
        .VGA_RGB(VGA_RGB),  //VGA数据输出
        .VGA_HS(VGA_HS),        //VGA行同步信号
        .VGA_VS(VGA_VS),        //VGA场同步信号
        .VGA_BLK(VGA_BLK)      //VGA 场消隐信号
    );
        
//定义颜色编码
localparam 
    BLACK       = 24'h000000, //黑色
    BLUE        = 24'h0000FF, //蓝色
    RED     = 24'hFF0000, //红色
    PURPPLE = 24'hFF00FF, //紫色
    GREEN       = 24'h00FF00, //绿色
    CYAN        = 24'h00FFFF, //青色
    YELLOW  = 24'hFFFF00, //黄色
    WHITE       = 24'hFFFFFF; //白色


	assign grid_verti_1 = disp_data_req && (visible_hcount == 212);
	assign grid_verti_2 = disp_data_req && (visible_hcount == 425);
	assign grid_horiz_1 = disp_data_req && (visible_vcount == 160);
	assign grid_horiz_2 = disp_data_req && (visible_vcount == 320);

	wire [1:0] block1;
	wire [1:0] block2;
	wire [1:0] block3;
	wire [1:0] block4;
	wire [1:0] block5;
	wire [1:0] block6;
	wire [1:0] block7;
	wire [1:0] block8;
	wire [1:0] block9;

	assign block1_act = visible_hcount >= 0 && visible_hcount < 212 && visible_vcount >= 0 && visible_vcount < 160;
	assign block1 = (disp_data_req && block1_act)?position_1: 2'b00;
	assign block2_act = visible_hcount >= 213 && visible_hcount < 425 && visible_vcount >= 0 && visible_vcount < 160;
	assign block2 = (disp_data_req && block2_act)?position_2: 2'b00;
	assign block3_act = visible_hcount >= 426 && visible_hcount < 640 && visible_vcount >= 0 && visible_vcount < 160;
	assign block3 = (disp_data_req && block3_act)?position_3: 2'b00;

	assign block4_act = visible_hcount >= 0 && visible_hcount < 212 && visible_vcount >= 161 && visible_vcount < 320;
	assign block4 = (disp_data_req && block4_act)?position_4: 2'b00;
	assign block5_act = visible_hcount >= 213 && visible_hcount < 425 && visible_vcount >= 161 && visible_vcount < 320;
	assign block5 = (disp_data_req && block5_act)?position_5: 2'b00;
	assign block6_act = visible_hcount >= 426 && visible_hcount < 640 && visible_vcount >= 161 && visible_vcount < 320;
	assign block6 = (disp_data_req && block6_act)?position_6: 2'b00;

	assign block7_act = visible_hcount >= 0 && visible_hcount < 212 && visible_vcount >= 321 && visible_vcount < 480;
	assign block7 = (disp_data_req && block7_act)?position_7: 2'b00;
	assign block8_act = visible_hcount >= 213 && visible_hcount < 425 && visible_vcount >= 321 && visible_vcount < 480;
	assign block8 = (disp_data_req && block8_act)?position_8: 2'b00;
	assign block9_act = visible_hcount >= 426 && visible_hcount < 640 && visible_vcount >= 321 && visible_vcount < 480;
	assign block9 = (disp_data_req && block9_act)?position_9: 2'b00;






	wire [1:0] block_overall;
	assign block_overall = block1 | block2 | block3 | block4 | block5 | block6 | block7 | block8 | block9; 


	always @(*) begin
		if(grid_verti_1 || grid_verti_2 || grid_horiz_1 || grid_horiz_2)
			disp_data = BLACK;
		else if(block_overall == 2'b00)
			disp_data = WHITE;
		else if(block_overall == 2'b01)
			disp_data = YELLOW;
		else if(block_overall == 2'b10)
			disp_data = BLUE;
		else
			disp_data = WHITE;

	end
        
endmodule
