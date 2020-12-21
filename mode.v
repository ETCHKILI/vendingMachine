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
     main_switch, //���ۻ���������
     adm_mode,//����Աģʽ�Ŀ���
     switch_plus,switch_minus,//�鿴ģʽ����Ʒ�л������ӻ��߼��ٹ���������
     confirm, return,//ͨ�õ�ȷ�Ϸ���
     finish,//����ʱ�������ź�,�ǿ���
     sum, money;//��֧������Ӧ�����

reg [9:0]state = 4'b0000;//��ǰ״̬


parameter S_OFF = 4'b0000,//�ػ� 
          S_INQUIRE = 4'b0001,//�鿴��������ʾ��Ʒ��Ϣ
          S_ADD_AMOUNT = 4'b0011,//�Ѿ�ȷ����Ʒ����ӻ��������
          S_PAYMENT = 4'b0010,//���Ͷ�ң�
          S_SUCCESS = 4'b0110,////����ɹ�
          S_FAILURE = 4'b0111,//����ʧ��
          S_ADM1 = 4'b0101,//����Ա���棬��Ļ��ʾ"�鿴��Ʒ��Ϣ"
          S_ADM2 = 4'b0100,//��Ļ��ʾ"��λ"
          S_ADM3 = 4'b1100,//��Ļ��ʾ"�鿴���۽��"
          S_ADM_INQUIRE = 4'b1101,//����Ա�Ĳ鿴ģʽ��ͬʱ���л��鿴��Ʒ��Ϣ������,ȷ�Ϻ���в���
          S_ADM_ADD = 4'b1111,//����
          S_RESET = 4'b1110,//��λ
          S_SALE_AMOUNT = 4'b1010;//�鿴���۽��鿴���Զ�����


    always@(*)
    begin

        case(state)
            S_OFF:
            if(main_switch)begin
                state = S_INQUIRE;
            end

            S_INQUIRE://��Ʒ���л���ģʽת��û��Ӱ�죬��ģ����ʵ��
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
            /*��Ϊ��������Ķ��ٲ���Ӱ��״̬�ı䣬����״̬������û��������
            �ھ���ģ����ʵ��*/
            if (confirm) begin
                state = S_ADD_AMOUNT;
            end
            if(return)begin
                state = S_INQUIRE;
            end
            end
            
            S_PAYMENT://Ͷ������ֵ������
            begin
            if (sum > money) begin//����ȷ�ϣ����ﵽ�Զ��ж�
                state = S_SUCCESS;
            end 
            if(confirm & return & finish) begin
                state = S_FAILURE;
            end
            end
            
            S_SUCCESS:
            if(confirm & return & finish)begin//�˿���ɣ�����ʱ����
                state = S_INQUIRE;
            end

            S_FAILURE:
            if (confirm & return & finish) begin//�˿���ɣ�����ʱ����
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

            S_ADM_INQUIRE://���л��鿴��Ʒ��Ϣ������ֵ����ʵ��
            if(confirm)begin
                state = S_ADM_ADD;
            end

            S_ADM_ADD://��Ҫ��ȷ��ֵ�����֣����޸�
            if (return) begin
                state = S_ADM_INQUIRE;
            end

            S_RESET:
            //��λ����,��ʾ��λ�ɹ����Զ��ص�ģʽѡ��
            if (finish & confirm & return) begin
                state = S_ADM2;
            end

            S_SALE_AMOUNT:
            //��Ļ��ʾ�����۽�10s���Զ�����
            if (finish & confirm & return) begin
                state = S_ADM3;
            end


            default: 
            state = S_OFF;
        endcase
    
    end
endmodule