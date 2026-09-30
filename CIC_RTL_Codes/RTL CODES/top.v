`timescale 1ns / 1ps

module top#(
    parameter IW = 2,
    parameter OW = 20,
    parameter N=4,
    parameter R1=512,
    parameter R2=4
  )(
    input clk,
    input rst,
    input en,
    input din,
    output signed [OW-1:0] dout
    // output out_ready
);
    localparam BW = IW + (N * $clog2(R1));
    wire signed [1:0] demodulator_out;
    // wire out_ready;
    wire signed [BW-1:0] dout_initial;

    demodulator demodulator_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(din),
        .dout(demodulator_out)
    );

    full_filter #(
        .IW(IW),
        .OW(BW),
        .N(N),
        .R1(R1),
        .R2(R2)
    ) full_filter_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(demodulator_out),
        .dout(dout_initial)
        // .out_ready(out_ready)
    );

    assign dout = dout_initial[BW-3:BW-OW-2];
    
endmodule