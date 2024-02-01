`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


// Square wave generator
// 2 4 bit control signals m and n
// on interval = m*100ns
// off interval = n*100ns
// syncronous and structural
// module SquareWaveGen (
//     input logic clk,  // Clock input
//     input logic rst,  // Reset input
//     input logic [3:0] m,
//     n,  // 4-bit control signals
//     // output logic [7:0] count,
//     output logic square_wave  // Output square wave
// );

//   // Internal signals
//   logic [7:0] count;
//   logic [7:0] high_count;
//   logic [7:0] low_count;
//   // Define states
//   typedef enum logic {
//     LOW,
//     HIGH
//   } state_t;

//   // State register
//   state_t current_state;

//   // Set counts based off m and n
//   always_comb begin
//     high_count = m * 10;
//     low_count  = n * 10;
//   end

//   // State machine
//   always_ff @(posedge clk or posedge rst) begin
//     if (rst) begin
//       current_state <= LOW;
//       count <= 0;
//     end else begin
//       case (current_state)
//         LOW: begin
//           if (count == low_count) begin
//             current_state <= HIGH;
//             count <= 0;
//           end else begin
//             count <= count + 1;
//           end
//         end
//         HIGH: begin
//           if (count == high_count) begin
//             current_state <= LOW;
//             count <= 0;
//           end else begin
//             count <= count + 1;
//           end
//         end
//       endcase
//     end
//   end

//   // Output assignment
//   assign square_wave = (current_state == HIGH);
// endmodule


//SquareWaveGen_basic
module SquareWaveGen_basic (
    input logic clk,  // Clock input
    input logic rst,  // Reset input
    input logic [3:0] m,
    n,  // 4-bit control signals
    // output logic [15:0] count,
    output logic square_wave  // Output square wave

);
  // Internal signals
  logic [23:0] count;
  logic t;

  // T-flip flop
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      square_wave <= 0;
    end else if (t) begin
      square_wave <= ~square_wave;
    end
  end

  // Counter
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
      t <= 0;
    end else begin
      //Ternary for toggle if count is equal to m*10 or m+n*10
      t <= (count == (m * 10) || count == ((m + n) * 10)) ? 1 : 0;
      if (count == ((m + n) * 10)) begin
        count <= 0;
      end
      count <= count + 1;  // Always increment count

    end
  end
endmodule
