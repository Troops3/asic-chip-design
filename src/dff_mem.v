`default_nettype none

module dff_mem #(
    parameter RAM_BYTES = 16
) (
    input wire [3:0] addr_in,
    input wire [7:0] data_in,
    output wire [7:0] data_out,  
    input  wire       clk,   
    input  wire       rin,     
    input  wire       rout_n,

    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output reg  [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       rst_n     // reset_n - low to reset
);

  localparam addr_bits = $clog2(RAM_BYTES);

  wire [addr_bits-1:0] addr = ui_in[addr_bits-1:0];
  wire wr_en = ui_in[7];
  assign uio_oe  = 8'b0;  // All bidirectional IOs are inputs
  assign uio_out = 8'b0;

  reg [7:0] RAM[RAM_BYTES - 1:0];

  always @(posedge clk) begin
    if (!rst_n) begin
      uo_out <= 8'b0;
      for (int i = 0; i < RAM_BYTES; i++) begin
        RAM[i] <= 8'b0;
      end
    end else begin
      if (wr_en) begin
        RAM[addr] <= uio_in;
      end
      uo_out <= RAM[addr];
    end
  end

endmodule  // dff_mem
