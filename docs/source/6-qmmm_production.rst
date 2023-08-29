.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

********************
QM/MM Production Run
********************

Now we are ready to run our QM/MM production run. We will use the output from one of the short 200 fs run we had simulated using
QM4. Our aim is to run three *5 ps* independent QM/MM production runs. Here is the amber *mdin* :file:`tutorial/simulations/mdin/qmmm-tc-prod.in` 

.. code-block::
        :emphasize-lines: 17,27,28,29,30,31,32
        :caption: Amber mdin file for QM/MM production run using TeraChem_ as an external QM package

        298K constant temp QMMMMD
        &cntrl
        imin= 0,                       ! Run molecular dynamics.
        nstlim=5000,                   ! Number of MD-steps to be performed.
        dt=0.001,                      ! Time step (ps)
        ntb=2,                         ! Periodic conditiond at constant pressure
        cut=8.0,                       ! non-bond cut off
        ntc=2, ntf=2,                  ! Constrain lengths of bonds having hydrogen atoms (SHAKE) except flavin hydride HN5
        irest=0, ig=-1,                ! Generate a random seed for velocity
        tempi=298.0, temp0=298.0,      ! Temperature
        ntt=3, gamma_ln=3.0,           ! Temperature scaling using Langevin dynamics with the collision frequency in gamma_ln (ps−1)
        ntp=1, taup=2.0,               ! Pressure scaling
        ntpr=1, ntwx=1, ntwr=1,        ! Output options
        ifqnt=1,                       ! Switch on QM/MM coupled potential
        /
        &qmmm
        qmmask       = ':723,22185|@10987-11007,11011-11012,11016-11017,11020-11025,416-430,2631-2641,2678-2688,2702-2716', ! Atoms in the QM4 region
        qm_theory    = 'EXTERN',       ! Opt for external QM software
        qmcharge     =  -1,            ! Total charge on the atoms defined in the QM regions
        qmmm_int     =   1,            ! For Electronic embedding
        qm_ewald     =   0,            ! Switch off Ewald summation and PME for QM-MM interactions
        printcharges =   1,            ! Option to print the atomic charges of QM atoms in mdout file
        writepdb     =   1,            ! Write a pdb file showing the atoms selected in the SQM region, a good choice to verify selected atoms
        verbosity    =   1,            ! Level of information to be printed in mdout for selected QM atoms
        qmshake      =   0,            ! Turn off shake on QM atoms
        /
        &tc                            ! Syntax for using TeraChem as external QM software
        method       = 'B3LYP',        ! Choice of QM theory
        basis        = '6-31G*',       ! Basis set
        guesss       = 'scr/c0',       ! SCF guess to read/write
        scrdir       = 'scr',          ! Scratch directory
        keep_scr     = 'yes',          ! Don't delete the content of scratch directory
        ngpus        =  2,             ! Number of GPUs
        gpuids       =  0,1,           ! Specify the GPU ids
        use_template = 1,              ! Read the TeraChem template file "tc_job.tpl"
        /


.. admonition:: A more flexible view of binding pose!.

        The binding pose of a ligand is often described by geomterical parameters like
        distances, angle/dihedrals etc. without giving any statistical significance 
        to the given values. Here, by running three independent simulations we are 
        aiming to compute the statistical significance for each of the geometrical
        parameters pertaining to the binding pose of our substrate. The computed standard
        deviations along with the average value ensure a more broader picture of active
        site. Results from these calculations are summarised in the table S1 and S2.

Here is the bash script that will automatically run these three independent simulations :file:`tutorial/simulations/3-amber-tc-prod.sh`    

.. code-block::
        :emphasize-lines: 30,31
        :caption: QM/MM MD run using TeraChem_ as an external QM package

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

Similar to previous one, this script will save and rename the *charge_vdd.xls* file at each step for each of the QM system. 
The trajectory files generated from these three 5 ps simulations, have been analysed to extract the key geometrical parameters 
of underlying binding pose of substrate.


