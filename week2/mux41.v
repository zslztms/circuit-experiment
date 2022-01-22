`include "mux21.v"
module mux41(input a,b,c,d,sel0,sel1,output out);
wire s00,s01;
mux21 m0(a,b,sel0,s00);
mux21 m1(c,d,sel0,s01);
mux21 m2(s00,s01,sel1,out);
endmodule