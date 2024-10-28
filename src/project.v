module tt_um_dff_mem #(
    parameter RAM_BYTES = 16
) (
    input wire [7:0] ui_in,      // Use ui_in for inputs
    input wire [7:0] uio_in,     // Use uio_in for bidirectional pins (data_in)
    output reg [7:0] uo_out,     // Use uo_out for outputs (data_out)
    output reg [7:0] uio_out,    // Use uio_out for bidirectional pins
    output reg [7:0] uio_oe,     // Use uio_oe for bidirectional control (active high: 0=input, 1=output)
    input wire ce_n,             // Active-low Chip Enable signal (RAM drives the bus)
    input wire lr_n,             // Active-low Load RAM signal (RAM loads from MAR)
    input wire clk,              // Clock signal
    input wire rst_n,            // Active-low Reset signal
    input wire ena               // Enable signal (from Tiny Tapeout)
);

    localparam addr_bits = 4;

    reg [7:0] RAM[RAM_BYTES - 1:0];
    wire [3:0] mar = ui_in[3:0];  // Map ui_in to mar (address)
    wire [7:0] data_in = uio_in;  // Map uio_in to data_in
    assign uo_out = data_out;     // Map data_out to uo_out

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear RAM on reset or perform any necessary initialization
            integer i;
            for (i = 0; i < RAM_BYTES; i = i + 1) begin
                RAM[i] <= 8'b0;
            end
            uio_out <= 8'b0;
        end else if (ena) begin  // Only operate when the design is enabled
            if (!lr_n) begin  // Write to RAM when lr_n is low (active-low)
                RAM[mar] <= data_in; 
            end else if (!ce_n) begin  // Read from RAM when lr_n is high and ce_n is low
                uio_out <= RAM[mar]; 
            end
        end
    end

    // Enable/Disable bidirectional pins
    assign uio_oe = ~lr_n;  // If lr_n is low, data is input (write mode), else it's output (read mode)
    
endmodule
