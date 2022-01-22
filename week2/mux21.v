module mux21(input a,b,sel,output out);
assign out = (~sel & a) | (sel & b);
endmodule