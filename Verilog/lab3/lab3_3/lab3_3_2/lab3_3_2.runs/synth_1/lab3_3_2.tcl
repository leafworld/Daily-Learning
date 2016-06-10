# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/huchao/Daily-Learning/Verilog/lab3/lab3_3/lab3_3_2/lab3_3_2.cache/wt [current_project]
set_property parent.project_path /home/huchao/Daily-Learning/Verilog/lab3/lab3_3/lab3_3_2/lab3_3_2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib /home/huchao/Daily-Learning/Verilog/lab3/lab3_3/lab3_3_2/lab3_3_2.srcs/sources_1/new/lab3_3_2.v
synth_design -top lab3_3_2 -part xc7a100tcsg324-1
write_checkpoint -noxdef lab3_3_2.dcp
catch { report_utilization -file lab3_3_2_utilization_synth.rpt -pb lab3_3_2_utilization_synth.pb }
