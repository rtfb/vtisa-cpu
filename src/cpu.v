parameter BITS = 8;
parameter BITS_IDX = BITS - 1;

module cpu(
    input  wire       reset,
    input  wire       clk,
    input  wire [7:0] data_in,
    output wire [7:0] data_out,
    output wire       ram_rom,
    output wire       addr_data
);
    reg [BITS_IDX:0] pc;
    wire [BITS_IDX:0] next_pc;

    always @(posedge clk)
    begin
        if (reset) begin
            pc <= 0;
        end else begin
            pc <= next_pc;
        end
    end

    assign ram_rom = 0;
    assign addr_data = 0;

    assign next_pc = pc + 1;
    assign data_out = pc;
endmodule
