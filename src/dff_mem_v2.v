`default_nettype none

module tt_um_dff_mem #(
    parameter RAM_BYTES = 16
) (
    input  wire [3:0] addr,    // address input
    input  wire [7:0] uio_in,   // IOs: input for writes (8 bits)
    output reg [7:0] uio_out,  // IOs: output for reads (8 bits)
    input wire wr_en,            //write enable
    input wire r_en,             //read enable

    input  wire       ena,      // will go high when the design is enabled
    input  wire       rst_n,     // reset_n - low to reset
    input  wire       clk
);
    localparam addr_bits = 4;

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
