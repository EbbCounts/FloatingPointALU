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

        // Replacing the while loop with a for loop to shift until the leading bit is 1
        reg flag;
        integer counter;

always @(*) begin
    comp =  (A[30:23] >= B[30:23])? 1'b1 : 1'b0; //if A is equal to or bigger than B, comp is 1, else comp is 0
       
    LargerMantissa = comp ? {1'b1, A[22:0]} : {1'b1, B[22:0]};    //if comp is 1, the large mantissa is A. Else, it's B
    LargerExponent = comp ? A[30:23] : B[30:23];                //if comp is 1, the large exponent is A. Else, it's B
    LargerSign = comp ? A[31] : B[31];                          //if comp is 1, the large sign is A. Else, it's B
       
    SmallerMantissa = comp ? {1'b1, B[22:0]} : {1'b1, A[22:0]};
    SmallerExponent = comp ? B[30:23] : A[30:23];
    SmallerSign = comp ? B[31] : A[31];
    
    ExponentDifference = LargerExponent - SmallerExponent; //difference in exponents
    SmallerMantissa = (SmallerMantissa >> ExponentDifference); //shift smaller mantissa by the difference in exponents to align
    
    {carry, TemporaryMantissa} = (LargerSign ~^ SmallerSign) ? LargerMantissa + SmallerMantissa : LargerMantissa - SmallerMantissa; //add or subtract mantissas based on signs
    
    TemporaryExponent = LargerExponent; //TemporaryExponent is initially set to the larger exponent
    
    // The goal of the following code is to shift the mantissa so that the leading bit is a 1
    if (carry) begin // If there is a carry-out, shift right and increment the exponent
        TemporaryMantissa = TemporaryMantissa >> 1;
        TemporaryExponent = TemporaryExponent + 1'b1;
    end else begin

        // Initialize flag based on the leading bit of TemporaryMantissa
        flag = TemporaryMantissa[23];

        // Use a for loop up to 24 shifts
        for (counter = 0; counter < 24 && !flag; counter = counter + 1) begin
            TemporaryMantissa = TemporaryMantissa << 1;
            TemporaryExponent = TemporaryExponent - 1'b1;
            flag = TemporaryMantissa[23]; // Update the flag after shifting
        end
    end
    
    // Final result creation    
    FinalSign = LargerSign;
    FinalExponent = TemporaryExponent;
    FinalMantissa = TemporaryMantissa[22:0];
    result = {FinalSign, FinalExponent, FinalMantissa};
end
endmodule
