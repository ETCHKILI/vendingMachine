`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 14:03:16
// Design Name: 
// Module Name: mode
// Project Name: vending_machine
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


module mode(clk, rst_n, main_switch, adm_mode,switch_plus,switch_minus, confirm, return, finish, sum, money);

input clk, rst_n,
     main_switch, //零售机的主开关
     adm_mode,//管理员模式的开关
     switch_plus,switch_minus,//查看模式下商品切换，增加或者减少购买数量等
     confirm, return,//通用的确认返回
     finish,//倒计时结束的信号,非开关
     sum, money;//已支付金额和应付金额

reg [9:0]state = 4'b0000;//当前状态


parameter S_OFF = 4'b0000,//关机 
          S_INQUIRE = 4'b0001,//查看，滚动显示商品信息
          S_ADD_AMOUNT = 4'b0011,//已经确认商品，添加或减少数量
          S_PAYMENT = 4'b0010,//付款（投币）
          S_SUCCESS = 4'b0110,////付款成功
          S_FAILURE = 4'b0111,//付款失败
          S_ADM1 = 4'b0101,//管理员界面，屏幕显示"查看商品信息"
          S_ADM2 = 4'b0100,//屏幕显示"复位"
          S_ADM3 = 4'b1100,//屏幕显示"查看销售金额"
          S_ADM_INQUIRE = 4'b1101,//管理员的查看模式，同时可切换查看商品信息和余量,确认后进行补货
          S_ADM_ADD = 4'b1111,//补货
          S_RESET = 4'b1110,//复位
          S_SALE_AMOUNT = 4'b1010;//查看销售金额，查看后自动返回


    always@(*)
    begin

        case(state)
            S_OFF:
            if(main_switch)begin
                state = S_INQUIRE;
            end

            S_INQUIRE://商品的切换对模式转换没有影响，在模块内实现
            begin
            if(adm_mode)begin
                state = S_ADM1;
            end
            if(confirm) begin
                state = S_ADD_AMOUNT;
            end
            end
            
            S_ADD_AMOUNT:
            begin
            if (adm_mode)begin
                state = S_ADM1;
            end
            /*因为添加数量的多少不会影响状态改变，所以状态机这里没有做处理
            在具体模块内实现*/
            if (confirm) begin
                state = S_ADD_AMOUNT;
            end
            if(return)begin
                state = S_INQUIRE;
            end
            end
            
            S_PAYMENT://投币在数值处理部分
            begin
            if (sum > money) begin//不用确认，金额达到自动判断
                state = S_SUCCESS;
            end 
            if(confirm & return & finish) begin
                state = S_FAILURE;
            end
            end
            
            S_SUCCESS:
            if(confirm & return & finish)begin//退款完成，倒计时结束
                state = S_INQUIRE;
            end

            S_FAILURE:
            if (confirm & return & finish) begin//退款完成，倒计时结束
                state = S_INQUIRE;
            end

            S_ADM1:
            begin
            if (switch_plus) begin
                state = S_ADM2;
            end
            if (switch_minus) begin
                state = S_ADM3;
            end
            if (return) begin
                state = S_INQUIRE;
            end
            if (confirm) begin
                state = S_ADM_INQUIRE;
            end
            end

            S_ADM2:
            begin
            if (switch_plus) begin
                state = S_ADM3;
            end
            if (switch_minus) begin
                state = S_ADM1;
            end
            if (return) begin
                state = S_INQUIRE;
            end
            if (confirm) begin
                state = S_RESET;
            end
            end
            
            S_ADM3:
            begin
            if (switch_plus) begin
                state = S_ADM1;
            end
            if (switch_minus) begin
                state = S_ADM2;
            end
            if (return) begin
                state = S_INQUIRE;
            end
            if (confirm) begin
                state = S_SALE_AMOUNT;
            end
            end

            S_ADM_INQUIRE://可切换查看商品信息，在数值处理实现
            if(confirm)begin
                state = S_ADM_ADD;
            end

            S_ADM_ADD://需要明确数值处理部分，再修改
            if (return) begin
                state = S_ADM_INQUIRE;
            end

            S_RESET:
            //复位操作,显示复位成功后，自动回到模式选择
            if (finish & confirm & return) begin
                state = S_ADM2;
            end

            S_SALE_AMOUNT:
            //屏幕显示总销售金额，10s后自动返回
            if (finish & confirm & return) begin
                state = S_ADM3;
            end


            default: 
            state = S_OFF;
        endcase
    
    end
endmodule