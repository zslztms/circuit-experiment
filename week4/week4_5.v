module sub_test(
input a,b,//括号内应该包括input与output的所有端口
output o);//同上
assign o = a + b;
endmodule

module test(
input a,b,
output c);
sub_test sub_test(a,b,c);//always内被赋值的变量必须是reg型，而c为wire型，则不能放在always内
endmodule