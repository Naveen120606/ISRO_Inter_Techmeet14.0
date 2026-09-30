`timescale 1ns / 1ps

// Testbench for Complete Signal Processing System
// Tests the top-level module with real data from memory file
// Simulates the complete demodulation and decimation chain

module tb;

    // PARAMETER DEFINITIONS

    parameter IW = 2;     // Input width to filter (after demodulation)
    parameter OW = 20;    // Final output width
    parameter N = 4;      // Number of CIC stages
    parameter R1 = 512;   // First decimation factor (CIC)
    parameter R2 = 4;     // Second decimation factor (downsampler)
    

    reg clk;              // System clock
    reg rst;              // Active-high reset
    reg en;               // Enable signal
    
    // Data signals
    reg din;              // 1-bit input data
    wire signed [OW-1:0] dout;  // Final output

    // TEST PARAMETERS
    localparam data_points = 4096026;     // Number of input samples
    localparam counter = $clog2(data_points);  // Counter width needed
    localparam clkp  = 244.140625;           // Clock period in ns (4.096 MHz clock)


    // TEST DATA STORAGE

    reg data_in [0:data_points-1];  // Array to store input data
    reg [counter-1:0] count;        // counter
    
 
    
    integer f2;  // Output file handle
    

    // INITIALIZATION
    initial 
        begin
            clk =0;
            count =0;
            rst =0;
            din =0;
            en =0;
            $readmemb("clean_500.mem", data_in);   // "clean_500.mem" contains binary samples of a 500Hz signal
            f2=$fopen("data_out_500Hz.txt","w");
        end
        
    // CLOCK GENERATION
    always #(clkp/2) clk = ~clk;
    initial
        begin 
            // Wait initial delay, assert reset, then release and enable
            #(350) rst = 1;
            #(clkp/2) rst =0;
            #(clkp/2) en = 1;
        end
        
    initial
        begin
    // wait until all samples are driven (count increments after data is applied)
            wait (count == data_points-1);
    // give the DUT a few extra clock periods to flush remaining outputs
            repeat (100) @(posedge clk);
            if (f2 != 0) $fclose(f2);
            $display("Output files closed. Simulation finished.");
            $finish;
        end
        
   always @(dout)
        begin
               $fwrite(f2,"%d\n", dout);  // OUTPUT CAPTURE
           end
    
       // INPUT DATA SEQUENCING
    always@(posedge clk or posedge rst)
        begin
            if(rst)
            // Reset: clear counter and input
                begin
                    count <=0; 
                    din <=0;
                end
        else if(en)
            begin
                // When enabled: advance counter and drive next input sample
                count<=count+1;
                din <=data_in[count];
            end
        end
        

        // DEVICE UNDER TEST (DUT) INSTANTIATION
    top #(
        .IW(IW),
        .OW(OW),
        .N(N),
        .R1(R1),
        .R2(R2)
    ) uut(
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(din),
        .dout(dout)
    );
endmodule