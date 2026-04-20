#!/bin/bash

dir="qm_log"

if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Directory for storing QM log '$dir' created."
else
        echo "Directory '$dir' already exists."
fi

for i in {1..95}
do
        # Chose a random reference frame
        j=$(shuf -i 1-10 -n1)

        # Prefix for the input and output files
        ref=step7.0.prod.hy.cv.2.0.${j}
        step=step8.smd.hy.${i}

        # Sander production run
        sander -O -i mdin/qmmm-smd-hy-1.in -p xenA_h_OHP.parm7 -c ${ref}.rst7 -o ${step}.mdout -r ${step}.rst7 -inf ${step}.mdinfo -ref ${ref}.rst7 -x ${step}.nc &
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

        # Renaming SMD work record file for each step separately
        mv smd-hy-1.txt smd-hy-1-${i}.txt

done
