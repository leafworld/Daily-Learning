#!/bin/sh -f
xv_path="/home/huchao/vivado/Vivado/2015.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim lab6_2_2_tb_behav -key {Behavioral:sim_1:Functional:lab6_2_2_tb} -tclbatch lab6_2_2_tb.tcl -log simulate.log
