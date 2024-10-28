`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;   // 8-bit input (ui_in now includes address, ce_n, and lr_n)
  reg [7:0] uio_in;  // Bidirectional input (data_in)
  wire [7:0] uo_out; // Output (data_out)
  wire [7:0] uio_out; // Bidirectional output (data_out when reading)
  wire [7:0] uio_oe;  // Output enable signal

  // Instantiate the module under test:
  tt_um_dff_mem user_project (
      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif

      .ui_in  (ui_in),    // Inputs
      .uo_out (uo_out),   // Outputs
      .uio_in (uio_in),   // Bidirectional input
      .uio_out(uio_out),  // Bidirectional output
      .uio_oe (uio_oe),   // Bidirectional enable (input/output control)
      .ena    (ena),      // Enable signal
      .clk    (clk),      // Clock signal
      .rst_n  (rst_n)     // Active-low reset
  );

  // Clock generation:
  always #5 clk = ~clk;

  // Test sequence:
  initial begin
    // Initialize inputs:
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'b0;
    uio_in = 8'b0;

    // Reset the module:
    #10 rst_n = 1;

    // Write data to RAM at address 0:
    ui_in[3:0] = 4'b0000;  // Address 0
    ui_in[4] = 1'b1;       // ce_n = 1 (disable chip)
    ui_in[5] = 1'b0;       // lr_n = 0 (write mode)
    uio_in = 8'hAA;        // Data to write (0xAA)
    #10;

    // Read data from RAM at address 0:
    ui_in[4] = 1'b0;       // ce_n = 0 (enable chip)
    ui_in[5] = 1'b1;       // lr_n = 1 (read mode)
    #10;

    // Check the output:
    if (uio_out !== 8'hAA) begin
      $display("Test failed! Expected 0xAA, got %h", uio_out);
    end else begin
      $display("Test passed! Read correct value: %h", uio_out);
    end

    // Finish simulation:
    $finish;
  end
endmodule
