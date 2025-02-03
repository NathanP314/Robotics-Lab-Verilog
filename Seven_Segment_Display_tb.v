`timescale 1ns / 1ps
`include "Seven_Segment_Display.v"
module sevenseg_modded_tb();
    reg clk;
    reg [3:0] number;
    wire [6:0] seg;
    wire [3:0] an;
    
    // Instantiate the module under test
    sevenseg_modded uut (
        .clk(clk),
        .number(number),
        .seg(seg),
        .an(an)
    );
    
    // Clock generation
    always #5 clk = ~clk; // Generate a clock with period of 10 ns
    
    initial begin
        // Initialize signals
        clk = 0;
        number = 4'b0000;
        
        // Dump waveforms to VCD file
        $dumpfile("sevenseg_modded_tb.vcd");
        $dumpvars(0, sevenseg_modded_tb);
        
        // Apply test vectors
        #20 number = 4'b1000; // Expect LEFT segment to be displayed
        #20 number = 4'b0100; // Expect CENTER segment to be displayed
        #20 number = 4'b0010; // Expect RIGHT segment to be displayed
        #20 number = 4'b0001; // Expect OVERCURRENT segment to be displayed
        #20 number = 4'b1111; // Expect all segments to be displayed accordingly
        #20 number = 4'b0000; // Expect default 0 display
        
        // Finish simulation
        #50 $finish;
    end
    
    // Monitor signals
    initial begin
        $monitor("Time = %0t | number = %b | an = %b | seg = %b", $time, number, an, seg);
    end
endmodule