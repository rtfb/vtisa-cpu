module executor (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [BITS_IDX:0]       pc,
    input  wire [7:0]              acc,
    input  wire                    is_alu_op,
    input  wire                    is_mem_op,
    input  wire                    mem_rw,
    input  wire[2:0]               imm,
    input  wire[2:0]               register,
    input  wire[4:0]               opcode,
    output wire [7:0]              address,
    output wire [7:0]              new_acc
);
    always @(posedge clk)
    begin
        if (reset) begin
        end else begin
        end
    end

    assign new_acc = opcode == OP_LI ? 5'b00000 | imm : acc + imm;
    assign address = is_mem_op ? acc : pc;
endmodule
