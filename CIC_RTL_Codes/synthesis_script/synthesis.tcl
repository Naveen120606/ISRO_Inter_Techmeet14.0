 #############################################################
 ##                 Synopsys DC Compile 
 #############################################################
	
	set top_module top
	set clk_name   clk
	
	#*************************************************************40nmTechnology**********************************************************************
  #set tech_lib fsh0l_brs_generic_core_ssg0p99v125c
	#set tech_lib fsh0l_brs_generic_core_ff1p21v125c
  #set tech_lib fsh0l_brs_generic_core_ff1p21v0c
  #set tech_lib fsh0l_brs_generic_core_ff1p21vm40c
  #set tech_lib fsh0l_brs_generic_core_ff1p26v125c
  #set tech_lib fsh0l_brs_generic_core_ff1p26vm40c
   #set tech_lib fsh0l_brs_generic_core_ff1p21v125c
	#*************************************************************65nmTechnology*************************************************************************
	#set tech_lib   uk65lscllmvbbr_110c-40_bc
	#set tech_lib   uk65lscllmvbbr_108c125_wc
        set tech_lib    uk65lscllmvbbr_120c25_tc
	#*************************************************************90nmTechnology********************************************************************
	
	#set tech_lib fsd0j_a_generic_core_ss0p9v125c
        #set tech_lib fsd0j_a_generic_core_ff1p1vm40c
        #set tech_lib fsd0j_a_generic_core_tt1v25c
	
	#***************************************************************************************************************************************************
	
	
	
	set synthetic_library dw_foundation.sldb
	
	
	# ***********************************************40nm Technology************************************************************************************
	
	#set target_library "/home/*/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ss1p1v125c.db"
	#set target_library "/home/*/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ssg0p99v125c.db"
  #set target_library "/home/*/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ff1p21v125c.db"
  #set target_library "/home/*/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ff1p21v0c.db"
  #set target_library "/home/*/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ff1p21vm40c.db"
  #set target_library "/home/*/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ff1p26v125c.db"
  #set target_library "/home/internship/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ff1p26vm40c.db"
  #set target_library "/home/*/UMC40/fsh0l_brs/2018Q2v1.2/GENERIC_CORE/FrontEnd/synopsys/synthesis/fsh0l_brs_generic_core_ff1p21v125c.db"
  #*************************************************65nmTechnology***************************************************************************************
	
	 #set target_library "/home/internship/UMC65/UMK65LSCLLMVBBR_B03_TAPEOUTKIT/synopsys/uk65lscllmvbbr_108c125_wc.db"
	 #set target_library "/home/*/UMC65/UMK65LSCLLMVBBR_B03_TAPEOUTKIT/synopsys/uk65lscllmvbbr_110c-40_bc.db"
	 #set target_library "/home/*/UMC65/UMK65LSCLLMVBBR_B03_TAPEOUTKIT/synopsys/uk65lscllmvbbr_108c125_wc.db"
         set target_library "/home/*/UMC65/UMK65LSCLLMVBBR_B03_TAPEOUTKIT/synopsys/uk65lscllmvbbr_120c25_tc.db"

	#***************************************************90nm Technology**************************************************************************************
	
  #set target_library "/home/tools/PDK/UMC90/fsd0a_a/fsd0a_a_generic_core_ss0p9v125c.db"
  #set target_library "/home/*/UMC90/fsd0j_a/2009Q2v2.0/GENERIC_CORE_1D0V/FrontEnd/synopsys/fsd0j_a_generic_core_ss0p9v125c.db"
  #set target_library "/home/*/UMC90/fsd0j_a/2009Q2v2.0/GENERIC_CORE_1D0V/FrontEnd/synopsys/fsd0j_a_generic_core_ff1p1vm40c.db"
  #set target_library "/home/*/UMC90/fsd0j_a/2009Q2v2.0/GENERIC_CORE_1D0V/FrontEnd/synopsys/fsd0j_a_generic_core_tt1v25c.db"
	#*********************************************************************************************************************************************************
      
	set link_library "* $target_library $synthetic_library"
        #analyze -format sverilog -library WORK /home/*/rtl_custom2/include/cv32e40p_pkg.sv
        #analyze -format sverilog -library WORK /home/*/rtl_custom2/include/cv32e40p_fpu_pkg.sv
        #analyze -format sverilog -library WORK /home/*/rtl_custom2/include/cv32e40p_apu_core_pkg.sv
        #analyze -format sverilog -library WORK /home/*/rtl_custom2/include/cv32e40p_tracer_pkg.sv


        analyze -format verilog -recursive -autoread /home/*/Inter_IIT/rtl/ -top $top_module

	set synlib_enable_dpgen true
	elaborate $top_module
	current_design $top_module
	link
	
 #############################################################
 ##                      Create Clock
 #############################################################
	
	set find_clock [ find port [list $clk_name] ]
	if {  $find_clock != [list] } {
		create_clock $clk_name -period 250
		puts "clock present"
	} else {
		set clk_name vclk
		create_clock -period 250 -name $clk_name
		puts "clock not present"
	}
	set_clock_uncertainty -setup 0.001 $clk_name
	
 #############################################################
 ##                    Operating Environment
 ##             Input/Output Delay, Drive Strength
 #############################################################
	
	if {[string match gscl45nm $tech_lib] == 1 } {
		set_driving_cell -lib_cell INVX1 [all_inputs]
	}
	set_drive 0.0001 [all_inputs]
	set_load  0.0001 [all_outputs]
	set_input_delay 0.0001 [all_inputs] -clock $clk_name
	set_output_delay 0.0001 [all_outputs] -clock $clk_name
	
 #############################################################
 ##                    Operating Environment
 ##               Operating Condition, Wire Load
 #############################################################
	
	# # set auto_wire_load_selection true
	# # set wire_lode_mode "top"
	
	if {[string match *_brs_generic_core_* $tech_lib] == 1 } {
		set condition [lindex [split $tech_lib "_"] end]
		set_operating_conditions -library $tech_lib $condition
		set_wire_load_model -name "enG50K" -library "$tech_lib"
		
	} elseif {[string match *generic_core_ff* $tech_lib] == 1 } {
		# append tech "_ff"
		set_operating_conditions -library $tech_lib BCCOM
		set_wire_load_model -name "enG50K" -library "$tech_lib"

	} elseif {[string match *generic_core_ss* $tech_lib] == 1 } {
		# append tech "_ss"
		set_operating_conditions -library $tech_lib WCCOM
		set_wire_load_model -name "enG50K" -library "$tech_lib"
		
	} elseif {[string match *generic_core_tt* $tech_lib] == 1 } {
		# append tech "_tt"
		set_operating_conditions -library $tech_lib TCCOM
		set_wire_load_model -name "enG50K" -library "$tech_lib"

	} elseif {[string match gscl45nm $tech_lib] == 1 } {
		set_operating_conditions -library $tech_lib typical
		
	} elseif {[string match *tsl18fs120_scl* $tech_lib] == 1 } {
		if {[string match *ff* $tech_lib] == 1 } {
			append tech "_ff"
		} elseif {[string match *ss* $tech_lib] == 1 } {
			append tech "_ss"
		}
		set_operating_conditions -library $tech_lib $tech_lib
		set_wire_load_model -name "140000" -library "$tech_lib"
		
	} elseif {[string match *uk65lscspmvl9b* $tech_lib] == 1 } {
		# set_operating_conditions -library $tech_lib
		set_wire_load_model -name "wl30" -library "$tech_lib"
		
	} 
	
 #############################################################
 ##                 Optimization Constraints 
 #############################################################
	
	# set_max_delay 5.4 -from $clk_name
	
	# set_max_transition 2 $top_module
	# set_max_capacitance 5 $top_module
	
	set_max_area 0
	set_max_dynamic_power 0
	set_max_leakage_power 0
	set_max_total_power 0
	
	set_fix_multiple_port_nets -buffer_constant -all
	remove_unconnected_ports [find -hierarchy cell {"*"}]
	
 #############################################################
 ##                 Compile
 #############################################################
	
	# if { $clock_gatting_en == "true"} {
		# compile -gate_clock -map_effort   high -incremental_mapping
		# compile -gate_clock -area_effort  high -incremental_mapping
		# compile -gate_clock -power_effort high -incremental_mapping
	# } else {
		# compile -map_effort   high -incremental_mapping
		# compile -area_effort  high -incremental_mapping
		# compile -power_effort high -incremental_mapping
	#}
	
	compile -map_effort high 
	# compile -area_effort medium 
	# compile -power_effort high 
	# compile -incremental_mapping   
	# compile -map_effort low -area_effort high -power_effort low
	# compile -area_effort high -incremental_mapping
	# compile -map_effort high -area_effort high -power_effort high -incremental_mapping
	
 #############################################################
 ##                    Report Generation                    ##
 #############################################################
	
	#report_area > reports/$top_module.area
	report_power -verbose > reports/$top_module.power
	report_area -hierarchy > reports/$top_module.area
	#report_power -verbose -hierarchy -levels 2 > reports/$top_module.power
  #report_timing > reports/$top_module.timing
  write -hierarchy -format verilog -output reports/$top_module.dc.v
  report_timing -max_paths 5 > reports/$top_module.timing
	# write -hierarchy -format verilog -output $dir_out_synopsys/$top_module.db
	# write -hierarchy -format ddc -output $dir_out_synopsys/$top_module.ddc 
        write_sdc -version 2.1 file1.sdc
	
	# # source ./scripts/report.tcl
	# check_design -multiple_designs > $dir_rep_synopsys/$top_module.check.report
	# report_area > $dir_rep_synopsys/$top_module.area.report
	# report_design > $dir_rep_synopsys/$top_module.design.report
	# report_cell > $dir_rep_synopsys/$top_module.cell.report
	# report_reference > $dir_rep_synopsys/$top_module.reference.report
	# report_port -verbose > $dir_rep_synopsys/$top_module.port.report
	# report_net -verbose > $dir_rep_synopsys/$top_module.net.report
	# report_compile_options > $dir_rep_synopsys/$top_module.compile.report
	# report_constraint -all_violators > $dir_rep_synopsys/$top_module.constraint.report

	# report_net -noflat -transition_times -cell_degradation -connection >> $dir_rep_synopsys    /$top_module.net.report
	# report_timing  > $dir_rep_synopsys/$top_module.timing.report
	# report_timing -path end >> $dir_rep_synopsys/$top_module.timing.report
	# report_timing_requirements >> $dir_rep_synopsys/$top_module.timing.report
	# # report_timing -max_path 10 >> $dir_rep_synopsys/$top_module.timing.report
	# report_qor > $dir_rep_synopsys/$top_module.qor.report
	# report_power -verbose > $dir_rep_synopsys/$top_module.power.report
	
