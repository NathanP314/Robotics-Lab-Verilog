`timescale 1ns/1ns
`include "top_level_controller.v"
module top_level_controller_tb();

reg L,M,R,clk,ENA,ENB;
wire [3:0] sevenseg;
wire OUT1,OUT2,OUT3,OUT4,OUTA,OUTB;
reg [2:0] state;

// top_level_controller uut(
//     .L(L),.M(M),.R(R),.ENA(ENA),.ENB(ENB),
//     .OUT1(OUT1),.OUT2(OUT2),
//     .OUT3(OUT3),.OUT4(OUT4),
//     .state(state)
// );

integer i;

initial begin

    #50;

    $dumpfile("top_tb0.vcd");
    $dumpvars(0,top_level_controller_tb);

    {L,M,R,clk,ENA,ENB, i} = 0;

    state = 0; #50;

    state = 1; #50;

    state = 2; #50;

    state = 3; #50;

    state = 4; #50;

    state = 0; #50;

    state = 4; #50;

    state = 1; #50;

    state = 4; #50;

    state = 2; #50;

    state = 4; #50;

    state = 3; #50;

    state = 2; #50;

    state = 1; #50;

    state = 3; #50;

    state = 1; #50;

    state = 4; #50;

    $finish();
end

always@(negedge clk) begin
    for(i = 0; i < 8; i = i + 1) begin
        {L,M,R} = i;
        #10;
    end
end

always begin
    ENA = ~ENA;
    ENB = ~ENB;
    #30;
end

always begin clk = ~clk; #5; end

endmodule
