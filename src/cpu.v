parameter BITS = 8;
parameter BITS_IDX = BITS - 1;
parameter STATE_BITS = 2;
parameter STATE_BITS_IDX = STATE_BITS - 1;

parameter STATE_RESET = 0;
parameter STATE_FETCH = 1;
parameter STATE_DECODE = 2;
parameter STATE_EXECUTE = 3;

parameter FETCH_ROM = 0;
parameter FETCH_RAM = 1;

module cpu(
    input  wire       reset,
    input  wire       clk,
    input  wire [7:0] data_in,
    output wire [7:0] data_out,
    output wire       rom_ram,
    output wire       addr_data
);
    reg [BITS_IDX:0] pc;
    reg [BITS_IDX:0] acc;
    wire [BITS_IDX:0] next_pc;
    wire increment_pc;
    reg [BITS_IDX:0] instr;
    wire [BITS_IDX:0] address;

    wire [BITS_IDX:0] new_acc;
    wire [BITS_IDX:0] from_regfile;

    reg [STATE_BITS_IDX:0] state;
    wire [STATE_BITS_IDX:0] next_state;

    wire is_alu_op;
    wire is_mem_op;
    reg was_mem_op;
    wire mem_rw;
    wire [2:0] imm;
    wire [2:0] register;
    wire [4:0] opcode;

    always @(posedge clk)
    begin
        if (reset) begin
            pc <= 0;
            state <= STATE_RESET;
            was_mem_op <= 0;
        end else begin
            pc <= next_pc;
            state <= next_state;
            was_mem_op <= is_mem_op;
        end
    end

    fetcher fetcher(
        .reset(reset),
        .clk(clk),
        .data_in(data_in),
        .is_mem_op(is_mem_op),
        .was_mem_op(was_mem_op),
        .state(state),
        .instr(instr),
        .next_state(next_state)
    );

    decoder decoder(
        .reset(reset),
        .clk(clk),
        .instr(instr),
        .increment_pc(increment_pc),
        .is_alu_op(is_alu_op),
        .is_mem_op(is_mem_op),
        .mem_rw(mem_rw),
        .imm(imm),
        .register(register),
        .opcode(opcode)
    );

    executor executor(
        .reset(reset),
        .clk(clk),
        .pc(pc),
        .acc(acc),
        .is_alu_op(is_alu_op),
        .is_mem_op(is_mem_op),
        .mem_rw(mem_rw),
        .imm(imm),
        .register(register),
        .opcode(opcode),
        .address(address),
        .new_acc(new_acc)
    );

    acc_updater acc_updater(
        .reset(reset),
        .clk(clk),
        .opcode(opcode),
        .from_ram(was_mem_op),
        .data_in(data_in),
        .new_acc(new_acc),
        .from_regfile(from_regfile),
        .acc(acc)
    );

    register_file register_file(
        .reset(reset),
        .clk(clk),
        .wreg_index(register),
        .data_in(opcode == OP_GETACC ? acc : data_in),
        .write_enable(was_mem_op),  // TODO: generalize
        .rreg_index(register),
        .data_out(from_regfile)
    );

    assign rom_ram = is_mem_op;
    assign addr_data = 0;
    assign data_out = address;
    assign next_pc = pc + increment_pc;
endmodule
