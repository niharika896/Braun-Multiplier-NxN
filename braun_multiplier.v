`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2026 22:13:24
// Design Name: 
// Module Name: braun_multiplier
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
module braunNxN #(parameter N = 8)(output [2*N-1:0]Result, input [N-1:0] A, B);
    wire Products [N-1:0][N-1:0];
    wire partial_sums [N-1:0][N-1:0];
    wire partial_carries[N-1:0][N-1:0];
    
    genvar i, j;
    //Initial Products
    generate
        for( i = 0; i< N; i = i+1) begin : row
            for(j = 0; j < N; j = j+1)begin : col
                assign Products[i][j] = (A[i]&B[j]);
            end
         end
     endgenerate
     //P0 = A0*B0
     assign Result[0] = Products[0][0];
     
     //first row of half adders
     generate
        for( i = 0; i < N; i = i + 1) begin : row1
           if( i == N-1) begin
                HalfAdder ha(partial_sums[0][i], partial_carries[0][i], Products[i][1], 0); //imaginary box for next set of partial sums
           end
           else begin
                HalfAdder ha(partial_sums[0][i], partial_carries[0][i], Products[i][1], Products[i+1][0]);
           end
        end
     endgenerate
     
     //middle rows of full adders
     generate
        for(i = 1; i < N; i = i + 1) begin: row2
            if( i != N-1) begin
                for( j = 0; j < N; j = j + 1) begin: col2
                    
                    if( j == N-1) begin
                        FullAdder fa(partial_sums[i][j], partial_carries[i][j], Products[j][i+1], 0, partial_carries[i-1][j]);  //s_out, c_out, a, b, c_in 
                    end
                    else begin 
                        FullAdder fa(partial_sums[i][j], partial_carries[i][j], Products[j][i+1], partial_sums[i-1][j+1], partial_carries[i-1][j]);
                    end
                end
            end
            else begin
                // last rows of full adders
                for ( j = 0; j < N; j = j +1) begin: col3
                    if( j != N-1) begin
                        FullAdder fa(partial_sums[N-1][j], partial_carries[N-1][j], Products[j][N-1], partial_sums[N-2][j+1], partial_carries[N-2][j]);
                    end
                    else begin
                        FullAdder fa(partial_sums[N-1][j], partial_carries[N-1][j], Products[j][N-1], 0, partial_carries[N-2][j]);
                    end
               end
            end
        end
     endgenerate
     
     //Last N+1 bits of the result 
     generate
        for(i = 0; i < N; i = i+1) begin: diag_results
            assign Result[i+1] = partial_sums[i][0];
        end
    endgenerate
     
     //Upper bits 
    generate
        for(i = 1; i < N; i = i+1) begin: upper_results
            assign Result[i+N] = partial_sums[N-1][i];
        end
    endgenerate
    
    //First bit of product is the carry
    assign Result[2*N-1] = partial_carries[N-1][N-1];                
endmodule

module HalfAdder(output S,C_out,input A,B);
    assign S = A^B;
    assign C_out = A&B;
endmodule

module FullAdder(output S, C_out, input A, B, C_in);
    assign S = A^B^C_in;
    assign C_out = (A & B) | (B & C_in) | (C_in & A);
endmodule

