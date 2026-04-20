#!/bin/bash

dir="qm_log"

if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Directory for storing QM log '$dir' created."
else
        echo "Directory '$dir' already exists."
fi

for i in {1..3}
do
        # Prefix for the input and output files
        ref=step6.4.4
        step=step7.prod.${i}

        # Sander production run
        sander -O -i mdin/qmmm-tc-prod.in -p xenA_h_OHP.parm7 -c ${ref}.rst7 -o ${step}.mdout -r ${step}.rst7 -inf ${step}.mdinfo -ref ${ref}.rst7 -x ${step}.nc &

        sleep 5s

        # Capturing QM log files at each step
        count=0
        
        # Whenever TeraChem completes its job, move the old log file to the qm_log directory
        while ! grep "Final Performance Info" ${step}.mdinfo > /dev/null; do
        if [[ -e old.tc_job.dat ]]; then

        mv old.tc_job.dat qm_log/${step}_tc_${count}.dat
        mv scr/charge_vdd.xls scr/${step}_charge_vdd_${count}.xls

        ((count=count+1))
        fi
        done

done

