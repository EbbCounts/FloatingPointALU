`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 08:32:51 PM
// Design Name: 
// Module Name: ALU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_tb;

    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] opcode;

    // Output
    wire [31:0] result;

    // Instantiate the ALU module
    ALU uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );

    // Test stimuli
    initial begin
        // Monitor values
        $monitor("Time = %0t | A = %h, B = %h, opcode = %b, result = %h", $time, A, B, opcode, result);

        // Test case 1: Addition
        A = 32'h40600000;
        B = 32'h40900000;
        opcode = 2'b00;
        #10; // Wait for 10 time units

        // Test case 2: Multiplication
        A = 32'h413C0000;
        B = 32'h4019999A;
        opcode = 2'b01;
        #10;

        // Test case 3: Division
        A = 32'h3FA00000;
        B = 32'hC0E9999A;
        opcode = 2'b10;
        #10;

        // Test case 4: Default case (invalid opcode)
        opcode = 2'b11;
        #10;

        // Finish simulation
        $finish;
    end

endmodule
