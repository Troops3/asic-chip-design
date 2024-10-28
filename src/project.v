module tt_um_dff_mem #(
    parameter RAM_BYTES = 16
) (
    input wire [7:0] ui_in,      // Inputs (use certain bits to represent ce_n, lr_n, etc.)
    input wire [7:0] uio_in,     // Bidirectional input
    output reg [7:0] uo_out,     // Output (data_out)
    output reg [7:0] uio_out,    // Bidirectional output
    output reg [7:0] uio_oe,     // Bidirectional control (input/output enable)
    input wire clk,              // Clock signal
    input wire rst_n,            // Active-low reset
    input wire ena               // Enable signal (from Tiny Tapeout)
);

    localparam addr_bits = 4;
    wire [7:0] data_out;

    reg [7:0] RAM[RAM_BYTES - 1:0];
    wire [3:0] mar = ui_in[3:0];  // Use ui_in[3:0] for the address
    wire [7:0] data_in = uio_in;  // Map uio_in to data_in
    assign uo_out = data_out;     // Map data_out to uo_out

    // Use specific bits of ui_in for ce_n and lr_n control
    wire ce_n = ui_in[4];  // Map ui_in[4] to ce_n
    wire lr_n = ui_in[5];  // Map ui_in[5] to lr_n

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            integer i;
            for (i = 0; i < RAM_BYTES; i = i + 1) begin
                RAM[i] <= 8'b0;
            end
            uio_out <= 8'b0;
        end else if (ena) begin  // Operate when enabled
            if (!lr_n) begin  // Write to RAM when lr_n is low
                RAM[mar] <= data_in; 
            end else if (!ce_n) begin  // Read from RAM when ce_n is low
                uio_out <= RAM[mar]; 
            end
        end
    end

    // Control bidirectional pins
    assign uio_oe = ~lr_n;  // Output when not writing (lr_n is high)

endmodule
