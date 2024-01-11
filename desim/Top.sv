// Copyright (c) 2022 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none

module Top (CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
    input  logic         CLOCK_50;   // DE-series 50 MHz clock signal
    input  logic [ 3: 0] KEY;        // DE-series pushbuttons
    input  logic [ 9: 0] SW;         // DE-series switches
    output logic [ 6: 0] HEX0;       // DE-series HEX displays
    output logic [ 6: 0] HEX1;
    output logic [ 6: 0] HEX2;
    output logic [ 6: 0] HEX3;
    output logic [ 6: 0] HEX4;
    output logic [ 6: 0] HEX5;
    output logic [ 9: 0] LEDR;

    assign HEX2[0] = SW[9];
    assign HEX2[1] = SW[8];

endmodule

