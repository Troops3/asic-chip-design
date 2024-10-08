`default_nettype none

module tt_um_dff_mem #(
    parameter RAM_BYTES = 16
) (
    input wire [3:0] mar,        // Memory Address Register (MAR) - 4-bit for 16-byte RAM
    input wire [7:0] data_in,    // Data input
    output reg [7:0] data_out,   // Data output
    input wire ce_n,             // Active-low Chip Enable signal (RAM drives the bus)
    input wire lr_n,             // Active-low Load RAM signal (RAM loads from MAR)
    input wire clk               // Clock signal
);

  reg [7:0] RAM[RAM_BYTES - 1:0];

  always @(posedge clk) begin
      if (!lr) begin           // Write to RAM when lr is low (active-low)
          RAM[mar] <= data_in; 
      end else begin           // Read from RAM when lr is high (inactive)
          if (!ce) begin       // RAM can drive the bus only when ce is low
              data_out <= RAM[mar]; 
          end
      end
  end
endmodule
