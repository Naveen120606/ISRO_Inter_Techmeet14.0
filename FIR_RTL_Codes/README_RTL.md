Module Descriptions:
    fir_filter: contains the verilog implementation of an FIR filter. It takes parameters input_bit_size (size of input to the filter), coeff_bit_size (bit width of coefficients), output_bit_size (bit width of output given by filter), accum_bit_size (bit width of the accumulator where the final code is stored). It takes clk, reset and enable as input. It is positive edge triggered and filter starts working when reset == 0 and enable == 1.

    testbench: cascaded 11 fir_filter each having accumulator width defined according to "accum.py". It runs at clk = 4.096 MHz and outputs data at 2KHz. All the filters use the same coefficients saved in "fixedPoint1sign31frac.mem".


Steps to Simulate 11 Cascaded FIRs Design:
    1. Add "fir_filter.v", "fixedPoint1sign31frac.mem", "noisy500hz.mem", "noisy10hz.mem" and "noisy990hz.mem"  to the project as design sources.
    2. Add "testbench.v" to the project as a simulation source.
    3. In "testbench.v", to run simulation for a particular frequency (amongst 10hz, 500hz and 990hz), say for 10hz, for input from DSM uncomment the line:
        $readmemb("noisy10hz.mem", data);
    and comment out the lines:
        $readmemb("noisy500hz.mem", data);
        $readmemb("noisy990hz.mem", data);
    and for storing the output of the simulation, uncomment:
        fd = $fopen("demodulate_10Hz_test.txt","w");
    and comment out:
        fd = $fopen("demodulate_500Hz_test.txt","w");
        fd = $fopen("demodulate_990Hz_test.txt","w");
    and Run Simulation in Vivado. After this step, locate the output txt file and paste it into your MATLAB folder and then run the FFT generation code using that file as an input to get a PSD plot and the SNDR for 10hz.

    Similarly, the simulation can be run for the other two frequencies - 500hz and 990hz.

Filter Parameters:
    1. The first FIR filter takes in 2 bit signed input obtained by demodulating the single bit output from the DSM. The coefficient size is 32 bits (1 sign, 31 fractional) and the signed output is 32 bits long taking the first 32 MSBs of the accumulator.
    2. The subsequent filters have 32 bit signed inputs, 32 bit signed coefficients, and a 32 bit signed output taking the first 32 MSBs of the accumulator.
    3. Accumulator lengths can be determined using the python script "accum.py".