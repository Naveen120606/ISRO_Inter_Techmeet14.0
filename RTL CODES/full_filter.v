`timescale 1ns / 1ps

module full_filter#(
    parameter IW = 2,
    parameter OW = 20,
    parameter N=2,
    parameter R1=1024,
    parameter R2=2
)(
    input clk,
    input rst,
    input en,
    input signed[IW-1:0] din,
    output [OW-1:0] dout
    // output out_ready
);
    wire signed [OW-1:0] cic_out;
    wire out_ready_cic;
    // wire out_ready;

    cic_top #(
        .IW(IW),
        .OW(OW),
        .N(N),
        .DECIMATION_FACTOR(R1)
    ) cic_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(din),
        .dout(cic_out),
        .out_ready(out_ready_cic)
    );

    downsampler_without_out_ready #(
        .W(OW),
        .DECIMATION_FACTOR(R2)
    ) downsampler_inst (
        .clk(clk),
        .rst(rst),
        .en(out_ready_cic),
        .input_data(cic_out),
        .output_data(dout)
        //.out_ready(out_ready)
    );

endmodule