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

    reg [STATE_BITS_IDX:0] state;
    wire [STATE_BITS_IDX:0] next_state;
    reg fetch_source;

    always @(posedge clk)
    begin
        if (reset) begin
            pc <= 0;
            state <= STATE_RESET;
            fetch_source <= FETCH_ROM;
        end else begin
            pc <= next_pc;
            state <= next_state;
            fetch_source <= !fetch_source;
        end
    end

    fetcher fetcher(
        .reset(reset),
        .clk(clk),
        .data_in(data_in),
        .fetch_source(fetch_source),
        .pc(pc),
        .state(state),
        .instr(instr),
        .increment_pc(increment_pc),
        .address(address),
        .acc(acc),
        .next_state(next_state)
    );

    /*
    decoder decoder(
        .reset(reset),
        .clk(clk),
        .opcode(opcode),
        .increment_pc(increment_pc)
    );

    executor executor(
        .reset(reset),
        .clk(clk),
        .opcode(opcode),
        .arg(arg),
        .acc(acc)
    );
    */

    assign rom_ram = fetch_source;
    assign addr_data = 0;
    assign data_out = address;
    assign next_pc = pc + increment_pc;
endmodule
