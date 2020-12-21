`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 15:25:43
// Design Name: 
// Module Name: vending_machine
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




/*
自动售货机，顶层模块
    state和id都在顶层模块变化
        state：
        0.关机
        1.选择阶段
        2.数量
        3.买
        4.找
        5.管理员
        
        id  name    price
        0.  chip    3   
        1.  milk    4
        2.  cola    5
        3.  cake    6
*/
module vending_machine(
        input 
        rawClk,//原始时钟

        mSwitch,//总开关
        mode,//模式切换开关，普通模式 0 vs 管理员模式 1 
        
        initialize,//管理员初始化开关
        
        plus,//购买或补货时，物品数量 加 的开关
        minus,//购买或补货时，物品数量 减 的开关
        
        prev,//选择时 前一个，后一个 的按钮
        next,
        
        choiceConfirm,//确认商品
        buyConfirm,//确认购买数量
        payConfirm,//确认支付的开关
        back,//从pay阶段返回select阶段
        
        pay1,
        pay2,
        pay5,
        pay10,//投币开关
        
        output 
        reg message
        
        
        );
        
        reg[2:0] state;//state of vending machine
        reg[1:0] id;//current id of goods
        //reg messageID;
        //reg charge;
        
        reg[3:0] num0;
        reg[3:0] num1;//各商品剩余数量,最大15
        reg[3:0] num2;
        reg[3:0] num3;
        
        reg[5:0] sell0;
        reg[5:0] sell1;
        reg[5:0] sell2;//卖出的数量,最大63
        reg[5:0] sell3;
        
        reg[8:0] total;//总金额，最大511
        
        always@(posedge rawClk,negedge mSwitch) begin
            if(~mSwitch) begin
                {state,id,num0,num1,num2,num3,sell0,sell1,sell2,sell3,total}<=0;
            end
            else 
                case(state)
                    0://initial state
                        begin
                            state<=1;
                        end
                    
                    1://choosing state
                        begin
                            
                            if(choiceConfirm) state<=2;
                        end
                    2://get buyNum
                        begin
                        
                        
                        end
                   
                    3://giving coin
                        begin
                                            
                                            
                        end
                    4://charge
                        begin
                                        
                                        
                        end                        
                    5://administrator
                        begin
                                        
                                        
                        end
                endcase
        end
        
        
        
endmodule


module admin(
    input
    
    [3:0]num0,
    [3:0]num1,
    [3:0]num2,
    [3:0]num3,
    
    [5:0]sell0,
    [5:0]sell1,
    [5:0]sell2,
    [5:0]sell3,
    [9:0]total,
    [1:0]id,
    
    plus,
    minus,
    
    initialize,//管理员的初始化按钮，使所有物品剩余数量更新为0，仅在管理员模式可用
    
    output
    
    [3:0]outNum0,
    [3:0]outNum1,
    [3:0]outNum2,
    [3:0]outNum3
    
);

endmodule

/*
付款模块
*/
module payment(
    input
    timesUp,//0表示时间到
    
    [2:0]state, 
    [1:0]id,
    
    plus,
    minus,
    
    [3:0]num0,
    [3:0]num1,
    [3:0]num2,
    [3:0]num3,
    
    pay1,
    pay2,
    pay5,
    pay10,//投币开关
        
    output
    reg [1:0]payNum,//购买数不超过三件
    reg [1:0]payID,//
    
    reg [5:0]moneyPaid,//已投币,不超过63
    reg [4:0]moneyRequired,//需要付,no more than 31
    reg canPay,//输出钱是否足够,0不够，1够
    
    [3:0]payMessageId//付款信息id，详情见generateMessage模块
);

endmodule

/*
找零模块
*/
module charge(
    input
    state,
    buyId,
    buyNum,
    
    num0,
    num1,
    num2,
    num3,
    
    sell0,
    sell1,
    sell2,
    sell3,
    
    output
    outNum0,    
    outNum1,
    outNum2,
    outNum3//更新后的各个数量
);


endmodule


/*
分频器生成时钟
*/
module freq_div(//输出1秒级时钟
    input 
    rawClk,
    mSwitch,//相当于reset信号，下降沿分频器归零
    
    output
    reg clk
);
endmodule

/*
倒计时模块
*/
module countDown(
    input 
    clk,
    state,    
    output
    timesUp//0表示时间到
);

endmodule

module generateMessage(
    input
    messageId,
    mode
    
    
    
);

endmodule

//module selection(//内嵌套payment模块   ???
//    input
//    state,//模式只在低电频时,选择模块有状态改变；
//    id,
//    num1,
//    num2,
//    num3
//);
//endmodule




