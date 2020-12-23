`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 14:54:11
// Design Name: 
// Module Name: b_to_bcd
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

module bi_to_bcd4(binary, bcd1, bcd0);
input[3:0] binary;
output reg [3:0] bcd1, bcd0;

always@(binary)begin
    if (binary > 4'b1001) begin
        bcd1 <= 4'b0001;
        bcd0 <= binary + 4'b0110;
    end
    else begin
        bcd0 <= binary;
    end
end
endmodule


module bi_to_bcd7(binary, bcd1, bcd0);
input[6:0] binary;
output reg[3:0] bcd1, bcd0;

reg [3:0]number1;
reg [8:0] number2;


always@(binary) begin
    number1 = binary[3:0];
    case (binary[6:4])
        3'd0: number2 <= 9'h000;
        3'd1: number2 <= 9'h016;
        3'd2: number2 <= 9'h032;
        3'd3: number2 <= 9'h048;
        3'd4: number2 <= 9'h064;
        3'd5: number2 <= 9'h080;
        3'd6: number2 <= 9'h096;
        3'd7: number2 <= 9'h112;
    endcase
end

always@(number1, number2) begin
    if(number1 + number2[3:0] < 10) begin
        bcd0 <= number1 + number2;
        bcd1 <= number2[7:4];
    end
    else begin
        bcd0 <= number1 + number2 + 6;
        bcd1 <= number2[7:4] + 1;
    end
end

endmodule

module bi_to_bcd10(binary, bcd2, bcd1, bcd0);
input[9:0] binary;
output reg[3:0] bcd2, bcd1, bcd0;

reg [3:0] number1, number0 = 4'b0;
reg [9:0] number2;
reg [11:0] number3;

always@(binary) begin
    number1 = binary[3:0];
    case (binary[7:4])
        4'd0: number2 <= 10'h000;
        4'd1: number2 <= 10'h016;
        4'd2: number2 <= 10'h032;
        4'd3: number2 <= 10'h048;
        4'd4: number2 <= 10'h064;
        4'd5: number2 <= 10'h080;
        4'd6: number2 <= 10'h096;
        4'd7: number2 <= 10'h112;
        4'd8: number2 <= 10'h128;
        4'd9: number2 <= 10'h144;
        4'd10: number2 <= 10'h160;
        4'd11: number2 <= 10'h176;
        4'd12: number2 <= 10'h192;
        4'd13: number2 <= 10'h208;
        4'd14: number2 <= 10'h224;
        4'd15: number2 <= 10'h240;
    endcase
end

always@(binary) begin
    case (binary[9:8])
        2'd0: number3 <= 12'h00;
        2'd1: number3 <= 12'h256;
        2'd2: number3 <= 12'h512;
        2'd3: number3 <= 12'h768;
    endcase
end

always@(*) begin

    if(number1 + number2[3:0] + number3[3:0] < 10) begin
        bcd0 <= number1 + number2 + number3;
        number0 <= 4'd0;
    end
    else if(number1 + number2[3:0] + number3[3:0] < 20) begin
        bcd0 <= number1 + number2 + number3[3:0] + 6;
        number0 <= 4'd1;
    end
    else if (number1 + number2[3:0] + number3[3:0] < 30) begin
        bcd0 <= number1 + number2 + number3[3:0] + 12;
        number0 <= 4'd2;
    end
    else if (number1 + number2[3:0] + number3[3:0] < 40) begin
        bcd0 <= number1 + number2 + number3[3:0] + 18;
        number0 <= 4'd3;
    end
    else begin
        bcd0 <= number1 + number2 + number3[3:0] + 24;
        number0 <= 4'd4;
    end
end

always@(*) begin  
    if(number0 + number2[7:4] + number3[7:4] < 10) begin
        bcd1 <= number0 + number2[7:4] + number3[7:4];
        bcd2 <= number2[9:8] + number3[11:8] ;
    end
    else if(number0 + number2[7:4] + number3[7:4] < 20) begin
        bcd1 <= number0 + number2[7:4] + number3[7:4] + 6;
        bcd2 <= number2[9:8] + number3[11:8] + 1;
    end
    else if (number0 + number2[7:4] + number3[7:4] < 30) begin
        bcd1 <= number0 + number2[7:4] + number3[7:4] + 12;
        bcd2 <= number2[9:8] + number3[11:8] + 2;
    end
    else begin
        bcd1 <= number0 + number2[7:4] + number3[7:4] + 18;
        bcd2 <= number2[9:8] + number3[11:8] + 3;
    end
end

endmodule