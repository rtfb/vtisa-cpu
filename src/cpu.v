
module cpu(
    input  wire       reset,
    input  wire       clk,
    input  wire [7:0] data_in,
    output wire [7:0] data_out,
    input  wire [7:0] bidi_in,
    output wire [7:0] bidi_out
);
    assign data_out = 8'h01;
    assign bidi_out = 8'h00;
endmodule
