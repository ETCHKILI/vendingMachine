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
�Զ��ۻ���������ģ��
    state��id���ڶ���ģ��仯
        state��
        0.�ػ�
        1.ѡ��׶�
        2.����
        3.��
        4.��
        5.����Ա
        
        id  name    price
        0.  chip    3   
        1.  milk    4
        2.  cola    5
        3.  cake    6
*/
module vending_machine(
        input 
        rawClk,//ԭʼʱ��

        mSwitch,//�ܿ���
        mode,//ģʽ�л����أ���ͨģʽ 0 vs ����Աģʽ 1 
        
        initialize,//����Ա��ʼ������
        
        plus,//����򲹻�ʱ����Ʒ���� �� �Ŀ���
        minus,//����򲹻�ʱ����Ʒ���� �� �Ŀ���
        
        prev,//ѡ��ʱ ǰһ������һ�� �İ�ť
        next,
        
        choiceConfirm,//ȷ����Ʒ
        buyConfirm,//ȷ�Ϲ�������
        payConfirm,//ȷ��֧���Ŀ���
        back,//��pay�׶η���select�׶�
        
        pay1,
        pay2,
        pay5,
        pay10,//Ͷ�ҿ���
        
        output 
        reg message
        
        
        );
        
        reg[2:0] state;//state of vending machine
        reg[1:0] id;//current id of goods
        //reg messageID;
        //reg charge;
        
        reg[3:0] num0;
        reg[3:0] num1;//����Ʒʣ������,���15
        reg[3:0] num2;
        reg[3:0] num3;
        
        reg[5:0] sell0;
        reg[5:0] sell1;
        reg[5:0] sell2;//����������,���63
        reg[5:0] sell3;
        
        reg[8:0] total;//�ܽ����511
        
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
    
    initialize,//����Ա�ĳ�ʼ����ť��ʹ������Ʒʣ����������Ϊ0�����ڹ���Աģʽ����
    
    output
    
    [3:0]outNum0,
    [3:0]outNum1,
    [3:0]outNum2,
    [3:0]outNum3
    
);

endmodule

/*
����ģ��
*/
module payment(
    input
    timesUp,//0��ʾʱ�䵽
    
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
    pay10,//Ͷ�ҿ���
        
    output
    reg [1:0]payNum,//����������������
    reg [1:0]payID,//
    
    reg [5:0]moneyPaid,//��Ͷ��,������63
    reg [4:0]moneyRequired,//��Ҫ��,no more than 31
    reg canPay,//���Ǯ�Ƿ��㹻,0������1��
    
    [3:0]payMessageId//������Ϣid�������generateMessageģ��
);

endmodule

/*
����ģ��
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
    outNum3//���º�ĸ�������
);


endmodule


/*
��Ƶ������ʱ��
*/
module freq_div(//���1�뼶ʱ��
    input 
    rawClk,
    mSwitch,//�൱��reset�źţ��½��ط�Ƶ������
    
    output
    reg clk
);
endmodule

/*
����ʱģ��
*/
module countDown(
    input 
    clk,
    state,    
    output
    timesUp//0��ʾʱ�䵽
);

endmodule

module generateMessage(
    input
    messageId,
    mode
    
    
    
);

endmodule

//module selection(//��Ƕ��paymentģ��   ???
//    input
//    state,//ģʽֻ�ڵ͵�Ƶʱ,ѡ��ģ����״̬�ı䣻
//    id,
//    num1,
//    num2,
//    num3
//);
//endmodule




