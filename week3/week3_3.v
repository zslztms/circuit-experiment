module d_ff_asynrst(input d,c,rst_n,output reg q,q_n);
always @(posedge c,negedge rst_n)
begin
    if (rst_n==0){
        q<=0;
        q_n<=1;
    }
    else{
        q<=d;
        q_n<=~d;
    }
end
endmodule

module reg4(input d[0:3],c,rst_n,output q[0:3]);
d_ff_asynrst dff0(d[0],c,rst_n,q[0],);
d_ff_asynrst dff1(d[1],c,rst_n,q[1],);
d_ff_asynrst dff2(d[2],c,rst_n,q[2],);
d_ff_asynrst dff3(d[3],c,rst_n,q[3],);
endmodule

module bit4_count(input c,rst_n,output q[0:3]);
wire q_[0:3];
assign q_=q+4'b0001;
reg4 r0(q_,c,rst_n,q);
endmodule