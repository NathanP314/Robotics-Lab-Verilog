module overcurrent(
input OCA, OCB,
input clk,
output reg ENA,
output reg ENB
);

reg oc_delay = 0; // 1 bit for simulation purposes, used to be 18-bits.
reg oc_test = 0;

always @(posedge clk) begin
    if(OCA || OCB) begin
        oc_test = 1;
    end
    if(oc_test) begin
        oc_delay = oc_delay + 1;
        if(oc_delay == 0) begin
            if(OCA || OCB) begin
                ENA = 0; ENB = 0;
            end
            else begin
                ENA=1;ENB=1; // for simulation purposes
                oc_test = 0;
            end
        end
    end
end

endmodule

/*
Verilog tutorial examples

module casemulti(
    input A,B,C,

    output reg [3:0] F
);
always@(*) begin
    case({A,B,C})
        3'b000: begin
            F = 0;
        end
        3'b001: begin
            F = 3;
        end
        3'b010: begin
            F = ;
        end
        3'b011: begin

        end
        3'b100: begin

        end
        3'b101: begin

        end
        3'b110: begin

        end
        3'b111: begin

        end
        default: begin
            // captures all undefined expressions
            F = 4'hF;
        end
    endcase
end
endmodule

----new file----
`timescale 1ns/1ns
`include "casemulti.v"
module casemulti_tb;
    reg A,B,C,
    wire [3:0] F

    casemulti uut(
        .A(A),
        .B(B),
        .C(C),
        .F(F)
    );

    initial begin
        $dumpfile("casemulti_tb.vcd");
        $dumpvars(0,casemulti_tb);

        #100;

        A=0; B=0; C=0; #10;
        A=0; B=0; C=1; #10;
        A=0; B=1; C=0; #10;
        A=0; B=1; C=1; #10;
        A=1; B=0; C=0; #10;
        A=1; B=0; C=1; #10;
        A=1; B=1; C=0; #10;
        A=1; B=1; C=1; #10;



        $finish();
    end
endmodule


TOP LEVEL MODULE
always@(State) for setting outputs
always@(posedge clk) for moving between states


*/
