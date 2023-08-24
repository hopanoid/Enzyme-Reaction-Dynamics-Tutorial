#!/bin/bash

dir="qm_log"

if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Directory for storing QM log '$dir' created."
else
        echo "Directory '$dir' already exists."
fi

for sys in {1..6}
do
for i in {1..5}
do
        # Prefix for the input and output files
        ref=step5.0_qmmm_min
        step=step6.${sys}.${i}

        # Sander production run
        sander -O -i mdin/qmmm-sys-${sys}-hirs-chrg.in -p xenA_h_OHP.parm7 -c ${ref}.rst7 -o ${step}.mdout -r ${step}.rst7 -inf ${step}.mdinfo -ref ${ref}.rst7 -x ${step}.nc &

        sleep 5s

        # Storing the qm-mm region for each defined system 
        mv qmmm_region.pdb qmmm_region_${sys}.pdb

        # Capturing Gaussian log files at each step
        count=0
        
        # Whenever gaussian completes its job, move the old log file to the qm_log directory
        while ! grep "Final Performance Info" ${step}.mdinfo > /dev/null; do
        if [[ -e old.gau_job.log ]]; then

        mv old.gau_job.log qm_log/${step}_gau_${count}.log

        ((count=count+1))
        fi
        done

done
done
