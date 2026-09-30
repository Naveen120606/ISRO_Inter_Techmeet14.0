`timescale 1ns / 1ps

module demodulator(
    input clk,
    input rst,
    input en,
    input din,
    output signed [1:0] dout
);
    reg ps, ns;
    localparam s0=0, s1=1;

    always@(posedge clk or posedge rst)
        begin
            if(rst)
                ps<=s0;
            else
                begin
                    if(en)
                        ps<=ns;
                    else
                        ps<=ps;
                end
        end

    always@(*)
        case(ps)
            s0: ns<=s1;
            s1: ns<=s0;
            default: ns<=s0;
        endcase

    assign dout = (ps == s0) ? {1'b0, din} : {din, din};
endmodule