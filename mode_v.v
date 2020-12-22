`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 19:42:30
// Design Name: 
// Module Name: mode_v
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


module mode_v(clk, rst_n, main_switch, adm_mode,switch_plus,switch_minus, confirm, return, finish, state);
input clk, rst_n,
     main_switch,
     adm_mode,
     switch_plus,switch_minus,
     confirm, return,
     finish;

output reg [9:0]state = 4'b0000;


parameter S_OFF = 4'b0000,//关机状态，不显示任何内容
          S_INQUIRE = 4'b0001,//进入查询阶段，每5s自动切换商品，按切换键（plus和minus）切换商品
          S_ADD_AMOUNT = 4'b0011,//改变商品数量，屏幕显示商品数量和已经添加的数量
          //需要对商品数量做判断，不能小于1或者超出余量
          S_PAYMENT = 4'b0010,//投币，屏幕显示已经支付的金额和应支付的总金额
          S_SUCCESS = 4'b0110,//屏幕显示支付成功，倒计时之后自动跳转（状态机负责跳转，只需要把finish信号取反）
          S_FAILURE = 4'b0111,//除了显示支付失败，其他同上
          S_ADM1 = 4'b0101,//显示inquire
          S_ADM2 = 4'b0100,//显示reset
          S_ADM3 = 4'b1100,//显示sale
          S_ADM_INQUIRE = 4'b1101,//显示商品余量
          S_ADM_ADD = 4'b1111,//显示商品名称和余量和已经添加的数量
          S_RESET = 4'b1110,//显示成功，倒计时结束后把finish取反，状态机自动转换
          S_SALE_AMOUNT = 4'b1010,//显示销售金额，倒计时结束后finish取反，状态机自动转换
          S_SUC_ADM = 4'b1011,//补货成功显示信息
          S_WELCOME = 4'b1001,//开机欢迎
          S_OUT = 4'b1000;//商品已经卖光，显示“sold out”，之后回到付款界面

    always@(*)
    begin

        case(state)
            S_OFF:
            case (main_switch)
                1'b1: begin
                    state <= S_INQUIRE;
                    //reset once opening the machine
                end
                default: state <= S_OFF;
            endcase
                

            S_INQUIRE:
            case ({adm_mode, confirm})
                2'b01: state <= S_ADD_AMOUNT;
                2'b10, 2'b11: state <= S_ADM1;
                default: state <= S_INQUIRE;
            endcase
           
            S_ADD_AMOUNT:
            casex ({main_switch, adm_mode, confirm, return})
                4'b0xxx: state <= S_OFF;
                4'b11xx: state <= S_ADM1;
                4'b101x: state <= S_ADD_AMOUNT;
                4'b1001: state <= S_INQUIRE;
                default: state <= S_ADD_AMOUNT;
            endcase
            
            S_PAYMENT:
            casex ({main_switch, adm_mode, confirm, return, finish})
                5'b0xxxx: state <= S_OFF;
                5'b11xxx: state <= S_ADM1;
                5'b101xx,5'b1001x, 5'b10001: state <= S_FAILURE;
                default: state = S_PAYMENT;
            endcase
            

            S_SUCCESS:
            casex ({main_switch, adm_mode, confirm, return, finish})
                5'b0xxxx: state <= S_OFF;
                5'b11xxx: state <= S_ADM1;
                5'b101xx, 5'b1001x, 5'b10001: state <= S_INQUIRE;
                default: state = S_SUCCESS;
            endcase

            S_ADM1:
            casex ({main_switch, adm_mode, switch_plus, switch_minus, confirm})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx: state <= S_ADM2;
                5'b1101x: state <= S_ADM3;
                5'b11001: state <= S_ADM_INQUIRE;
                default: state = S_ADM1;
            endcase

            S_ADM2:
            casex ({main_switch, adm_mode, switch_plus, switch_minus, confirm})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx: state <= S_ADM3;
                5'b1101x: state <= S_ADM1;
                5'b11001: state <= S_RESET;
                default: state = S_ADM2;
            endcase

            S_ADM3:
            casex ({main_switch, adm_mode, switch_plus, switch_minus, confirm})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx: state <= S_ADM1;
                5'b1101x: state <= S_ADM2;
                5'b11001: state <= S_SALE_AMOUNT;
                default: state = S_ADM3;
            endcase

            S_ADM_INQUIRE:
            case ({main_switch, adm_mode, confirm, return})
                4'b0xxx:  state <= S_OFF;
                4'b10xx:  state <= S_INQUIRE;
                4'b111x:  state <= S_ADM_ADD;
                4'b1101:  state <= S_ADM1;
                default:  state <= S_INQUIRE;
            endcase

            S_ADM_ADD:
            case ({main_switch, adm_mode, return})
                3'b0xx:  state <= S_OFF;
                3'b10x:  state <= S_INQUIRE;
                3'b111:  state <= S_ADM2;
                default: state <= S_ADM_ADD;
            endcase

            S_RESET:
            case ({main_switch, adm_mode, confirm, return, finish})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx|5'b1101x|5'b11001: state <= S_ADM2;
                default: state <= S_RESET;
            endcase

            S_SALE_AMOUNT:
            case ({main_switch, adm_mode, confirm, return, finish})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx|5'b1101x|5'b11001: state <= S_ADM3;
                default: state <= S_SALE_AMOUNT;
            endcase


            default: 
            state <= S_OFF;
        endcase
    
    end
endmodule
