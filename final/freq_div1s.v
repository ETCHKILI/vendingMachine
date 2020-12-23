`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 17:51:40
// Design Name: 
// Module Name: freq_div1s
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


module freq_div(// ‰≥ˆ1√Îº∂ ±÷”
    input 
    rawClk,
    rst_n,
    
    output
    reg clk_out
);

    parameter n=1_0000_0000;//1s
    
    reg[26:0] cnt;
    always@(posedge rawClk,negedge rst_n) begin
        if(~rst_n) begin
            cnt<=0;
            clk_out<=0;
        end
        else begin
            if(cnt==((n>>1)-1)) begin
                clk_out<=~clk_out;
                cnt<=0;
            end
            else begin
                cnt<=cnt+1;
            end
        end
    end
endmodule
