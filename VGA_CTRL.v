module VGA_CTRL(
    Clk,
    Reset_n,
    Data,
    Data_Req,
    hcount,
    vcount,
    VGA_HS,
    VGA_VS,
    VGA_BLK,
    VGA_RGB
);
    
    input Clk;
    input Reset_n;
    input [23:0]Data;
    output reg Data_Req;
    output reg [9:0]hcount; //当前扫描点的H坐标
    output reg [8:0]vcount; //当前扫描点的V坐标
    output reg VGA_HS;
    output reg VGA_VS; 
    output reg VGA_BLK;
    output reg [23:0]VGA_RGB;//{R[7:0]、G[7:0]、B[7:0]}
    
    localparam Hsync_End = 800;
    localparam HS_End = 96;
    localparam Vsync_End = 525;
    localparam VS_End = 2;
    localparam Hdat_Begin = 144;
    localparam Hdat_End = 784;
    localparam Vdat_Begin =  35;
    localparam Vdat_End = 515;
    
    reg [9:0]hcnt;//行扫描计数器
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        hcnt <= 0;
    else if(hcnt >= Hsync_End -1)
        hcnt <= 0;
    else
        hcnt <= hcnt + 1'b1;
        

    always@(posedge Clk)
        VGA_HS <= (hcnt < HS_End)?0:1;
    
    reg [9:0]vcnt;//场扫描计数器
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        vcnt <= 0;
    else if(hcnt == Hsync_End -1)begin
        if(vcnt >= Vsync_End -1)
            vcnt <= 0;
        else
            vcnt <= vcnt + 1'd1;
    end
    else
        vcnt <= vcnt;
    

    always@(posedge Clk)
        VGA_VS  <= (vcnt < VS_End)?0:1;
        


    always@(posedge Clk)
       Data_Req <= ((hcnt >= Hdat_Begin - 1) && (hcnt < Hdat_End - 1) && (vcnt >= Vdat_Begin) && (vcnt < Vdat_End))?1:0;
    
    always@(posedge Clk)
       VGA_BLK <= Data_Req;     
            

    always@(posedge Clk)
        VGA_RGB <= Data_Req? Data:0;
        
    always@(posedge Clk)
       hcount <= Data_Req? hcnt - Hdat_Begin:0; 

    always@(posedge Clk)
       vcount <= Data_Req? vcnt - Vdat_Begin:0;          
        
endmodule
