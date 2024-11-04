parameter OP_LI  = 5'b00001;
parameter OP_LD  = 5'b00010;
parameter OP_ST  = 5'b00011;
parameter OP_INC = 5'b10001;

module decoder (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [7:0]              instr,
    output wire                    increment_pc,
    output wire                    is_alu_op,
    output wire                    is_mem_op,
    output wire                    mem_rw,
    output wire[2:0]               imm,
    output wire[2:0]               register,
    output wire[4:0]               opcode
);
    always @(posedge clk)
    begin
        if (reset) begin
        end else begin
        end
    end

    assign opcode = instr[7:3];
    assign is_mem_op = opcode == OP_LD || opcode == OP_ST;
    assign mem_rw = instr[3];
    assign increment_pc = !is_mem_op;
    assign imm = (opcode == OP_LI || opcode == OP_INC) ? instr[2:0] : 0;
    assign register = instr[2:0];
endmodule
