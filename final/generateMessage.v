`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 22:21:25
// Design Name: 
// Module Name: generateMessage
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




//module numToLed3D(
//    input [3:0] huns,tens,ones,
//    output [7:0] led_hun,led_ten,led_one
//);
//    numToled l1(tens,led_ten);
//    numToled l2(ones,led_one);    
//endmodule

//module numToLed2D(
//    input [3:0] tens,ones,
//    output [7:0] led_ten,led_one
//);
//    numToled l1(tens,led_ten);
//    numToled l2(ones,led_one);
//endmodule
module generateScreen(
    input 
    rawclk,
    clk,//1s
     rst_n,
    idChange,//pos and neg
    [3:0]state,
    [1:0]id,//current ID of goods
    [3:0]total_huns,totaltens,total_ones,
    [3:0]num_tens,num_ones,adin_tens,adin_ones,// num add in
    [3:0]sell_tens,sell_ones,
    [3:0]paid_tens,paid_ones,bill_tens,bill_ones,
    [3:0] charge_tens,charge_ones,
    
    output 
    reg finish,
    reg[7:0] seg_en,
    reg[7:0] seg_out
);
    reg [63:0] l;
    wire [63:0] mes;
    reg enInquire;
    reg [31:0] name;
    reg en1,en2,en3,en4,en5,en6,en7,en8;
    run(clk,idChange,enInquire,id,num_tens,num_ones,mes);
    
    numToLed(num_tens,num1);
    numToLed(num_ones,num2);
    numToLed(adin_tens,adin1);  // buy nums
    numToLed(adin_ones,adin2);
    
    numToLed(paid_tens,paid1);
    numToLed(paid_ones,paid2);
    numToLed(bill_tens,bill1);
    numToLed(bill_ones,bill2);
    
    numToLed(charge_tens,charge1);
    numToLed(charge_ones,charge2);
    
    numToLed(sell_tens,sell1);
    numToLed(sell_ones,sell2);
    
    numToLed(total_huns,total1);
    numToLed(total_tens,total2);
    numToLed(total_ones,total3);
    
    countdown30 c1(en1,clk,f1);
    countdown2 c2(en2,clk,f2);
    countdown2 c3(en3,clk,f3);
    countdown2 c4(en4,clk,f4);
    countdown2 c5(en5,clk,f5);
    countdown2 c6(en6,clk,f6);
    countdown2 c7(en7,clk,f7);
    countdown2 c8(en8,clk,f8);
    
    always@(state) begin
        case(state)
        4'b0010:begin en1<=1;    {en2,en3,en4,en5,en6,en7,en8}<=7'b0; finish<=f1;end
        4'b0110:begin en2<=1;    {en1,en3,en4,en5,en6,en7,en8}<=7'b0; finish<=f2;end
        4'b0010:begin en3<=1;    {en1,en2,en4,en5,en6,en7,en8}<=7'b0; finish<=f3;end
        4'b0010:begin en4<=1;    {en1,en2,en3,en5,en6,en7,en8}<=7'b0; finish<=f4;end         
        4'b0010:begin en5<=1;    {en1,en2,en3,en4,en6,en7,en8}<=7'b0; finish<=f5;end        
        4'b0010:begin en6<=1;    {en1,en2,en3,en4,en5,en7,en8}<=7'b0; finish<=f6;end   
        4'b0010:begin en7<=1;    {en1,en2,en3,en4,en5,en6,en8}<=7'b0; finish<=f7;end
        4'b0010:begin en8<=1;    {en1,en2,en3,en4,en5,en6,en7}<=7'b0; finish<=f8;end    
        endcase
    end
    
    reg[2:0]count;
    wire [7:0] l1,l2,l3,l4,l5,l6,l7,l8;
    assign {l1,l2,l3,l4,l5,l6,l7,l8}=l;
    always @ (posedge rawclk,negedge rst_n)
    begin
        if(~rst_n)
        begin
        count <= 0;
        end
        else
        begin
            if(count == 5)
            begin
                count <= 0;
            end
            else
            begin
                count <= count +1;
            end
        end
    end
    always @ (count)
    begin
        case (count)
            3'b000:
            begin
                seg_out <= l8;
                seg_en <= 8'b11111110;
            end
            3'b001:
            begin
                seg_out <= l7;
                seg_en <= 8'b11111101;
            end
            3'b010:
            begin
                seg_out <= l6;
                seg_en <= 8'b11111011;
            end
            3'b011:
            begin
                seg_out <= l5;
                seg_en <= 8'b11110111;
            end
            3'b100:
            begin
                seg_out <=l4;
                seg_en <= 8'b11101111;
            end
            3'b101:
            begin
                seg_out <= l3;
                seg_en <= 8'b11011111;      
            end 
            3'b110:
            begin
                seg_out <= l2;
                seg_en <= 8'b10111111;      
            end 
            3'b111:
            begin
                seg_out <= l1;
                seg_en <= 8'b01111111;      
            end 
            default
            begin
                seg_out <= 8'b11111111;
                seg_en <= 8'b11111111;
            end
         endcase    
    end    
   
    always@(state) begin
        if(state==4'b0001)begin
            enInquire<=1;
        end
        else begin
            enInquire<=0;
        end
    end
    
    always@(id) begin
        case(id)
            0:name<=32'b01011000_01110110_00010000_01110011;
            1:name<=32'b01010101_00010000_00111000_01111010;
            2:name<=32'b01011000_01011100_00111000_01110111;
            3:name<=32'b01011000_01110111_01111010_01111001;
        endcase
    end
    
    always@* begin
        case(state)
           4'b0000:l<=0;//off
            4'b0001:l<=mes;//inquire
            4'b0011:l<={num1,num2,32'b0,adin1,adin2};//add
            4'b0010:l<={bill1,bill2,32'b0,paid1,paid2};//coin
            
            4'b0110:l<={32'b01100100_00111110_01011000_01100100,16'b0,charge1,charge2};
            //success
            4'b0111:l<=64'b01110001_01110111_00010000_00111000_00111110_01010000_01111001_00000000;
            //failure
            4'b0101:l<=64'b00010000_01010100_01100111_00111110_00010000_01010000_01111001_00000000;
            //inquire
            4'b0100:l<=64'b01010000_01111001_01100100_01111001_01111000_00000000_00000000_00000000;
            //reset
            4'b1100:l<=64'b01111000_01011100_01111000_01110111_00111000_00000000_00000000_00000000;
            //total
            
            4'b1101:l<={name,num1,num2,sell1,sell2};
            //name,number,sell
            
            4'b1111:l<={name,num1,num2,adin1,adin2};
            //admin add
            
            4'b1110:l<=64'b01100100_00111110_01011000_01011000_01111001_01100100_01100100_00000000;
            //reset! sucs
            
            4'b1010:l<={total1,total2,total3,40'b0};//total amount
            4'b1011:l<=64'b01100100_00111110_01011000_01011000_01111001_01100100_01100100_00000000;
            //suc adm
            4'b1001:l<=64'b01101010_01111001_00111000_01011000_01011100_01010101_01111001_00000000;
            //welcome
            4'b1000:l<=64'b01100100_01011100_00111000_01011110_00000000_01011100_00111110_01111000;
            //sold out
        endcase
    
    end
    
    

 endmodule
 
 
module numToLed(
    input [3:0] number,
    output  [7:0] l
);
    reg [7:0] led;
    assign l=~{led[0],led[1],led[2],led[3],led[4],led[5],led[6],led[7]};
    
    always@* begin
        case(number)
            0: led<=8'b11111100;
            1: led<=8'b01100000;
            2: led<=8'b11011010;
            3: led<=8'b11110010;
            4: led<=8'b01100110;
            5: led<=8'b10110110;
            6: led<=8'b10111110;
            7: led<=8'b11100000;
            8: led<=8'b11111110;

            9: led<=8'b11100110;
        endcase
    end
endmodule

module stringToLed(
    input[4:0] string,
    output [7:0] l
   
);
    reg [7:0] led;
    assign l=~{led[0],led[1],led[2],led[3],led[4],led[5],led[6],led[7]};
    always@* begin
    case(string)
        0:led<=8'b11101110;//a
        1:led<=8'b00111110;
        2:led<=8'b00011010;
        3:led<=8'b01111010;
        4:led<=8'b10011110;
        5:led<=8'b10001110;
        6:led<=8'b10111100;
        7:led<=8'b01101110;
        8:led<=8'b00001000;
        9:led<=8'b01110000;
        10:led<=8'b01011110;
        11:led<=8'b00011100;
        12:led<=8'b10101010;
        13:led<=8'b00101010;
        14:led<=8'b00111010;
        15:led<=8'b11001110;
        16:led<=8'b11100110;
        17:led<=8'b00001010;
        18:led<=8'b00100110;
        19:led<=8'b00011110;
        20:led<=8'b01111100;
        21:led<=8'b01000110;
        22:led<=8'b01010110;
        23:led<=8'b01101100;
        24:led<=8'b01110110;
        25:led<=8'b10010010;//z
        26:led<=8'b00000000;//" "
        27:led<=8'b00000010;//"-"
    endcase
    end

endmodule

module run(//inquire
    input 
    clk,//1s
    idChange,
    rst_n,
    [1:0]id,
    [3:0]num_tens,num_ones,//,sell_tens,sell_ones//tmp id's num and sell

    output [63:0]l
);
    wire [19:0]name0=20'b00010_00111_01000_01111;//chip
    wire [19:0]name1=20'b01100_01000_01011_01010;//milk
    wire [19:0]name2=20'b00010_01110_01011_00000;//cola
    wire [19:0]name3=20'b00010_00000_01010_00100;//cake
        
    reg[7:0] mes0=8'b0100_0000; 
    wire[7:0] mes12=8'b0100_0000;
    wire [7:0]mes2=0;
    wire [7:0]mes7=0;
    wire [7:0]mes10=0;
    
    wire [7:0] mes1,mes3,mes4,mes5,mes6,mes8,mes9,mes11;//message;
    reg [19:0]name;
    reg [2:0]price;
   
    always@(id) begin
        case(id)
            0:begin name=name0;price=3;end
            1:begin name=name1;price=4;end
            2:begin name=name2;price=5;end
            3:begin name=name3;price=6;end
        endcase
    end
   
    
       
    numToLed n1(id,mes1);
    stringToLed n3(name[19:15],mes3);
    stringToLed n4(name[14:10],mes4);
    stringToLed n5(name[9:5],mes5);
    stringToLed n6(name[4:0],mes6);
    numToLed n8(num_tens,mes8);
    numToLed n9(num_ones,mes9);
    numToLed n11(price,mes11);
    
    reg[8*13-1:0] message;    
    assign l=message[103:40];
    
    always@(posedge clk,negedge rst_n,posedge idChange) begin
        if(~rst_n) begin
            message<={mes0,mes1,mes2,mes3,mes4,mes5,mes6,mes7,mes8,mes9,mes10,mes11,mes12};
        end
        else begin
            if(idChange) begin
                message<={mes0,mes1,mes2,mes3,mes4,mes5,mes6,mes7,mes8,mes9,mes10,mes11,mes12};
            end
            else begin
                message<={message[95:0],message[103:96]};
            end
        end
    end
endmodule


 
module countdown30(
    input 
    en,
    clk,//1s
    output reg finish
);
    reg [4:0]cnt;
    
    always@(posedge clk,negedge en) begin
        if(en) begin
            cnt<=cnt+1;
        end
        else begin
            cnt<=5'b0;
        end
    end
    
    always@(cnt) begin
        if(cnt<30)begin
            finish<=0;
        end
        else begin
            finish<=~finish;
        end
    end

endmodule

module countdown2(
    input 
    en,
    clk,//1s
    output reg finish
);
    reg [4:0]cnt;
    
    always@(posedge clk,negedge en) begin
        if(en) begin
            cnt<=cnt+1;
        end
        else begin
            cnt<=5'b0;
        end
    end
    
    always@(cnt) begin
        if(cnt<2)begin
            finish<=0;
        end
        else begin
            finish<=~finish;
        end
    end

endmodule