module tt_um_dff_mem #(
    parameter RAM_BYTES = 16
) (
    input wire [3:0] mar,        // Address from RAM - 4-bit for 16-byte RAM
    input wire [7:0] data_in,    // Data input
    output reg [7:0] data_out,   // Data output
    input wire ce_n,             // Active-low Chip Enable signal (RAM drives the bus)
    input wire lr_n,             // Active-low Load RAM signal (RAM loads from MAR)
    input wire clk,              // Clock signal
    input wire ena               // Enable signal (from Tiny Tapeout)
);

    localparam addr_bits = 4;

    reg [7:0] RAM[RAM_BYTES - 1:0];

    always @(posedge clk) begin
        if (ena) begin  // Only operate when the design is enabled
            if (!lr_n) begin  // Write to RAM when lr_n is low (active-low)
                RAM[mar] <= data_in; 
            end else if (!ce_n) begin  // Read from RAM when lr_n is high and ce_n is low
                data_out <= RAM[mar]; 
            end
        end
    end
endmodule
