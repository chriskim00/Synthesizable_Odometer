# Open-Source Synthesizable Silicon Odometer Aging Sensor
“RTL” folder contains Verilog files for synthesis and the “Testbench” folder contains the testbench to check the functionality.

# In the RTL folder - 
“Odometer_normal_rvt” - Contains the RTL files for odometer design.

“VCO” - Contains the RTL description for the voltage controlled oscillator for AC stress. 

# “Odometer_normal_rvt” folder is organized as follows - 

“ROSC_ALL_RVT.v” - Structural Verilog for Ring Oscillators (ROSC).

“signal_ctrl.v” - Control signal latching circuit.

“shift_sample_3b.v” - 3 bit shift register.

“parallel_latch.v” - Latch circuit for 12 bit beat frequency output.

“power_enable.v” - Controls power to the ROSCs.

"rosc_block_top_pwr_*.v" - Power supplying inverters along with the reference and stress ring oscillators.

“edge_detector.v” - Generates pulses to start and end the measurement phase.

“odometer_meas_detect.v” - Controls measurement mode operations.

“odometer_top.v” - Top level control block for stress and measurement mode.

“odometer_full_rvt.v” - Reference and stress ROSC with the top control.

# “VCO” folder consists of -

“ROSC101_SEL_INV.v” - Structural Verilog for the oscillator.

“freq_div_*b.v” - Multibit frequency divider.

“signal_control_vco.v” - Control circuits for the VCO.

“buff_block_vco.v” - Buffer block at the end of the VCO.

“VCO_full.v” - Top block with the oscillator and controls.

# “Testbench” contains -

“testbench_vco.v” - checks AC stress clock functionality.

“testbench_full.v” - Tests the Odometer circuit with the AC stress VCO clock.

