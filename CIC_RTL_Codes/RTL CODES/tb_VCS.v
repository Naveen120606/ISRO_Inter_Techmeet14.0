`timescale 1ns / 1ps

module tb;

    // --- Parameters ---
    parameter IW = 2;
    parameter OW = 20;
    parameter N  = 4;
    parameter R1 = 512;
    parameter R2 = 4;
    
    // --- Signals ---
    reg clk;
    reg rst;
    reg en;
    reg din;
    wire signed [OW-1:0] dout;
   // wire out_ready; 
    
    // --- File Handler Variable ---
    integer f2;
    
    // --- Simulation Constants ---
    localparam data_points = 4096026;
    localparam counter = $clog2(data_points);
    localparam clkp  = 244.14;
    
    reg data_in [0:data_points-1]; 
    reg [counter-1:0] count;
    
    // ==========================================
    // 1. WAVEFORM GENERATION FOR VCS/VERDI
    // ==========================================
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb); // Dump all variables in module 'tb'
    end

    // ==========================================
    // 2. INITIALIZATION & FILE OPEN
    // ==========================================
    initial 
        begin
            clk = 0;
            count = 0;
            rst = 0;
            din = 0;
            en = 0;
            
            // Open the file for writing
            f2 = $fopen("data_out_500Hz_new3.txt", "w");
            
            $readmemb("clean_500.mem", data_in);
        end
        
    // Clock Generation
    always #(clkp/2) clk = ~clk;

    // Reset and Enable Logic
    initial
        begin 
            #(350) rst = 1;
            #(clkp/2) rst = 0;
            #(clkp/2) en = 1;
        end
        
    // ==========================================
    // 3. SIMULATION CONTROL & FILE CLOSE
    // ==========================================
    initial
        begin
            // Wait until all input samples are driven
            wait (count == data_points-1);
            
            // Give DUT extra time to flush the pipeline
            repeat (100) @(posedge clk);
            
            // Close the file securely
            $fclose(f2);
            $display("Output files closed. Simulation finished.");
            $finish;
        end
        
    // ==========================================
    // 4. WRITE OUTPUT TO FILE
    // ==========================================
    always @(posedge clk)
        begin
            // Write to file only when enabled and not in reset
            if (en && !rst) begin
                 $fwrite(f2, "%d\n", dout);
            end
        end
    
    // Input Data Driver
    always@(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    count <= 0; 
                    din <= 0;
                end
            else if(en)
                begin
                    count <= count + 1;
                    din <= data_in[count];
                end
        end
        
    // ==========================================
    // 5. DUT INSTANTIATION
    // ==========================================
    top #(
        .IW(IW),
        .OW(OW),
        .N(N),
        .R1(R1),
        .R2(R2)
    ) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .din(din),
        .dout(dout)
       // .out_ready(out_ready)
    );

endmodule
