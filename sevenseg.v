module sevenseg(
    input clk,
    input [13:0] number,
    output reg [6:0] seg = 7'b0101010, //seg bits are inverted
    output reg [3:0] an = 4'b1110 //inverted logic
);

    reg [23:0] counter = 0;

    always @(posedge clk) begin
        counter = counter + 1;
        if(counter == 0) begin
            an = (an[2],an[1],an[0]);
        end

        case(an)
            4'b1110: begin
                digit = number % 10;
            end
            4'b1101: begin
                digit = number / 10 % 10;
            end
            4'b1011: begin
                digit = number / 100 % 10;
            end
            4'b0111: begin
                digit = number / 1000 % 10;
            end
        endcase
    end

    always @(*) begin
        case(digit)
        4'd0: seg = 7'b1000000;
        4'd1: seg = 7'b1111001;
        4'd2: seg = 7'b0000000;
        4'd3: seg = 7'b0000000;
        4'd4: seg = 7'b0000000;
        4'd5: seg = 7'b0000000;
        4'd6: seg = 7'b0000000;
        4'd7: seg = 7'b0000000;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0000000;
        default: seg = 7'b1010101;
        endcase
    end
endmodule
