module executor (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [7:0]              acc,
    input  wire                    is_alu_op,
    input  wire                    is_mem_op,
    input  wire                    mem_rw,
    input  wire[2:0]               imm,
    input  wire[2:0]               register,
    input  wire[4:0]               opcode,
    output reg [7:0]               new_acc
);
    always @(posedge clk)
    begin
        if (reset) begin
        end else begin
            case (opcode)
                OP_LI: begin
                    new_acc <= 5'b00000 | imm;
                end
            endcase
        end
    end
endmodule
