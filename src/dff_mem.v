`default_nettype none

module tt_um_dff_mem #(
    parameter RAM_BYTES = 16
) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output reg  [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       rst_n,     // reset_n - low to reset
    input  wire       clk
);
    localparam addr_bits = 4;
    
  wire [3:0] addr = ui_in[3:0];
  wire wr_en = ui_in[7];
  wire r_en = ui_in[6];
  // assign uio_oe  = 8'b0;  // All bidirectional IOs are inputs
  // assign uio_out = 8'b0;

  reg [7:0] RAM[RAM_BYTES - 1:0];

  always @(posedge clk) begin
      // case 1: write to ram
      if (wr_en && ~r_en) begin
          RAM[addr] <= uio_in; 
      end else if (r_en && ~wr_en) begin
      // case 2: read to ram
          uio_out <= RAM[addr];
      end else begin
          // case 3: conflict, do nothing
      end
  end

endmodule  // tt_um_dff_mem
