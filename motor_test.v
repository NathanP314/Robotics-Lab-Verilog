module motor_test(
output IN1,IN2,IN3,IN4, ENA, ENB
);
    assign ENA = 1;
    assign ENB = 1;
    assign IN1 = 1;
    assign IN2 = 0;
    assign IN3 = 0;
    assign IN4 = 1;

endmodule

/*
L : IN1 - J1
L : IN2 - L2
R : IN3 - J2
R : IN4 - G2
L : ENA - H1
R : ENB - K2
*/
