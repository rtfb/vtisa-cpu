module register_file #(
    parameter N_REGS = 8,
    parameter REG_WIDTH = 8,
    parameter ADDR_WIDTH = $clog2(REG_WIDTH)
) (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [ADDR_WIDTH-1:0]   wreg_index,
    input  wire [REG_WIDTH-1:0]    data_in,
    input  wire                    write_enable,
    input  wire [ADDR_WIDTH-1:0]   rreg_index,
    output reg  [REG_WIDTH-1:0]    data_out
);
generate
    reg [REG_WIDTH-1:0] regs [0:N_REGS-1];
    integer i;
    always @(posedge clk)
    begin
        if (reset) begin
            for (i = 0; i < N_REGS; i = i + 1)
            begin
                regs[i] <= 8'h00;
            end
        end else begin
            if (write_enable) begin
                regs[wreg_index] <= data_in;
            end else begin
                data_out <= regs[rreg_index];
            end
        end
    end
endgenerate
endmodule
