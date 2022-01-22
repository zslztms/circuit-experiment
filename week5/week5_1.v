module week5_1();
reg a,b;

initial 
begin
    a=1;
    b=0;
    #100 b=1;
    #100 a=0;
    #75 b=0;
    #75 b=1;
    #50 $stop;
end

endmodule