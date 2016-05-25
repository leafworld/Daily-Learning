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
ExecStep $xv_path/bin/xelab -wto dbd9a77a55af4568a5ef6522adcdbb8e -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot lab1_3_2_tb_behav xil_defaultlib.lab1_3_2_tb xil_defaultlib.glbl -log elaborate.log
