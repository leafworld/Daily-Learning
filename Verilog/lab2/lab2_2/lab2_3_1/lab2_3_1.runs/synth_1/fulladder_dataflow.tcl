# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {Common-41} -limit 4294967295
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/huchao/Daily-Learning/Verilog/lab2/lab2_2/lab2_3_1/lab2_3_1.cache/wt [current_project]
set_property parent.project_path /home/huchao/Daily-Learning/Verilog/lab2/lab2_2/lab2_3_1/lab2_3_1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib /home/huchao/Daily-Learning/Verilog/lab2/lab2_2/lab2_3_1/lab2_3_1.srcs/sources_1/new/fulladder_dataflow.v
synth_design -top fulladder_dataflow -part xc7a100tcsg324-1
write_checkpoint -noxdef fulladder_dataflow.dcp
catch { report_utilization -file fulladder_dataflow_utilization_synth.rpt -pb fulladder_dataflow_utilization_synth.pb }
