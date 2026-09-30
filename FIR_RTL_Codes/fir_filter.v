`timescale 1ns / 1ps

module fir_filter #(parameter input_bit_size = 32,  
    coeff_bit_size = 32,    
    output_bit_size = 32,  
    accum_bit_size = 34) 
    (
    input clk, reset, enable,
    input signed [input_bit_size - 1 : 0] input_bits, 
    output signed [output_bit_size - 1 : 0] data_out  
    );  
    reg signed [output_bit_size - 1 : 0] data_out_reg;
    localparam coeff_amount = 101;
    reg signed [coeff_bit_size - 1 : 0] coeff_memory [0:coeff_amount - 1];
    
    initial begin
        $readmemb("fixedPoint1sign31frac.mem", coeff_memory);   //file containing filter coefficients
    end
    reg signed [accum_bit_size - 1:0] accumulate;
    reg signed [input_bit_size - 1 : 0] flipFlops [0:coeff_amount - 1]; //creates the same number of registers as the number of coefficients
    //each register storing same number of bits as the input length
    reg signed [output_bit_size - 1 : 0] data_out_reg_temp;
    integer ri, j, k; //ri -> register index, 
    always @(posedge clk or posedge reset) begin    //asynchronous active high reset, sets all flip flops and output data to 0
        if (reset == 1'b1) begin
            for (ri = 0 ; ri < coeff_amount ; ri = ri + 1) begin
                flipFlops[ri] <= 0;
            end
            data_out_reg <= 0;
        end
        else begin
            if ((enable == 1'b1) && (reset == 1'b0)) begin //when enabled, the first register takes in the input bits and the subsequent registers take on the value of the preceeding register
                flipFlops[0] <= input_bits;
                for (j = 0 ; j < coeff_amount-1 ; j = j + 1) begin
                    flipFlops[j + 1] <= flipFlops[j];
                end

                    data_out_reg <= accumulate[accum_bit_size - 1 : accum_bit_size-output_bit_size]; //outputs the first output_bit_size Most Significant Bits
            end
        end
    end

    always @(*) begin
        accumulate = 0;
        for (k = 0 ; k < coeff_amount ; k = k + 1) begin    //adds the register values multiplied by the coefficients to the accumulator
            accumulate = accumulate + flipFlops[k]*coeff_memory[k];  
        end

    end
    
    assign data_out = data_out_reg; //final truncated filter output
endmodule
