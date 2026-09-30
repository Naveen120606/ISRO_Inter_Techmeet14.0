layout_files -- Contains the gds file of the complete layout and the DRC clean (no violation found) file
post_layout_simulation_files -- clean_<freq>.mem contains the input data file from the DSM (stream of 1s and 0s), small_data_out_<freq>_pls.txt is the post layout simulation output file of all the three frequencies, 10Hz, 500Hz and 990Hz. 
post_synthesis_simulation_files -- contains clean_500.mem (input file from the DSM), and its HDL simulation output from Synopsys Design Compiler, data_out_500Hz.txt
RTL CODES -- Contains the Verilog files from Vivado
synthesis_reports -- contains the area, power and timing reports after synthesis

