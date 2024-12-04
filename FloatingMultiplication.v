`timescale 1ns / 1ps

module FloatingMultiplication #(parameter WIDTH=32) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output [WIDTH-1:0] result);
    
    reg A_sign, B_sign;                     //initial values
    reg [7:0] A_Exponent, B_Exponent;
    reg [23:0] A_Mantissa, B_Mantissa;
    
    reg [7:0] TemporaryExponent;            //exponent to perform calcs 
    reg [47:0] TemporaryMantissa;           //mantissa to perform calc on

    reg FinalSign;                          //Final Values
    reg [7:0] FinalExponent;       
    reg [22:0] FinalMantissa;
    
    
    always@(*) begin
        A_sign = A[31];                     //defining value A's sign, exponent, and mantissa
        A_Exponent = A[30:23];
        A_Mantissa = {1'b1,A[22:0]};        
        
        B_sign = B[31];                     //defining value B's sign, exponent, and mantissa
        B_Exponent = B[30:23];
        B_Mantissa = {1'b1,B[22:0]};

        //calculations
        TemporaryExponent = A_Exponent + B_Exponent - 127; //addition of exponents - 127
        TemporaryMantissa = A_Mantissa*B_Mantissa; //multiplication of mantissas
        FinalMantissa = TemporaryMantissa[47] ? TemporaryMantissa[46:24] : TemporaryMantissa[45:23]; //if the msb is 1, the mantissa is normalized and should be unchanged. If it is 0, the mantissa should be shifted left by 1. 
        FinalExponent = TemporaryMantissa[47] ? TemporaryExponent+1'b1 : TemporaryExponent; //if the msb is 1, the exponent must have a 1 added to it. If the result is 0, the exponent should be unchanged. 
        FinalSign = A_sign ^ B_sign; //decision of sign of output
    end
    
    assign result = {FinalSign,FinalExponent,FinalMantissa}; //final result creation
endmodule