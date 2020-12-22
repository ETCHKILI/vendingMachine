`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 22:03:35
// Design Name: 
// Module Name: top
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


module top(clk, main_switch, adm_mode, switch_plus, switch_minus, confirm, return, coin1, coin2, coin5, coin10);
input clk, main_switch, adm_mode, switch_plus,switch_minus, confirm, return, coin1, coin2, coin5, coin10;
//output

reg finish;

wire rst_n;
wire [9:0]state;
wire main_switch_r, adm_mode_r;
wire switch_plus_p, switch_minus_p, confirm_p, return_p, coin1_p, coin2_p, coin5_p, coin10_p, finish_p;


anti_shake a1(main_switch, main_switch_r);
anti_shake a2(adm_mode, adm_mode_r);
trans t1(clk, rst_n, switch_plus, switch_plus_p);
trans t2(clk, rst_n, switch_minus, switch_minus_p);
trans t3(clk, rst_n, confirm, confirm_p);
trans t4(clk, rst_n, return, return_p);
trans t5(clk, rst_n, coin1, coin1_p);
trans t6(clk, rst_n, coin2, coin2_p);
trans t7(clk, rst_n, coin5, coin5_p);
trans t8(clk, rst_n, coin10, coin10_p);
trans t9(clk, rst_n, finish, finish_p);


mode_v u1(clk, rst_n, main_switch_r, adm_mode_r, switch_plus_p, switch_minus_p, confirm_p, return_p, finish, state);

endmodule
