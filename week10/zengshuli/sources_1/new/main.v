`timescale 1ns / 1ps


module main(
input run,step,valid,rst,clk,[4:0] in,
output ready,[1:0] check,[2:0] an,[3:0] seg,[4:0]out0
);
wire clk_cpu,io_we;
wire [7:0] io_addr,m_rf_addr;
wire [31:0] io_din,io_dout,rf_data,m_data,pc;

wire [31:0] pcin, pcD, pcE, irD, immE, mdrW, aE, bE, yM, bM, yW, ctrlE, ctrlM, ctrlW;
wire [4:0] rdE, rdM, rdW;

//reduce the clock frequency to 25mhz
wire slowclk;
reg [1:0] count;
always@(posedge clk)
begin
    count<=count+1;
end
assign slowclk=(count==2'b0);

pdu pdu(
slowclk,rst,
//选择CPU工作方式;
run, step,clk_cpu,
//输入switch的端口
valid,in,
//输出led和seg的端口 
check,  //led6-5:查看类型
out0,   //led4-0
an,     //8个数码管
seg,
ready,        //led7
//IO_BUS
io_addr,io_dout,io_we,io_din,
//Debug_BUS
m_rf_addr,rf_data,m_data,

//增加流水线寄存器调试接口
pcin, pc, pcD, pcE,
irD, immE, mdrW,
aE, bE, yM, bM, yW,
rdE, rdM, rdW,
ctrlE, ctrlM, ctrlW    
);

cpu_stream cpu(
clk_cpu, rst,
//IO_BUS
io_addr,      //led和seg的地址
io_dout,     //输出led和seg的数据
io_we,                 //输出led和seg数据时的使能信号
io_din,        //来自sw的输入数据
//Debug_BUS
m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
rf_data,    //从RF读取的数据
m_data,    //从MEM读取的数据
//PC/IF/ID 流水段寄存器
pc,pcD,irD,pcin,
//ID/EX 流水段寄存器
pcE,aE,bE,immE,rdE,ctrlE,//I use separate ctrl signal inside
//EX/MEM 流水段寄存器
yM,bM,rdM,ctrlM,//I use separate ctrl signal inside
//MEM/WB 流水段寄存器
yW,mdrW,rdW,ctrlW//I use separate ctrl signal inside
);
endmodule
