`timescale 1ns / 1ps

module testbench(

    );
    parameter file_size = 4093231;
    parameter outer_limit = (file_size / 2048) + 1;
    parameter clk_period = 122.0703;
    parameter clk_period2 = clk_period*2;
    parameter clk_period4 = clk_period*4;
    parameter clk_period8 = clk_period*8;
    parameter clk_period16 = clk_period*16;
    parameter clk_period32 = clk_period*32;
    parameter clk_period64 = clk_period*64;
    parameter clk_period128 = clk_period*128;
    parameter clk_period256 = clk_period*256;
    parameter clk_period512 = clk_period*512;
    parameter clk_period1024 = clk_period*1024;
    parameter clk_period2048 = clk_period*2048;
    parameter clk_delay2 = clk_period;
    parameter clk_delay4 = clk_period2+clk_period;
    parameter clk_delay8 = clk_period4+3*clk_period;
    parameter clk_delay16 = clk_period8+7*clk_period;
    parameter clk_delay32 = clk_period16+15*clk_period;
    parameter clk_delay64 = clk_period32+31*clk_period;
    parameter clk_delay128 = clk_period64+63*clk_period;
    parameter clk_delay256 = clk_period128+127*clk_period;
    parameter clk_delay512 = clk_period256+255*clk_period;
    parameter clk_delay1024 = clk_period512+511*clk_period;
    parameter clk_delay2048 = clk_period1024+1023*clk_period;
    reg clk_2_delayed, clk_4_delayed, clk_8_delayed, clk_16_delayed, clk_32_delayed, clk_64_delayed, clk_128_delayed, clk_256_delayed, clk_512_delayed, clk_1024_delayed, clk_2048_delayed;
    reg clk_2, clk_4, clk_8, clk_16, clk_32, clk_64, clk_128, clk_256, clk_512, clk_1024, clk_2048;
    initial begin
        clk_2048_delayed = 1'b0;
        clk_1024_delayed = 1'b0;
        clk_512_delayed = 1'b0;
        clk_256_delayed = 1'b0;
        clk_128_delayed = 1'b0;
        clk_64_delayed = 1'b0;
        clk_32_delayed = 1'b0;
        clk_16_delayed = 1'b0;
        clk_8_delayed = 1'b0;        
        clk_4_delayed = 1'b0;
        clk_2_delayed = 1'b0;
        clk_2 = 1'b0;
        clk_4 = 1'b0;
        clk_8 = 1'b0;
        clk_16 = 1'b0;
        clk_32 = 1'b0;
        clk_64 = 1'b0;
        clk_128 = 1'b0;
        clk_256 = 1'b0;
        clk_512 = 1'b0;
        clk_1024 = 1'b0;
        clk_2048 = 1'b0;  
    end
    reg data [0:file_size - 1];
    
    reg clk, bits, reset, enable;
    reg signed [1:0] demo;
    wire signed [OUTPUT_BIT_SIZE - 1:0]out;
    wire signed [31:0] out2, out3, out4, out5, out6, out7, out8, out9, out10, out11;
    
    initial begin
        $readmemb("noisy10hz.mem", data); //input data
        //$readmemb("noisy500hz.mem", data);
        //$readmemb("noisy990hz.mem", data);
    end
    
    initial begin
        clk=0;
        bits=0;
        reset = 1;
        enable = 0;
        #1 reset = 0;
        enable = 1;
        demo = 0;
    end
    always #clk_period clk=~clk;
    always #clk_period2 clk_2=~clk_2;
    always #clk_period4 clk_4=~clk_4;
    always #clk_period8 clk_8=~clk_8;
    always #clk_period16 clk_16=~clk_16;
    always #clk_period32 clk_32=~clk_32;
    always #clk_period64 clk_64=~clk_64;
    always #clk_period128 clk_128=~clk_128;
    always #clk_period256 clk_256=~clk_256;
    always #clk_period512 clk_512=~clk_512;
    always #clk_period1024 clk_1024=~clk_1024;
    always #clk_period2048 clk_2048=~clk_2048;
    
    always @(*) begin
    #clk_delay2 clk_2_delayed = clk_2;
    end
    always @(*) begin
    #clk_delay4 clk_4_delayed = clk_4;
    end
    always @(*) begin
    #clk_delay8 clk_8_delayed = clk_8;
    end
    always @(*) begin
    #clk_delay16 clk_16_delayed = clk_16;
    end
    always @(*) begin
    #clk_delay32 clk_32_delayed = clk_32;
    end
    always @(*) begin
    #clk_delay64 clk_64_delayed = clk_64;
    end
    always @(*) begin
    #clk_delay128 clk_128_delayed = clk_128;
    end
    always @(*) begin
    #clk_delay256 clk_256_delayed = clk_256;
    end
    always @(*) begin
    #clk_delay512 clk_512_delayed = clk_512;
    end
    always @(*) begin
    #clk_delay1024 clk_1024_delayed = clk_1024;
    end
    always @(*) begin
    #clk_delay2048 clk_2048_delayed = clk_2048;
    end
    
    integer i,j;
    initial begin
    i = 0;
    j = 0;
    end
    
    integer fd;
    initial begin
        fd = $fopen("demodulate_10Hz_test.txt","w"); //output file
        //fd = $fopen("demodulate_500Hz_test.txt","w");
        //fd = $fopen("demodulate_990Hz_test.txt","w");
    end
    

    always @(posedge clk) begin //demodulation of single bit input stream
        if (i < file_size) begin

             if(i%2==0)begin
                demo={1'b0,data[i]};
            end else begin
                demo={2{data[i]}};
            end
            i <= i + 1;
        end
    end
    
    always @(posedge clk_2048_delayed) begin
        if (j < outer_limit) begin
            j <= j + 1;
        end 
        else begin
            $finish;
        end
    end
    always @(posedge clk_2048_delayed) begin //writing final data after 11 filters to output file
        $fwrite(fd, "%d\n",  out11);
    end
    fir_filter  #(.input_bit_size(2), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(34)) fir1(clk, reset, enable, demo, out);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(64)) fir2(clk_2_delayed, reset, enable, out, out2);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(65)) fir3(clk_4_delayed, reset, enable, out2, out3);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(64)) fir4(clk_8_delayed, reset, enable, out3, out4);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(65)) fir5(clk_16_delayed, reset, enable, out4, out5);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(64)) fir6(clk_32_delayed, reset, enable, out5, out6);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(65)) fir7(clk_64_delayed, reset, enable, out6, out7);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(64)) fir8(clk_128_delayed, reset, enable, out7, out8);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(64)) fir9(clk_256_delayed, reset, enable, out8, out9);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(65)) fir10(clk_512_delayed, reset, enable, out9, out10);
    fir_filter  #(.input_bit_size(32), .coeff_bit_size(32), .output_bit_size(32), .accum_bit_size(64)) fir11(clk_1024_delayed, reset, enable, out10, out11);

endmodule
