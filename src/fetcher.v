module fetcher (
    input  wire                    reset,
    input  wire                    clk,
    input  wire [7:0]              data_in,
    input  wire                    fetch_source,
    input  wire [BITS_IDX:0]       pc,
    input  wire [STATE_BITS_IDX:0] state,
    output reg  [BITS_IDX:0]       instr,
    output wire                    increment_pc,
    output wire [7:0]              address,
    output reg  [BITS_IDX:0]       acc,
    output wire [STATE_BITS_IDX:0] next_state
);
    always @(posedge clk)
    begin
        if (reset) begin
            instr <= 8'h00;
        end else begin
            case (state)
                STATE_RESET: begin
                end
                STATE_FETCH: begin
                    if (fetch_source == FETCH_ROM)
                        instr <= data_in;
                    else
                        acc <= data_in;
                end
            endcase
        end
    end

    assign address = (fetch_source == FETCH_ROM) ? pc : 5; // TODO: unhardcode the ram address
    assign next_state = STATE_FETCH; // TODO: keep fetching for now, later we'll switch to decoding
    assign increment_pc = fetch_source;
endmodule
