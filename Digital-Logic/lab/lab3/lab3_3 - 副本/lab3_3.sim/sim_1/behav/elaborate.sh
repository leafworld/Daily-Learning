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
ExecStep $xv_path/bin/xelab -wto e9c1a794d31f4cb7b5f811bb0dc30221 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot lab3_3_tb_behav xil_defaultlib.lab3_3_tb xil_defaultlib.glbl -log elaborate.log
