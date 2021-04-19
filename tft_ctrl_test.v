module tft_ctrl_test(
	clk50M,
	reset_n,

	TFT_rgb,
	TFT_hs,
	TFT_vs,
	TFT_clk,
	TFT_de,
	TFT_pwm,

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

	assign reset=~reset_n;
	input clk50M;   //系统时钟输入，50M
	input reset_n;  //复位信号输入，低有效
	
	output [15:0]TFT_rgb;  //TFT数据输出
	output TFT_hs;   //TFT行同步信号
	output TFT_vs;   //TFT场同步信号
	output TFT_clk;  //TFT像素时钟
	output TFT_de;   //TFT数据使能
	output TFT_pwm;  //TFT背光控制

  //定义颜色编码
	localparam 
    BLACK = 16'h0000, //黑色
    BLUE = 16'h001F, //蓝色
    RED = 16'hF800, //红色
    PURPPLE	= 16'hF81F, //紫色
    GREEN = 16'h07E0, //绿色
    CYAN = 16'h07FF, //青色
    YELLOW	= 16'hFFE0, //黄色
    WHITE = 16'hFFFF; //白色

	
	wire pll_locked;
	wire tft_reset_p;
	wire clk_ctrl;
	reg [15:0]disp_data;
	wire disp_data_req;
	wire [11:0]visible_hcount;
	wire [11:0]visible_vcount;
	wire R0_act;
	wire R1_act;
	wire R2_act;
	wire R3_act; 
	wire C0_act;
	wire C1_act;
	wire R0_C0_act;
	wire R0_C1_act;
	wire R1_C0_act;
	wire R1_C1_act;
	wire R2_C0_act;
	wire R2_C1_act;
	wire R3_C0_act;
	wire R3_C1_act;
	wire [4:0]Disp_Red;
	wire [5:0]Disp_Green;
	wire [4:0]Disp_Blue;
	wire TFT_pwm;
	wire Disp_PCLK;


	assign grid_verti_1 = disp_data_req && (visible_hcount == 266);
	assign grid_verti_2 = disp_data_req && (visible_hcount == 532);
	assign grid_horiz_1 = disp_data_req && (visible_vcount == 160);
	assign grid_horiz_2 = disp_data_req && (visible_vcount == 320);

	wire [1:0] block1;//00 means this area is not picked by anyone, 01 means player1 color this area, 10 means player2 color this area
	wire [1:0] block2;//the same goes for the following area
	wire [1:0] block3;
	wire [1:0] block4;
	wire [1:0] block5;
	wire [1:0] block6;
	wire [1:0] block7;
	wire [1:0] block8;
	wire [1:0] block9;

	assign block1_act = visible_hcount >= 0 && visible_hcount < 266 && visible_vcount >= 0 && visible_vcount < 160;
	assign block1 = (disp_data_req && block1_act)?position_1: 2'b00;
	assign block2_act = visible_hcount >= 267 && visible_hcount < 532 && visible_vcount >= 0 && visible_vcount < 160;
	assign block2 = (disp_data_req && block2_act)?position_2: 2'b00;
	assign block3_act = visible_hcount >= 533 && visible_hcount < 800 && visible_vcount >= 0 && visible_vcount < 160;
	assign block3 = (disp_data_req && block3_act)?position_3: 2'b00;

	assign block4_act = visible_hcount >= 0 && visible_hcount < 266 && visible_vcount >= 161 && visible_vcount < 320;
	assign block4 = (disp_data_req && block4_act)?position_4: 2'b00;
	assign block5_act = visible_hcount >= 267 && visible_hcount < 532 && visible_vcount >= 161 && visible_vcount < 320;
	assign block5 = (disp_data_req && block5_act)?position_5: 2'b00;
	assign block6_act = visible_hcount >= 533 && visible_hcount < 800 && visible_vcount >= 161 && visible_vcount < 320;
	assign block6 = (disp_data_req && block6_act)?position_6: 2'b00;

	assign block7_act = visible_hcount >= 0 && visible_hcount < 266 && visible_vcount >= 321 && visible_vcount < 480;
	assign block7 = (disp_data_req && block7_act)?position_7: 2'b00;
	assign block8_act = visible_hcount >= 267 && visible_hcount < 532 && visible_vcount >= 321 && visible_vcount < 480;
	assign block8 = (disp_data_req && block8_act)?position_8: 2'b00;
	assign block9_act = visible_hcount >= 533 && visible_hcount < 800 && visible_vcount >= 321 && visible_vcount < 480;
	assign block9 = (disp_data_req && block9_act)?position_9: 2'b00;





	assign tft_reset_p = ~pll_locked;
	pll pll// clk_in1 must have set to "Global Buffer" in IP configuration
	(
		// Clock out ports
		.clk_out1(clk_ctrl), // output clk_out1
		// Status and control signals
		.resetn(reset_n), // input reset,active low
		.locked(pll_locked), // output locked
		// Clock in ports
		.clk_in1(clk50M)  // input clk_in1
  );      

	disp_driver disp_driver
	(
		.ClkDisp(clk_ctrl),
		.Rst_p(tft_reset_p),

		.Data(disp_data),
		.DataReq(disp_data_req),

		.H_Addr(visible_hcount),
		.V_Addr(visible_vcount),
                            
		.Disp_HS(TFT_hs),
		.Disp_VS(TFT_vs),
		.Disp_Red(Disp_Red),
		.Disp_Green(Disp_Green),
		.Disp_Blue(Disp_Blue),
		.Frame_Begin(),
                            
		.Disp_DE(TFT_de),
		.Disp_PCLK(Disp_PCLK)
	);
	
	assign TFT_rgb={Disp_Red,Disp_Green,Disp_Blue};
	assign TFT_clk=Disp_PCLK;
	assign TFT_pwm=1'b1;
	


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
