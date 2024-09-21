parameter OP_LI = 5'b00001;
parameter OP_LD = 5'b00010;
parameter OP_ST = 5'b00011;

module decoder (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [7:0]              instr,
    input  wire                    fetch_source, // XXX: this is temp, should not need it later
    output wire                    increment_pc,
    output wire                    is_alu_op,
    output wire                    is_mem_op,
    output wire                    mem_rw,
    output wire[2:0]               imm,
    output wire[2:0]               register
);
    always @(posedge clk)
    begin
        if (reset) begin
        end else begin
        end
    end

    assign is_mem_op = instr[7:3] == OP_LD || instr[7:3] == OP_ST;
    assign mem_rw = instr[3];
    assign increment_pc = fetch_source;
    assign imm = instr[2:0];
    assign register = instr[2:0];
endmodule
