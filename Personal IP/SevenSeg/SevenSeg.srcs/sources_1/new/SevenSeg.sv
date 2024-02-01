`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Seven Segment Translator - number to 7 segment display
module SevenSegTranslator (
    input  wire [3:0] number,
    output wire [7:0] segments_out
);

  reg [7:0] segments = 8'b11111111;

  always @(*) begin
    case (number)
      4'b0000: segments = 8'b11000000;  // 0
      4'b0001: segments = 8'b11111001;  // 1
      4'b0010: segments = 8'b10100100;  // 2
      4'b0011: segments = 8'b10110000;  // 3
      4'b0100: segments = 8'b10011001;  // 4
      4'b0101: segments = 8'b10010010;  // 5
      4'b0110: segments = 8'b10000010;  // 6
      4'b0111: segments = 8'b11111000;  // 7
      4'b1000: segments = 8'b10000000;  // 8
      4'b1001: segments = 8'b10010000;  // 9
      4'b1010: segments = 8'b10001000;  // A
      4'b1011: segments = 8'b10000011;  // B
      4'b1100: segments = 8'b11000110;  // C
      4'b1101: segments = 8'b10100001;  // D
      4'b1110: segments = 8'b10000110;  // E
      4'b1111: segments = 8'b10001110;  // F
      default: segments = 8'b11111111;  // Blank
    endcase
  end

  assign segments_out = segments;
endmodule

//Driver for Seven Segment Displays
module SevenSegDriver #(
    parameter N = 8,  // Number of displays
    parameter SYS_CLK_FREQ = 100_000_000,  // System clock frequency (100 MHz)
    parameter DISP_CLK_FREQ = 4  // Display clock frequency (400 Hz)
) (
    input wire clk,  // System clock
    input wire [N*4-1:0] data,  // 32-bit data input
    output wire [N-1:0] enable,  // 8-bit enable signal
    output wire [7:0] seg  // 7-segment display output
);

  reg [31:0] clk_divider = 0;  // Clock divider
  reg [ 2:0] disp_select = 0;  // Display selector

  // Clock divider
  always @(posedge clk) begin
    if (clk_divider == SYS_CLK_FREQ / DISP_CLK_FREQ - 1) begin
      clk_divider <= 0;
      disp_select <= disp_select + 1;
    end else begin
      clk_divider <= clk_divider + 1;
    end
  end


  // Enable signal
  assign enable = (1 << disp_select);

  // 7-segment display translator
  SevenSegTranslator sst (
      .number(data[disp_select*8+:4]),
      .segments_out(seg[7:0])
  );



endmodule

module SevenSeg (
    input wire switches[7:0],
    input clk,
    output reg [7:0] segments,
    output reg [7:0] enable
);

  wire [31:0] data;  // Data for the displays

  reg [3:0] decimalDigits[0:7];  // Assuming we need two digits for representation

  always @(switches) begin
    // Convert switches to binary
    int binaryValue = 0;
    for (int i = 0; i < 8; i = i + 1) begin
      binaryValue = binaryValue + switches[i] * (1 << i);
    end

    // Convert binary to two decimal digits
    decimalDigits[0] = binaryValue % 10;  // units place
    decimalDigits[1] = binaryValue / 10;  // tens place
    decimalDigits[2] = binaryValue / 100;  // hundreds place
    decimalDigits[3] = binaryValue / 1000;  // thousands place
    decimalDigits[4] = binaryValue / 10000;  // ten thousands place
    decimalDigits[5] = binaryValue / 100000;  // hundred thousands place
    decimalDigits[6] = binaryValue / 1000000;  // millions place
    decimalDigits[7] = binaryValue / 10000000;  // ten millions place
  end

  assign data = {
    decimalDigits[7],
    decimalDigits[6],
    decimalDigits[5],
    decimalDigits[4],
    decimalDigits[3],
    decimalDigits[2],
    decimalDigits[1],
    decimalDigits[0]
  };

  // 7-segment display driver
  SevenSegDriver #(
      .N(8),
      .SYS_CLK_FREQ(100000000),
      .DISP_CLK_FREQ(400)
  ) sdd (
      .clk(clk),
      .data(data),
      .enable(enable),
      .seg(segments)
  );

endmodule
