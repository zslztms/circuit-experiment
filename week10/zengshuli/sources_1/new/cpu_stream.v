`timescale 1ns / 1ps

module mux21 #(parameter WIDTH=32) (
input control,
input [WIDTH-1:0] in1, in0,
output [WIDTH-1:0] out
);
assign out = control? in1:in0;
endmodule

module mux31 #(parameter WIDTH=32) (//be careful ALL mux31 CONTROL SIGNAL should be DEFINED AS 2-BITS !!!
input [1:0] control,
input [WIDTH-1:0] in2, in1, in0,
output reg [WIDTH-1:0] out
);
always@(*)
begin
    case(control)
        2'b00:out=in0;
        2'b01:out=in1;
        2'b10:out=in2;
        default:out=0;
    endcase
end
endmodule

module control(
input [6:0] opcode,[2:0] funct,
output reg jump,branch,blt,memwrite,regwrite,rs1ctrl,rs2ctrl,
output reg [1:0] regwrsrc,
output reg [2:0] aluop
);
always@(*)
begin
    case(opcode)
        7'b0110011:
        begin
            case(funct)
                3'b000:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000000000;//add
                3'b001:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000000101;//sll
                3'b100:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000000100;//xor
                3'b101:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000000110;//srl
                default:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b00000000000;
            endcase
        end
        7'b0010011:
        begin
            case(funct)
                3'b000:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000001000;//addi
                3'b001:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000001101;//slli
                3'b101:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000001110;//srli
                3'b111:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10000001010;//andi
                default:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b00000000000;
            endcase
        end
        7'b0000011:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b10100001000;//lw
        7'b0100011:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b00010001000;//sw
        7'b1101111:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b11001011000;//jal
        7'b1100011:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b00000111000;//beq,blt
        default:{regwrite,regwrsrc,memwrite,jump,branch,rs1ctrl,rs2ctrl,aluop}=11'b00000000000;
    endcase
    blt = {opcode,funct}==10'b1100011100;
end
endmodule

module immgencontrol(input [31:0] instruct,output reg [31:0] imm);
always@(*)
begin
    if((instruct[6:0]==7'b0010011)|(instruct[6:0]==7'b0000011))//addi,slli,srli,andi,lw
    begin
        imm[11:0]=instruct[31:20];
        imm[31:12]=instruct[31] ? 20'b1111_1111_1111_1111_1111 : 20'b0;
    end
    else if(instruct[6:0]==7'b0100011)//sw
    begin
        imm[11:5]=instruct[31:25];
        imm[4:0]=instruct[11:7];
        imm[31:12]=instruct[31] ? 20'b1111_1111_1111_1111_1111 : 20'b0;
    end
    else if(instruct[6:0]==7'b1101111)//jal
    begin
        imm[20]=instruct[31];
        imm[10:1]=instruct[30:21];
        imm[11]=instruct[20];
        imm[19:12]=instruct[19:12];
        imm[31:21]=instruct[31] ? 11'b111_1111_1111 : 11'b0;
        imm[0]=1'b0;
    end
    else if(instruct[6:0]==7'b1100011)//beq,blt
    begin
        imm[12]=instruct[31];
        imm[10:5]=instruct[30:25];
        imm[4:1]=instruct[11:8];
        imm[11]=instruct[7];
        imm[31:13]=instruct[31] ? 19'b111_1111_1111_1111_1111 : 19'b0;
        imm[0]=1'b0;
    end
    else imm=32'b0;//others
end
endmodule






module cpu_stream(
input clk, 
input rst,

//IO_BUS
output [7:0] io_addr,      //led和seg的地址
output [31:0] io_dout,     //输出led和seg的数据
output io_we,                 //输出led和seg数据时的使能信号
input [31:0] io_din,        //来自sw的输入数据

//Debug_BUS
input [7:0] m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
output [31:0] rf_data,    //从RF读取的数据
output [31:0] m_data,    //从MEM读取的数据

//PC/IF/ID 流水段寄存器
output reg [31:0] pc,
output reg [31:0] pcD,
output reg [31:0] irD,
output [31:0] pcin,

//ID/EX 流水段寄存器
output reg [31:0] pcE,
output reg [31:0] aE,
output reg [31:0] bE,
output reg [31:0] immE,
output [4:0] rdE,
output [31:0] ctrlE,//I use separate ctrl signal inside

//EX/MEM 流水段寄存器
output reg [31:0] yM,
output [31:0] bM,
output [4:0] rdM,
output reg [31:0] ctrlM,//I use separate ctrl signal inside

//MEM/WB 流水段寄存器
output reg [31:0] yW,
output reg [31:0] mdrW,
output [4:0] rdW,
output reg [31:0] ctrlW//I use separate ctrl signal inside
);
//other if id reg
reg [31:0] npcD;
//other id ex reg
reg regwriteE,memwriteE,jumpE,branchE,bltE,rs1ctrlE,rs2ctrlE;
reg [1:0] regwrsrcE;
reg [2:0] aluopE;
reg [31:0] irE,npcE;
//other ex mem reg
reg regwriteM,memwriteM;
reg [1:0] regwrsrcM;
reg [31:0] rs2_r_fM,irM,npcM;
//other mem wb reg
reg regwriteW;
reg [1:0] regwrsrcW;
reg [31:0] npcW,irW;


wire pc_if_id_en,if_id_flush,id_ex_flush;
wire [1:0] frs1,frs2;//hazard & forward unit output
wire comp;
wire [31:0] instruct,imm,reginput,rd1,rd2,rs1_r_f,rs2_r_f,rs1,rs2,y,io_addr_inner,mdr,dm_and_din;
wire regwrite,memwrite,jump,branch,blt,rs1ctrl,rs2ctrl;
wire [1:0] regwrsrc;
wire [2:0] aluop; 

assign rdE=irE[11:7];
assign bM=rs2_r_fM;
assign rdM=irM[11:7];
assign rdW=irW[11:7];

//handle 32bit ctrl reg: init at ex then pass along
assign ctrlE={~pc_if_id_en,~pc_if_id_en,if_id_flush,id_ex_flush,2'b00,frs1,2'b00,frs2,1'b0,regwriteE,regwrsrcE,
2'b00,irE[6:0]==7'b0000011,memwriteE,2'b00,jumpE,branchE,2'b00,rs1ctrlE,rs2ctrlE,1'b0,aluopE};
always@(posedge clk)
begin
    ctrlM<=ctrlE; ctrlW<=ctrlM;
end

//if
initial begin
    pc=32'b11000000000000;
end
mux21 #(32) mux21_pc(jumpE | (branchE & comp),y,pc+4,pcin);
always@(posedge clk)
begin
    if (pc_if_id_en==1) pc<=pcin;
end
instructmem imem(pc[31:2],32'b0,clk,1'b0,instruct);//注意这里输入pc要从第三位开始
//if-id
always@(posedge clk)
begin
    if (if_id_flush==1) 
    begin
        npcD<=32'b0; pcD<=32'b0; irD<=32'b0;
    end
    else if (pc_if_id_en==1)
    begin
        npcD<=pc+4; pcD<=pc; irD<=instruct;
    end
end
//id (be aware that INPUTS ALL COMES FROM IF/ID REG or other stream regs)
control control(irD[6:0],irD[14:12],jump,branch,blt,memwrite,regwrite,rs1ctrl,rs2ctrl,regwrsrc,aluop);
immgencontrol igc(irD,imm);
regfile_writefirst rf(clk,regwriteW,irW[11:7],irD[19:15],irD[24:20],m_rf_addr[4:0],reginput,rd1,rd2,rf_data[31:0]);
//id-ex
always@(posedge clk)
begin
    if (id_ex_flush==1)
    begin
        {regwriteE,regwrsrcE,memwriteE,jumpE,branchE,bltE,rs1ctrlE,rs2ctrlE,aluopE,irE,npcE,pcE,aE,bE,immE}<=0;
    end
    else
    begin
        regwriteE<=regwrite; regwrsrcE<=regwrsrc; memwriteE<=memwrite; jumpE<=jump; 
        branchE<=branch; bltE<=blt; rs1ctrlE<=rs1ctrl; rs2ctrlE<=rs2ctrl; aluopE<=aluop;
        irE<=irD; npcE<=npcD; pcE<=pcD; aE<=rd1; bE<=rd2; immE<=imm;
    end
end
//ex (be aware that INPUTS ALL COMES FROM ID/EX REG or other stream regs)
mux31 #(32) mux31_rs1(frs1,reginput,yM,aE,rs1_r_f);
mux31 #(32) mux31_rs2(frs2,reginput,yM,bE,rs2_r_f);
mux21 #(32) mux21_rs1(rs1ctrlE,pcE,rs1_r_f,rs1);
mux21 #(32) mux21_rs2(rs2ctrlE,immE,rs2_r_f,rs2);
alu #(32) alu(rs1,rs2,aluopE,y);
assign comp = bltE ? (rs1_r_f<rs2_r_f) : (rs1_r_f==rs2_r_f);
//ex-mem
always@(posedge clk)
begin
    regwriteM<=regwriteE; regwrsrcM<=regwrsrcE; memwriteM<=memwriteE; npcM<=npcE; yM<=y; rs2_r_fM<=rs2_r_f; irM<=irE;
end
//mem
assign io_addr_inner=yM;
datamem dm(yM[31:2],rs2_r_fM,m_rf_addr,clk,(memwriteM & ~io_addr_inner[10]),mdr,m_data);//注意这里输入y要从第三位开始
mux21 #(32) mux21_dmout(io_addr_inner[10],io_din,mdr,dm_and_din);
//mem-wb
always@(posedge clk)
begin
    regwriteW<=regwriteM; regwrsrcW<=regwrsrcM; npcW<=npcM; yW<=yM; mdrW<=dm_and_din; irW<=irM;
end
//wb
mux31 #(32) mux31_wb(regwrsrcW,npcW,mdrW,yW,reginput);

//forward & hazard unit
forwardunit funit(regwriteW,regwriteM,irE[19:15],irE[24:20],irW[11:7],irM[11:7],frs1,frs2);
hazardunit hunit(comp,irE[11:7],irD[19:15],irD[24:20],irE[6:0],pc_if_id_en,if_id_flush,id_ex_flush);


//io: don't miss a single io
assign io_we = io_addr_inner[10] & memwriteM;
assign io_addr=io_addr_inner[7:0];
assign io_dout=rs2_r_fM;

endmodule
