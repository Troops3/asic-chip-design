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

  wire _unused = &{ena, rst_n, ui_in, uo_out, uio_in, uio_out, uio_oe};
    
  wire wr_en = not rout_n;
  assign uio_oe  = 8'b0;  // All bidirectional IOs are inputs
  assign uio_out = 8'b0;

  reg [7:0] RAM[RAM_BYTES - 1:0];

  always @(posedge clk) begin
      // case 1: write to ram
      if (wr_en and not rin) begin
          RAM[addr_in] <= data_in; 
      end else if (rin and not wr_en) begin
      // case 2: read to ram
          data_out <= RAM[addr_in];
      end else begin
          // case 3: conflict, do nothing
      end
  end

endmodule  // dff_mem
