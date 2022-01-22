module sub_test(
input a,b,
output c);//由于c为assign中被赋值的值，于是c应该为wire型
assign c = (a<b)? a : b;
endmodule

module test(
input a,b,c,
output o);
wire temp;//由于temp为被调用模块的输出，必须为wire型
sub_test s0(.a(a),.b(b),.c(temp));//调用模块时，端口信号可以通过位置或名称进行关联，但两种关联方式不能混用。实例化模块应当取名。
sub_test s1(temp,c,o);//同上行
endmodule
00000011-11000000=01000011