`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 03:55:08 PM
// Design Name: 
// Module Name: ALU
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

//assume inputs a and b are already in ieee 754 format
///ieee 754 format: 

//  Sign Bit      Exponent        Mantissa
//    [31]        [30:23]          [22:0]

module ALU(
    input [31:0] A, B,
    input [1:0] opcode,
    output [31:0] result
    );
    
    wire [31:0] AddSubResult;
    wire [31:0] MultResult;
    wire [31:0] DivResult;
    
     FloatingAddition AddSub (.A(A),.B(B),.result(AddSubResult));
     FloatingMultiplication Mult (.A(A),.B(B),.result(MultResult));
     FloatingDivision Div (.A(A),.B(B),.result(DivResult));
     
     reg [31:0] tempresult;
    
    //opcodes
    //add = 00, mul = 01, div = 10
    
    // Opcode logic to select the result
    always @(*) begin
        case (opcode)
            2'b00: tempresult = AddSubResult;  // Addition
            2'b01: tempresult = MultResult;   // Multiplication
            2'b10: tempresult = DivResult;    // Division
            default: tempresult = 32'h00000000; // Default case
        endcase
    end
    
    assign result = tempresult;
        
endmodule
