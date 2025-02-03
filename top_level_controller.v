module top_level_controller(
    input L,M,R,clk,
    ENA,ENB,
    output reg OUT1,OUT2,OUT3,OUT4,OUTA,OUTB,
    output reg [2:0] state
);

reg start = 1;
reg [3:0] sevenseg;
reg prevstate = 0;

overcurrent uut(
    
);
IPS_Align uut(
    //
);

always@(posedge clk) begin
    case(state)
        3'b000: begin
            prevstate = 0;
            start = 1;
            if(start) begin
                state = 1;
            end
            else begin
                state = 0;
            end
        end
        3'b001: begin
            prevstate <= 1;
            if((ENA&&ENB) && !(L || R)) begin
                state <= 1;
            end
            else if((ENA&&ENB) && R) begin
                state <= 2;
            end
            else if((ENA&&ENB) && L) begin
                state <= 3;
            end
            else begin
                state <= 4;
            end
        end
        3'b010: begin
            prevstate <= 2;
            if((ENA&&ENB) && !(L || R)) begin
                state <= 1;
            end
            else if((ENA&&ENB) && R) begin
                state <= 2;
            end
            else if((ENA&&ENB) && L) begin
                state <= 3;
            end
            else begin
                state <= 4;
            end
        end
        3'b011: begin
            prevstate <= 3;
            if((ENA&&ENB) && !(L || R)) begin
                state <= 1;
            end
            else if((ENA&&ENB) && R) begin
                state <= 2;
            end
            else if((ENA&&ENB) && L) begin
                state <= 3;
            end
            else begin
                state <= 4;
            end
        end
        3'b100: begin
            if(ENA && ENB) begin
                state <= prevstate;
            end
            else begin
                state <= 4;
            end
        end
    endcase
end

always@(state) begin
    case(state)
        3'b000: begin
            OUTA  <= 0;
            OUTB  <= 0;
            start <= 1;
            sevenseg = 4'b0000;
        end
        3'b001: begin
            OUTA  <= 1;
            OUTB  <= 1;
            OUT1  <= 1;
            OUT2  <= 1;
            OUT3  <= 1;
            OUT4  <= 1;
            sevenseg = 4'b0100;
        end
        3'b010: begin
            OUT1  <= 0;
            OUT2  <= 1;
            OUT3  <= 1;
            OUT4  <= 0;
            if(M && R) begin
                sevenseg = 4'b0110;
            end
            else begin
                sevenseg = 4'b0010;
            end
        end
        3'b011: begin
            OUT1  <= 1;
            OUT2  <= 0;
            OUT3  <= 0;
            OUT4  <= 1;
            if(M && L) begin
                sevenseg = 4'b1100;
            end
            else begin
                sevenseg = 4'b1000;
            end
        end
        3'b100: begin
            OUTA  <= 0;
            OUTB  <= 0;
            sevenseg = 4'b0001;
        end
    endcase
end

endmodule
