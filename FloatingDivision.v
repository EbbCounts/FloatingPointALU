`timescale 1ns / 1ps

module FloatingDivision#(parameter WIDTH=32) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output [WIDTH-1:0] result);
                         
    wire [7:0] Exponent;
    wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7;
    wire [31:0] reciprocal;
    wire [31:0] x0,x1,x2,x3;
    
    
    /*----Initial value----*/
    FloatingMultiplication M1(
    .A({{1'b0,8'd126,B[22:0]}}), // roughly divides B by 2
    .B(32'h3ff0f0f1), // ~1.88
    .result(temp1) // temp1 = B * .94
    ); //verified
    
    
    FloatingAddition A1(
        .A(32'h4034b4b5), // ~2.82
        .B({1'b1, temp1[30:0]}), // -temp1
        .result(x0)); // x0 = 2.82 - temp1
    
    /*----First Iteration----*/
    FloatingMultiplication M2(
    .A({{1'b0,8'd126,B[22:0]}}), // B/2
    .B(x0), // 2.82 - temp1
    .result(temp2)); // temp 2 = (B/2)*x0 = B*(2.82 - temp1)/2
    
    FloatingAddition A2(
    .A(32'h40000000), // 2
    .B({!temp2[31],temp2[30:0]}),  // -(temp2)
    .result(temp3)); //temp3 = 2 - temp2
    
    FloatingMultiplication M3(
    .A(x0),
    .B(temp3),
    .result(x1)); // x1 = x0 * temp3
    
    /*----Second Iteration----*/
    FloatingMultiplication M4(
    .A({1'b0,8'd126,B[22:0]}), // B/2
    .B(x1),
    .result(temp4)); // (B * x1)/2
    
    FloatingAddition A3(
    .A(32'h40000000), // 2
    .B({!temp4[31],temp4[30:0]}), // -temp4
    .result(temp5)); // temp5 = 2 - temp4
    
    
    FloatingMultiplication M5(
    .A(x1),
    .B(temp5),
    .result(x2)); // x2 = temp5 * x1
    
    /*----Third Iteration----*/
    FloatingMultiplication M6(
    .A({1'b0,8'd126,B[22:0]}), // B/2
    .B(x2),
    .result(temp6)); // temp6 = B/2 * x2
    
    FloatingAddition A4(
    .A(32'h40000000), // 2
    .B({!temp6[31], temp6[30:0]}), // - temp6
    .result(temp7)); // temp7 = 2 - temp6
    
    FloatingMultiplication M7(
    .A(x2),
    .B(temp7),
    .result(x3)); // x3 = temp7 * x2
    
    /*----Reciprocal : 1/B----*/
    assign Exponent = x3[30:23]+8'd126-B[30:23]; // readjusts the bias
    assign reciprocal = {B[31],Exponent,x3[22:0]}; // reciprocal is the same sign and data but with ajusted exponent
    
    /*----Multiplication A*1/B----*/
    FloatingMultiplication M8(
    .A(A),
    .B(reciprocal),
    .result(result));

endmodule