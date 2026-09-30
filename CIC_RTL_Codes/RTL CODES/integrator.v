`timescale 1ns / 1ps

module integrator #(
    parameter IW = 16,
    parameter OW = 32
)(
    input clk,
    input rst,
    input en,
    input signed[IW-1:0] input_data,

    output signed[OW-1:0] output_data,
    output reg out_ready
);
    wire signed[OW-1:0] sx_data = {{(OW-IW){input_data[IW-1]}}, input_data};
    reg signed[OW-1:0] acc;

    always @(posedge clk or posedge rst)
        begin
            if (rst)
                begin
                    acc <= {OW{1'b0}};
                    out_ready <= 1'b0;
                end
            else
                begin
                    if (en)
                        begin
                            acc <= acc + sx_data;  
                            out_ready <= 1'b1;
                        end
                    else
                        begin
                            acc <= acc;
                            out_ready <= 1'b0;
                        end
                end
        end

    assign output_data = acc;
endmodule