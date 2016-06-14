# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.cache/wt [current_project]
set_property parent.project_path /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.srcs/sources_1/new/register.v
  /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.srcs/sources_1/new/multiplexer.v
  /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.srcs/sources_1/new/memory.v
  /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.srcs/sources_1/new/e_fulladder.v
  /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.srcs/sources_1/new/comparator.v
  /home/huchao/Daily-Learning/Verilog/lab4/lab4_2/lab4_2.srcs/sources_1/new/lab4_2.v
}
synth_design -top lab4_2 -part xc7a100tcsg324-1
write_checkpoint -noxdef lab4_2.dcp
catch { report_utilization -file lab4_2_utilization_synth.rpt -pb lab4_2_utilization_synth.pb }
