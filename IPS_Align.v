module IPS_Align (
input M,L,R, clk,
output reg IN1,IN2,IN3,IN4
);
    always @ (posedge clk) begin
        case ({L,M,R})
            3'b100:
            begin
                IN1 = 1; IN3 = 0; // left turn
            end
            3'b001:
            begin
                IN1 = 0; IN3 = 1; // right turn
            end
            3'b010:
            begin
                IN1 = 1; IN3 = 1; // straight
            end
            3'b111:
            begin
                IN1 = 1; IN3 = 1; // straight
            end
            3'b110:
            begin
                IN1 = 1; IN3 = 0; // left turn
            end
            3'b011:
            begin
                IN1 = 0; IN3 = 1; // right turn
            end
            3'b101:
            begin
                IN1 = 0; IN3 = 0; // reverse
            end
            3'b000:
            begin
                IN1 = 0; IN3 = 0; // reverse
            end
            default:
            begin
                IN1 = 1; IN3 = 1;
            end
        endcase
        IN2 = ~IN1;
        IN4=~IN3;
    end
endmodule
