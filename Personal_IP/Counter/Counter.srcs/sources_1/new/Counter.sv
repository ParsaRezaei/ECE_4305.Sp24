`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// N-bit counter

module Counter #(
    parameter N = 4
) (
    input logic clk,  // Clock input
    input logic rst,  // Reset input
    output logic [N-1:0] count  // Output count
);

  // Internal signals
  logic [N-1:0] count_next;

  // Assignments
  always_ff @(posedge clk, posedge rst) begin
    if (rst) count_next <= 0;
    else count_next <= count + 1;
  end

  assign count = count_next;

endmodule

