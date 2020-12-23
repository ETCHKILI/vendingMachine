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



wire [9:0]state;

wire [2:0]id;//当前选择的商品id
wire [3:0]curr_number, curr_snumber;//当前商品的余量和�?�?
wire [6:0]sum, money, change;//当前支付的金额，�?要支付的金额，找�?
wire [9:0]sale;//总销售金�?
//二进制表示的数据


wire [3:0]curr_number1, curr_number0,//当前商品余量
          curr_snumber1, curr_snumber0, //当前商品�?�?
          sum1, sum0,//当前支付金额
          money1, money0, //�?要支付的总金�?
          change1, change0, //找零
          sale2, sale1, sale0; //总销售金�?
//8421BCD码表示的数据�?2为百位，1为十位，0为个�?

wire main_switch_r, adm_mode_r;
wire switch_plus_p, switch_minus_p, confirm_p, return_p, coin1_p, coin2_p, coin5_p, coin10_p;

//�?关信�?

reg finish;
wire finish_change;
wire rst_n;
wire out;//当前商品是否卖光
//内部信号

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
trans t9(clk, rst_n, finish, finish_change);
//防抖，边沿检�?

bi_to_bcd4 b1(curr_number, curr_number1, curr_number0);
bi_to_bcd4 b2(curr_snumber, curr_snumber1, curr_snumber0);
bi_to_bcd7 b3(sum, sum1, sum0);
bi_to_bcd7 b4(money, money1, money0);
bi_to_bcd7 b5(change, change1, change0);
bi_to_bcd10 b6(sale, sale2, sale1, sale0);
//二进制数据转bcd
// module bi_to_bcd4(binary, bcd1, bcd0);
// module bi_to_bcd7(binary, bcd1, bcd0);
// module bi_to_bcd10(binary, bcd2, bcd1, bcd0);


mode_v u1(clk, rst_n, main_switch_r, adm_mode_r, switch_plus_p, switch_minus_p, confirm_p, return_p, change,out, state);
//模式切换连线
//module mode_v(clk, rst_n, main_switch, adm_mode,switch_plus,switch_minus, confirm, return, finish, out, state);


caculation c1(clk, rst_n, state, switch_minus_p, switch_minus_p, coin1_p, coin2_p, coin5_p, coin10_p, curr_number, curr_snumber, sum, money, change, sale, out);
//数据计算连线
//module caculation(clk, rst_n, state, switch_plus, switch_minus, coin1, coin2, coin5, coin10, id, curr_number, curr_snumber, sum, money, change, sale, out);



endmodule
