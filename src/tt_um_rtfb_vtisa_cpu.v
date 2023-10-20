`default_nettype none

/*
    uio_out[0]   - when 0, read from ROM, when 1, read/write from/to RAM
    uio_out[1]   - when 0, uo_out is an address, when 1, uo_out is data
    uio_out[7:2] - unused
*/

module tt_um_rtfb_vtisa_cpu (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = ! rst_n;

    assign uio_oe = 8'b00000011;
    assign uio_out[7:2] = 6'b000000;

    cpu cpu(
        .reset(reset),
        .clk(clk),
        .data_in(ui_in),
        .data_out(uo_out),
        .rom_ram(uio_out[0]),
        .addr_data(uio_out[1])
    );

endmodule
