`timescale 1ns / 1ps

module FloatingAddition #(parameter WIDTH=32) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output reg [WIDTH-1:0] result);

reg LargerSign, SmallerSign;                //sign of larger number and smaller number
reg [7:0] LargerExponent, SmallerExponent;  //exponent of larger number and smaller number
reg [23:0] LargerMantissa, SmallerMantissa; //mantissa of larger number and smaller number
                
reg carry;                                  //carry out bit
reg comp;                                   //value for exponent comparison

reg TemporarySign;                          //Sign we are performing calculations on   
reg [7:0] TemporaryExponent;                //Exponent we are performing calculations on
reg [23:0] TemporaryMantissa;               //mantissa we are performing calculations on

reg [7:0] ExponentDifference;               //difference in exponents

reg [22:0] FinalMantissa;                   //mantissa of final result
reg [7:0] FinalExponent;                    //exponent of final result
reg FinalSign;                              //sign of final result

    
always @(*) begin
    comp =  (A[30:23] >= B[30:23])? 1'b1 : 1'b0; //if a is equal to or bigger than b, comp is 1, else comp is 0
      
    LargerMantissa = comp ? {1'b1,A[22:0]} : {1'b1,B[22:0]};    //if comp is 1, the large mantissa is the mantissa of input a. Else, the large mantissa is the mantissa of input b
    LargerExponent = comp ? A[30:23] : B[30:23];                //if comp is 1, the large exponent is the exponent of input a. Else, the large exponent is the exponent of input b
    LargerSign = comp ? A[31] : B[31];                          //if comp is 1, the large sign is the exponent of sign a. Else, the large sign is the sign of input b
      
    SmallerMantissa = comp ? {1'b1, B[22:0]} : {1'b1, A[22:0]};
    SmallerExponent = comp ? B[30:23] : A[30:23];
    SmallerSign = comp ? B[31] : A[31];
    
    ExponentDifference = LargerExponent - SmallerExponent; //difference in exponents
    SmallerMantissa = (SmallerMantissa >> ExponentDifference); //shift small number mantissa by the difference in exponents to align the mantissas
    {carry,TemporaryMantissa} = (LargerSign ~^ SmallerSign)? LargerMantissa + SmallerMantissa : LargerMantissa - SmallerMantissa; //if the signs are the same, add the mantissas. Else, subtract the mantissas. This is how we decide to add or subtract.
    
    TemporaryExponent = LargerExponent; //TemporaryExponent is the larger exponent for now, but we will operate on it
    
    //the goal of the following code is to shift the mantissa so that the leading bit is a 1
    if(carry) //If there is a carry-out, shift the result right and increment the exponent
        begin
            TemporaryMantissa = TemporaryMantissa >> 1;
            TemporaryExponent = TemporaryExponent + 1'b1;
        end
    else
        begin
        while(!TemporaryMantissa[23]) //Otherwise, left-shift the result until the leading bit is 1 and adjust the exponent
            begin
               TemporaryMantissa = TemporaryMantissa << 1;
               TemporaryExponent =  TemporaryExponent - 1'b1;
            end
        end
    
    //final result creation    
    FinalSign = LargerSign;
    FinalExponent = TemporaryExponent;
    FinalMantissa = TemporaryMantissa[22:0];
    result = {FinalSign,FinalExponent,FinalMantissa};
    end
endmodule