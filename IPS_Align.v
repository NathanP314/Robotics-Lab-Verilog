`include "PWM.v"
module IPS_Align (
input REV,M,L,R,T,clk,
output wire ENA, ENB,
output reg IN1,IN2,IN3,IN4,
output reg [2:0] count,
output reg rev
);

//DUTY CYCLES

wire last1, last2;
reg [4:0] state;
reg [4:0] prev_state;
reg [13:0] duty1, duty2;


    PWM PWMA(
        .clk(clk),
        .duty(duty1),
        .drive(ENA), // I switched these at 6 am, if they dont work as expected switch back
        .last(last1) 
    ),
    PWMB(
        .clk(clk),
        .duty(duty2),
        .drive(ENB), // I switched these at 6 am, if they dont work as expected switch back
        .last(last2)
    );

    initial begin
        duty1 = 0;
        duty2 = 0;
        count = 0;
        IN1 = 0;
        IN2 = 0;
        IN3 = 0;
        IN4 = 0;
        rev = 0;
        state = 0;
        prev_state = 0;
    end
    always @(posedge clk) begin
        state <= {REV,L,M,R,T};
        casex(state)
        
        /////// T Off : For Intersection Line Follow ///////

        5'b00000: begin // turn right in place
            rev <= 0;
            IN1 <= 1;
            IN2 <= 0;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h2000;
            duty2 <= 14'h2000; 
            prev_state <= state;
        end
        5'b00010:begin // right
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;       //1010 makes it turn right
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h2000;
            duty2 <= 14'h1000;
            prev_state <= state;
        end
        5'b00100: begin // straight
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h2000;
            duty2 <= 14'h2000;  
            prev_state <= state;
        end    
        5'b00110:begin // sharp turn right for int
            rev <= 0;
            IN1 <= 1;
            IN2 <= 0;       //1010 makes it turn right
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h2100;
            duty2 <= 14'h1500;
            prev_state <= state;
        end  
        5'b01000:begin // slight left
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1200;
            duty2 <= 14'h2000;  
            prev_state <= state;
        end
        5'b01010:begin // slight left turn
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1600;
            duty2 <= 14'h2000;   
            prev_state <= state; 
        end
        5'b01100: begin // Adjust Left
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;  
            duty1 <= 14'h1600;
            duty2 <= 14'h2000;  
            prev_state <= state;
        end
        5'b01110:begin // sharp right
            rev <= 0;
            IN1 <= 1;
            IN2 <= 0;       //1010 makes it turn right
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h2000;
            duty2 <= 14'h2000; 
            prev_state <= state;
        end
        
        
        /////// T ON : FOR MAIN LINE FOLLOW ///////
        
        5'b00001:begin // Forward
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1400;
            duty2 <= 14'h1400; 
        end
        5'b00011:begin // Adjust Right
            rev <= 0;
            IN1 <= 1;
            IN2 <= 0;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1400;
            duty2 <= 14'h1000; 
            prev_state <= state;
        end
        5'b00101:begin
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1400;
            duty2 <= 14'h1400; 
            prev_state <= state;
        end
        5'b00111:begin // Count Intersection, Go Forward
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1400;
            duty2 <= 14'h1400; 
            if(state != prev_state && prev_state != 5'b01111)begin
                count <= count + 1;
            end
            prev_state <= state;
        end
        5'b01001:begin // Slight Left
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1000;
            duty2 <= 14'h1400; 
            prev_state <= state;
        end
        5'b01011:begin
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1000;
            duty2 <= 14'h1400; 
            prev_state <= state;
        end
        5'b01101:begin
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1000;
            duty2 <= 14'h1400; 
            prev_state <= state;
        end
        5'b01111:begin // Count Intersection, Go Forward
            rev <= 0;
            IN1 <= 0;
            IN2 <= 1;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1400;
            duty2 <= 14'h1400; 
            if(state != prev_state && prev_state != 5'b00111)begin
                count <= count + 1;
            end
            prev_state <= state;
        end
        
        /////// REV and T : For Reversing and Stopping
        
        5'b1xx01:begin
            rev <= 0;
            IN1 <= 0;
            IN2 <= 0;
            IN3 <= 0;
            IN4 <= 0;
            duty1 <= 14'h0000;
            duty2 <= 14'h0000;
            prev_state <= state;
            prev_state <= state;
        end
        5'b1xx00:begin
            rev <= 0;
            IN1 <= 1;
            IN2 <= 0;
            IN3 <= 1;
            IN4 <= 0;
            duty1 <= 14'h1000;
            duty2 <= 14'h1000;
            prev_state <= state;
        end
        5'b1xx10:begin
            IN1 <= 0;
            IN2 <= 0;
            IN3 <= 0;
            IN4 <= 0;
            duty1 <= 14'h0000;
            duty2 <= 14'h0000;
            rev <= 1;
            prev_state <= state;
        end
        default: begin
            state <= prev_state;
        end
    endcase
    end
endmodule
