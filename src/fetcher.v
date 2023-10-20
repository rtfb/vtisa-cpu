module fetcher (
    input  wire                    clk,
    input  wire [7:0]              data_in,
    input  wire                    fetch_source,
    input  wire [BITS_IDX:0]       pc,
    input  wire [STATE_BITS_IDX:0] state,
    output reg  [BITS_IDX:0]       instr,
    output wire                    increment_pc,
    output wire [7:0]              address
);
    always @(posedge clk)
    begin
        if (state == STATE_FETCH) begin
            instr <= data_in;
        end
    end

    assign increment_pc = !fetch_source;
    assign address = (fetch_source == FETCH_ROM) ? pc : 5; // TODO: unhardcode the ram address
endmodule
