module encoder83(input i0,i1,i2,i3,i4,i5,i6,i7,output y0,y1,y2);
assign y2 = i4 | i5 | i6 | i7;
assign y1 = i7 | i6 | (~i7 & ~i6 & ~i5 & ~i4 & (i3 | i2));
assign y0 = i7 | (~i7 & ~i6 & i5) | (~i7 & ~i6 & ~i5 & ~i4 & i3) | (~i7 & ~i6 & ~i5 & ~i4 & ~i3 & ~i2 & i1);
endmodule