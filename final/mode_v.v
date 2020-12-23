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


module mode_v(clk, rst_n, main_switch, adm_mode,switch_plus,switch_minus, confirm, return, finish, out, state);
input clk, rst_n,
     main_switch,
     adm_mode,
     switch_plus,switch_minus,
     confirm, return,
     finish, out;

output reg [3:0]state = 4'b0000;


parameter S_OFF = 4'b0000,//?????????????¦Ê?????
          S_INQUIRE = 4'b0001,//????????¦²??5s????§Ý?????????§Ý?????plus??minus???§Ý????
          S_ADD_AMOUNT = 4'b0011,//???????????????????????????????????????
          //???????????????§Ø??????§³??1???????????
          S_PAYMENT = 4'b0010,//???????????????????????????????
          S_SUCCESS = 4'b0110,//?????????????????????????????????????????????????finish????????
          S_FAILURE = 4'b0111,//?????????????????????
          S_ADM1 = 4'b0101,//???inquire
          S_ADM2 = 4'b0100,//???reset
          S_ADM3 = 4'b1100,//???sale
          S_ADM_INQUIRE = 4'b1101,//??????????
          S_ADM_ADD = 4'b1111,//?????????????????????????????
          S_RESET = 4'b1110,//????????????????????finish???????????????
          S_SALE_AMOUNT = 4'b1010,//????????????????????finish???????????????
          S_SUC_ADM = 4'b1011,//?????????????
          S_WELCOME = 4'b1001,//???????
          S_OUT = 4'b1000;//???????????????sold out????????????????

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
            casex ({adm_mode, confirm, out})
                3'b01x: state <= S_ADD_AMOUNT;
                3'b10x, 3'b11x: state <= S_ADM1;
                3'b111: state <= S_OUT;
                3'b110: state <= S_SALE_AMOUNT;
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
            casex ({main_switch, adm_mode, confirm, return})
                4'b0xxx:  state <= S_OFF;
                4'b10xx:  state <= S_INQUIRE;
                4'b111x:  state <= S_ADM_ADD;
                4'b1101:  state <= S_ADM1;
                default:  state <= S_INQUIRE;
            endcase

            S_ADM_ADD:
            casex ({main_switch, adm_mode, return})
                3'b0xx:  state <= S_OFF;
                3'b10x:  state <= S_INQUIRE;
                3'b111:  state <= S_ADM2;
                default: state <= S_ADM_ADD;
            endcase

            S_RESET:
            casex ({main_switch, adm_mode, confirm, return, finish})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx|5'b1101x|5'b11001: state <= S_ADM2;
                default: state <= S_RESET;
            endcase

            S_SALE_AMOUNT:
            casex ({main_switch, adm_mode, confirm, return, finish})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx|5'b1101x|5'b11001: state <= S_ADM3;
                default: state <= S_SALE_AMOUNT;
            endcase

            S_SUC_ADM:
            casex ({main_switch, adm_mode, confirm, return, finish})
                5'b0xxxx: state <= S_OFF;
                5'b10xxx: state <= S_INQUIRE;
                5'b111xx|5'b1101x|5'b11001: state <= S_ADM1;
                default: state <= S_SALE_AMOUNT;
            endcase

            S_WELCOME:
            casex ({main_switch, confirm, return, finish})
                5'b0xxx: state <= S_OFF;
                5'b11xx|5'b101x|5'b1001: state <= S_INQUIRE;
                default: state <= S_WELCOME;
            endcase

            S_OUT: 
            casex ({main_switch, confirm, return, finish})
                5'b0xxx: state <= S_OFF;
                5'b11xx|5'b101x|5'b1001: state <= S_ADM3;
                default: state <= S_INQUIRE;
            endcase
            default: 
            state <= S_OFF;
        endcase
    
    end
endmodule