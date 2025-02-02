module sevenseg_modded(
    input clk,                             //REmember high and low is inverted for ts
    input  [3:0] number,                   //an input that is a 4-bit number that denotes whether L,C,R,O is displayed ex) 1000 means L is displayed and the rest are 0
    output reg [6:0] seg = 7'b0101010,     //sets the display to whatever # you want it as
    output reg [3:0] an = 4'b1110          //used to multiplex through each different digit
);

    reg [23:0] counter = 0;
    reg [3:0] digit = 4'b0000;

    always @(posedge clk) begin
        counter = counter + 1;                //Counter counts up for the 23 bit register
        if(counter == 0) begin                //Once the counter fully counts and resets, then an switches
            an = {an[2],an[1],an[0],an[3]};   //This somehow cycles through 1110,1101,1011,0111
        end

        case(an)
            4'b1110: begin
                if (number[0] == 1)begin     //If an0 is 1, then digit is 1, if not digit is 0
                    digit = 4'd1;
                end
            end
            4'b1101: begin
                if (number[1] == 1)begin     //If an1 is 1, then digit is 2, if not digit is 0
                    digit = 4'd2;
                end
            end
            4'b1011: begin
                if (number[2] == 1)begin     //If an2 is 1, then digit is 4, if not digit is 0
                    digit = 4'd4;
                end
            end
            4'b0111: begin
                if (number[3] == 1)begin     //If an3 is 1, then digit is 8, if not digit is 0
                    digit = 4'd8;
                end
            end
        endcase
    end

    always @(*) begin
        case(digit)
        4'd0: seg = 7'b1000000; // to display 0                //For the code 0000, which means everything off
        4'd8: seg = 7'b1000111; // to display LEFT           //For the code 1000 which means left, Decimal is 8
        4'd4: seg = 7'b1000110; // to display CENTER           //For the code 0100 which meants center, Decimal is 4
        4'd2: seg = 7'b0101111; // to display RIGHT             //For the code 0010 which means right, Decimal is 2
        4'd1: seg = 7'b0100011; // to display OVERCURRENT               //For the code 0001 which means overcurrent, Decimal is 1
        default: seg = 7'b1000000; // default display is 0
        endcase
    end
endmodule


// Maybe do it so in the case statement, it first checks the input at the bit wanted ex) for 1110 it checks in[0], if its 1 then it displays overcurrent, if 0 it displays 0