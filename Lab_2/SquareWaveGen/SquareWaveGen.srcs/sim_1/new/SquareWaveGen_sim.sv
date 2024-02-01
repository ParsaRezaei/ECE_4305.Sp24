`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module SquareWaveGen_sim;

  // Signals
  reg clk;
  reg rst;
  wire square_wave;
  // wire [23:0] count;

  // Parameters for m and n
  reg [3:0] m = 1;
  reg [3:0] n = 1;

  // Instantiate the SquareWaveGen module
  SquareWaveGen uut (
      .clk(clk),
      .rst(rst),
      .m(m),
      .n(n),
      // .count(count),
      .square_wave(square_wave)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end
  assign square_wave = uut.square_wave;
  // Test sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;

    // Wait for a few clock cycles
    #20;

    // Release reset
    rst = 0;

    // Wait for a few more clock cycles
    #1000;

    // Assert reset
    rst = 1;

    // Wait for a few more clock cycles
    #20;

    // Release reset
    rst = 0;

    // Wait for a few more clock cycles
    #100;

    // End the simulation
    $finish;
  end

endmodule
