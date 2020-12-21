`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 21:49:08
// Design Name: 
// Module Name: trans
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


module trans(clk, ori_signal,rst_n, pos, neg);
    input clk, ori_signal,rst_n;
    output pos, neg;
    

    reg  pulse_r1, pulse_r2; //hasUp means the signal is already at the high ,1 represent already at high, 0 represent already at low
    wire signal;
    anti_shake an1 (clk,ori_signal,rst_n, signal);
    
    always@(posedge clk,negedge rst_n) begin
        
        if(!rst_n) 
            begin
            pulse_r1 <= 1'b0;
            pulse_r2 <= 1'b0;
            end
        else 
            begin
            pulse_r1 <= signal;
            pulse_r2 <= pulse_r1;
            end
        
    end
    
    assign pos=(pulse_r1 && ~pulse_r2) ?1:0;
    assign neg=(~pulse_r1 && pulse_r2) ?1:0; 
endmodule

module anti_shake(clk, ori_signal,rst_n, signal);
        input ori_signal, clk,rst_n;
        output reg signal;

        reg [9:0]counter_p ;
        reg [9:0]counter_n ;
        
        always@(posedge clk,negedge rst_n)
        begin
            if(~rst_n) begin
                signal<=0;
                counter_n <= 10'b0;
                counter_p <= 10'b0;
            end
            else begin
             case (ori_signal)
                     1'b1: 
                     begin
                        if (counter_p > 10'd1000) begin
                                signal <= 1'b1;
                        end
                        counter_n <= 10'b0;
                        counter_p <= counter_p + 10'b1;
                     end
                     1'b0: 
                     begin
                        if (counter_n > 10'd1000) begin
                                signal <= 1'b0;
                        end
                        counter_p <= 10'b0;
                        counter_n <= counter_n + 10'b1;
                     end
             endcase 
             end
        end
endmodule
