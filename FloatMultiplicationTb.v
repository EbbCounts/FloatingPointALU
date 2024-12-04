`timescale 1ns / 1ps

module FloatMultiplicationTB #(parameter WIDTH = 32);
    reg [WIDTH-1:0] A, B;
    wire [WIDTH-1:0] result;
    real  value;
    FloatingMultiplication F_Mult (.A(A),.B(B),.result(result));

    
    initial begin
        A = 32'h40600000;
        B = 32'h40900000;
        #20
        A = 32'h413C0000;
        B = 32'h4019999A;
        #20
        A = 32'h3FA00000;
        B = 32'hC0E9999A;
        #20
        A = 32'h41A3999A;
        B = 32'hC17B3333;
    end
    
    initial begin
        #5
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f",(3.5)*(4.5),value);
        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f",(11.75)*(2.4),value);
        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f",(1.25)*(-7.3),value);
        #20
        value =(2**(result[30:23]-127))*($itor({1'b1,result[22:0]})/2**23)*((-1)**(result[31]));
        $display("Expected Value : %f Result : %f",(20.45)*(-15.70),value);
        #20
        $finish;
    end
endmodule
