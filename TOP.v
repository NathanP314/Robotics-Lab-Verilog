`include "IPS_Align.v"
`include "updated_Emitter.v"
`include "updated_top_emitter.v"
`include "PWM.v"
module TOP(
    input clk,
    input GO,
    input signal,
    input L,
    input M,
    input R,
    input Oin,
    output wire signalOut,
    output wire ENA,ENB,
    output wire IN1,IN2,IN3,IN4,
    output reg [3:0] state,
    output wire [1:0] first_intersection,
    output wire [2:0] count,
    output wire lift,
    output wire CLAWOUT
);
wire oneK;
wire twoK;
wire threeK;
wire O;
reg P_in;
reg D_in;
wire D;
wire P;
reg [1:0] freq_sel;
reg REV;
reg T;
wire rev;
wire lastL;
reg [13:0] liftDuty;
reg [2:0] final_intersection;
reg [2:0] prev_state;

parameter [3:0] REC = 4'b0000;
parameter [3:0] LINE_T = 4'b0001;
parameter [3:0] RIGHT = 4'b0010;
parameter [3:0] LINE_NOTT = 4'b0011;
parameter [3:0] REVERSE = 4'b0100;
parameter [3:0] PICKUP = 4'b0101;
parameter [3:0] DROP = 4'b0110;
parameter [3:0] STOP_P = 4'b0111;
parameter [3:0] STOP_D = 4'b1000;
parameter [3:0] STOP_E = 4'b1001;

PWM Lift(
    .clk(clk),
    .duty(liftDuty),
    .drive(lift),
    .last(lastL)
); 

Servo_PWM claw(
    .clk(clk),
    .P_in(P_in),
    .D_in(D_in),
    .D(D),
    .P(P),
    .CLAWOUT(CLAWOUT)
);

top_emitter Emit(
    .clk(clk),
    .freq_sel(freq_sel),
    .signalOut(signalOut)
);

box_detection box(
    .O(O),
    .Oin(Oin)
);

Frequency_Counter freq(
    .signal(signal),
    .clk(clk),
    .first_intersection(first_intersection),
    .oneK(oneK),
    .twoK(twoK),
    .threeK(threeK)
);

IPS_Align lineFollow(
    .clk(clk),
    .M(M),
    .L(L),
    .R(R),
    .REV(REV),
    .T(T),
    .ENA(ENA), // high means right
    .ENB(ENB), // high means left
    .count(count),
    .rev(rev),
    .IN1(IN1),
    .IN2(IN2),
    .IN3(IN3),
    .IN4(IN4)
);

initial begin
    {T, REV, P_in, D_in, freq_sel} = 0;
    final_intersection = 6;
    state <= 0;
    prev_state <= 0;
end


always@(posedge clk) begin
    case(state)
        REC: begin
            if(GO) begin
                if(oneK && !twoK && !threeK) begin
                    T <= 1;
                    state <= LINE_T;
                end
                else if(!oneK && twoK && !threeK) begin
                    T <= 1;
                    state <= LINE_T;
                end
                else if(!oneK && !twoK && threeK) begin
                    T <= 1;
                    state <= LINE_T;
                end
            end
            prev_state <= state;
        end
        LINE_T: begin
            if((count == first_intersection)) begin
                T <= 0;
                state <= LINE_NOTT;
            end
            else if(count == first_intersection + 1) begin
                T <= 0;
                state <= LINE_NOTT;
            end
            else if(O && !D) begin
                REV <= 1;
                T <= 1;
                state <= STOP_D;
            end
            else if((count >= final_intersection)) begin
                T <= 0;
                state <= LINE_NOTT;
            end
            prev_state <= state;
        end
        LINE_NOTT: begin
            if(O && !P)begin
                REV <= 1;
                T <= 1;
                state <= STOP_P;
            end
            else if(O && D) begin
                REV <= 1;
                T <= 1;
                state <= STOP_E;
            end
            else if((count == first_intersection + 1) && !(L&&M&&R) && !(M&&R)) begin
                REV <= 0;
                T <= 1;
                state <= LINE_T;
            end
            prev_state <= state;
        end
        STOP_P: begin
            if(P) begin
                P_in <= 0;
                state <= REVERSE;
            end
            else if(!P) begin
                P_in <= 1;
                state <= PICKUP;
            end
            prev_state <= state;
        end
        STOP_D: begin
            if(D) begin
                REV <= 1;
                T <= 0;
                D_in <= 0;
                state <= REVERSE;
            end
            else if(!D) begin
                REV <= 1;
                T <= 1;
                D_in <= 1;
                state <= DROP;
            end
            prev_state <= state;
        end
        STOP_E: begin
            REV <= 1;
            T <= 1;
            if(oneK && !twoK && !threeK) begin
                freq_sel <= 2'b01;
                T <= 1;
                state <= STOP_E;
            end
            else if(!oneK && twoK && !threeK) begin
                freq_sel <= 2'b10;
                T <= 1;
                state <= STOP_E;
            end
            else if(!oneK && !twoK && threeK) begin
                freq_sel <= 2'b11;
                T <= 1;
                state <= STOP_E;
            end
            prev_state <= state;
        end
        REVERSE: begin
            REV <= 1;
            if(rev) begin
                T <= 1;
                state <= LINE_NOTT;
            end
            else if(!rev) begin
                T <= 0;
            end
            prev_state <= state;
        end
        PICKUP: begin
            if(P) begin
                liftDuty <= 14'h2328;
                state <= STOP_P;
            end
            else if(!P) begin
                P_in <= 1;
            end
            prev_state <= state;
        end
        DROP: begin
            liftDuty <= 14'h1388;
            if(O && !D) begin
                D_in <= 1;
                state <= STOP_D;
            end
            
            prev_state <= state;
        end
    default: begin
        state <= prev_state;
    end
    endcase
end
endmodule