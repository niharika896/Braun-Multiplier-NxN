`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2026 20:14:38
// Design Name: 
// Module Name: braunNxN_tb
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


module braunNxN_tb();
wire [15:0] Res;
reg [7:0] a, b;

braunNxN dut(.Result(Res), .A(a), .B(b));
initial begin
    a = 4'b00001000; b = 4'b00001000; //8*8=16 = 00010000
    #10
    a = 4'b00000100; b = 4'b0000010; //4*2=8 = 00001000
    #10
    a = 4'b00001100; b = 4'b00000001; //12*1=12 = 00001100
    #10
    a = 4'b00001011; b = 4'b00001001; //11*9=99 = 1100011
    #10
$stop;
end
endmodule