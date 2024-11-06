module fetcher (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [7:0]              data_in,
    input  wire                    is_mem_op,
    input  wire                    was_mem_op,
    input  wire [STATE_BITS_IDX:0] state,
    output reg  [BITS_IDX:0]       instr,
    output wire [STATE_BITS_IDX:0] next_state
);
    always @(posedge clk)
    begin
        if (reset) begin
            instr <= 8'h88;  // INC 0 <==> acc += 0 <==> no-op
        end else begin
            case (state)
                STATE_RESET: begin
                end
                STATE_FETCH: begin
                    if (!is_mem_op && !was_mem_op)
                        instr <= data_in;
                    else
                        instr <= 8'h88;  // INC 0 <==> acc += 0 <==> no-op
                end
            endcase
        end
    end

    assign next_state = STATE_FETCH; // TODO: keep fetching for now, later we'll switch to decoding
endmodule

module acc_updater (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [4:0]              opcode,
    input  wire                    from_ram,
    input  wire [7:0]              data_in,
    input  wire [7:0]              new_acc,
    input  wire [7:0]              from_regfile,
    output reg  [BITS_IDX:0]       acc
);
    always @(posedge clk)
    begin
        if (reset) begin
            acc <= 0;
        end else begin
            if (from_ram) begin
                acc <= data_in;
            end else begin
                if (opcode == OP_SETACC) begin
                    acc <= from_regfile;
                end else begin
                    acc <= new_acc;
                end
            end
        end
    end
endmodule
