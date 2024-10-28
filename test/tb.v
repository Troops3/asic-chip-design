default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ce_n;
  reg lr_n;
  reg [3:0] mar;       // Address input for RAM (4-bit MAR)
  reg [7:0] data_in;   // 8-bit Data input
  wire [7:0] data_out; // 8-bit Data output

  // Instantiate your tt_um_dff_mem module:
  tt_um_dff_mem user_project (
      .mar      (mar),      // 4-bit memory address
      .data_in  (data_in),  // 8-bit input data
      .data_out (data_out), // 8-bit output data
      .ce_n     (ce_n),     // Active-low chip enable
      .lr_n     (lr_n),     // Active-low load RAM
      .clk      (clk)       // Clock signal
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100 MHz clock
  end
endmodule
