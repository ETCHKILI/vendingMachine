`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/22 12:45:50
// Design Name: 
// Module Name: caculation
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
id  name    price
        0.  chip    3   
        1.  milk    4
        2.  cola    5
        3.  cake    6
*/

module caculation(clk, rst_n, state, switch_plus, switch_minus, coin1, coin2, coin5, coin10, id, curr_number, curr_snumber, sum, money, change, sale, out);
input clk, rst_n, 
      switch_plus, switch_minus, 
      coin1, coin2, coin5, coin10;
input [3:0] state;

output reg [1:0] id;
output reg [3:0]curr_number = 4'b0, curr_snumber = 4'b0;
output reg[6:0]sum, money, change;
output reg [9:0]sale;
output reg out;

reg [3:0]number;



parameter MAX_NUM = 4'b1111;
//reg [3:0]upb1, upb2;
reg [3:0]number0 = 4'b0, snumber0 = 4'b0, 
         number1 = 4'b0, snumber1 = 4'b0, 
         number2 = 4'b0, snumber2 = 4'b0, 
         number3 = 4'b0, snumber3 = 4'b0;


always@(clk) begin
case (state)
   4'b0001|4'b1101: begin //两种查看模式，切换id
       number = 7'b1;
      case ({switch_plus, switch_minus})
          2'b01: id <= id + 2'b11;
          2'b10: id <= id + 2'b01;
          default: id <= id;
      endcase 
   end
   4'b0011: begin //改变购买数量
       case ({switch_plus, switch_minus})
          2'b01: begin
              if (number == 4'b0001) begin
                  number <= number + 2'b11;
              end
          end
          2'b10: begin
              if(number < curr_number) begin
                  number <= number + 2'b01;
              end
          end
          default: number <= number;
       endcase
   end
    4'b0010: begin //投币
        case ({coin1, coin2, coin5, coin10})
            4'b1000: sum <= sum + 7'd1;
            4'b0100: sum <= sum + 7'd2;
            4'b0010: sum <= sum + 7'd5;
            4'b0001: sum <= sum + 7'd10;
            default: sum <= sum;
        endcase
   end
   4'b0110: begin //支付成功，增加销量和�???售金额并对数据清�???
       case (id)
       2'b00: snumber0 <= snumber0 + number;
       2'b01: snumber1 <= snumber1 + number;
       2'b10: snumber2 <= snumber2 + number;
       2'b11: snumber3 <= snumber3 + number;
       endcase
       sale <= number + money;
       number <= 4'b0; 
       sum <= 7'b0;
   end
   4'b1111: begin //添加补货的数�???
       case ({switch_plus, switch_minus})
          2'b01: begin
              if (number == 4'b0000) begin
                  number <= number + 2'b11;
              end
          end
          2'b10: begin
              if(number <= MAX_NUM - curr_number) begin
                  number <= number + 2'b01;
              end
          end
          default: number <= number;
       endcase
   end
   4'b1110|4'b0000: begin //每次关机复位，或者按下复位键复位
       number0 <= 4'b0;
       number1 <= 4'b0;
       number2 <= 4'b0;
       number3 <= 4'b0;
       snumber0 <= 4'b0;
       snumber1 <= 4'b0;
       snumber2 <= 4'b0;
       snumber3 <= 4'b0;
       sale <= 10'b0;
   end
   4'b1011: begin//补货成功，对数据清零
       case (id)
           2'b00: number0 <= number0 + number;
           2'b01: number1 <= number1 + number;
           2'b10: number2 <= number2 + number;
           2'b11: number3 <= number3 + number;
       endcase
       number <= 4'b0;
   end
   default: sum <= 7'b0;
endcase
end


always@(posedge clk) begin
    case (id)
        2'b00: begin
            curr_number = number0;
            curr_snumber = number0;
        end
        2'b01: begin
            curr_number = number1;
            curr_snumber = number1;
        end
        2'b10: begin
            curr_number = number2;
            curr_snumber = number2;
        end
        2'b11: begin
            curr_number = number3;
            curr_snumber = number3;
        end
    endcase
end

always@(posedge clk) begin
    case (id)
        2'b00: sum = curr_number*3;
        2'b01: sum = curr_number*4;
        2'b10: sum = curr_number*5;
        2'b11: sum = curr_number*6;
    endcase
end

always@(posedge clk) begin
    if(sum >= money) begin
        change <= sum - money;
    end
    else begin
        change <= money;
    end 
end

always@(posedge clk) begin
    if(curr_number == 0) begin
        out <= 1'b1;
    end
    else begin
        out <= 1'b0;
    end
end

endmodule

