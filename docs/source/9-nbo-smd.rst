.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst


################################
Natural Bonding Orbital Analysis
################################

**************************************
NBO Coupled with QM/MM SMD Simulations
**************************************

Natural bonding orbital (NBO) analysis is based on the classical lewis dots structure, where the octet rule has been used to explain the valency of an atom. 
Basically, the electrons are being divided into core and valence group, later on the energy of the atomic and natural orbitals computed based on their occupancy.
Coupling NBO analysis with SMD simulations will help us to visualise the electronic transition among the molecular orbitals along the reaction coordinate. NBO_ is
a licenced software and you need to have it in your path while running it, a QM package will write an input file for NBO_ on its own (with extension .47), this
input file then passed on to NBO_ binaries and the respective output from the NBO_ will be captured back by a QM package. To run NBO_ at each step of our QM/MM SMD
simulation, we need to mention this in the template file for TeraChem_ , here is the template file for TeraChem_ to generate NBO_ input :file:`tutorial/simulations/nbo/tc_job.tpl` 

.. code-block::
        :emphasize-lines: 7,9 
        :caption: Terachem template file to compute VDD charges and writing NBO input file

        # Run using SANDER file-based interface for TeraChem
        #
                basis 6-31g*
                method b3lyp
                precision mixed
                poptype vdd
                nbo advanced

        $NBO ARCHIVE FILE=OHPORB $END

        end

The first highlighted line directs the TeraChem_ to use advanced NBO_ functionality, where we can also specify the NBO_ keywords to be written
in the NBO_ input file. The *ARCHIVE* keyword will save NBO_ input file *OHPORB.47* at each step, and later on we will store this file at a 
specific location. There are no changes needed in the amber *mdin* file for running NBO_ alongwith QM/MM SMD, it will remains same as before :file:`tutorial/simulations/nbo/mdin/qmmm-smd-hy-1.in`

.. code-block::
        :emphasize-lines: 17,27,28,29,30,31,32,33,34,35
        :caption: Amber mdin file to run QM/MM SMD simulations using TeraChem_ as an external QM package

        298K constant temp QMMMMD
        &cntrl
        imin= 0,                       ! Run molecular dynamics.
        nstlim=1000,                    ! Number of MD-steps to be performed.
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
        infe=1,                        ! Switch on free energy modules
        /
        &qmmm
        qmmask       = ':723|@10985-11005,11009-11010,11014-11015,11018-11023', ! Substrate and LumiFlavin atoms selected in the QM region
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
        &smd
        output_file = 'smd-hy-1.txt'
        output_freq = 1
        cv_file = 'cv-hy-1.in'
        /


There are minor changes in the bash script to run NBO_ alongwith the QM/MM SMD, the required changes are highlighted below. Here is the content of the automated script :file:`tutorial/simulations/nbo/5-amber-tc-nbo-smd-hy-1.sh`
 
.. code-block::
        :emphasize-lines: 39,40
        :caption: QM/MM SMD simulations using TeraChem_ as an external QM package alongwith saving NBO_ input files

        #!/bin/bash

        # Create a directory to save NBO files
        mkdir -p nbo

        # Create a directory for saving QM log files
        dir="qm_log"
 
        if [ ! -d "$dir" ]; then
                mkdir -p "$dir"
                echo "Directory for storing QM log '$dir' created."
        else
                echo "Directory '$dir' already exists."
        fi

        for i in {96..100}
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
                
                # Save NBO inout file
                mv OHPORB.47  nbo/ohporb.${i}.${count}.47
                
                ((count=count+1))
                fi
                done

                # Renaming SMD work record file for each step separately
                mv smd-hy-1.txt smd-hy-1-${i}.txt

        done

The highlighted line direct the shell to rename and relocate the NBO_ input file at each step of the QM/MM SMD run. Later on, you can use these saved *.47* files
as an input for NBO program to generate the corresponding orbital information along the CV. These *.47* files are written by TeraChem_, having the wavefunction and coordinate information. Header of the *.47* is like:

.. code-block:: console
        
         $GENNBO  NATOMS=113  NBAS=993  UPPER  BODM  FORMAT  $END
         $NBO ARCHIVE FILE=OHPORB $END
         $COORD
         inpfile                                                                        ^@
         6    6      -2.331320      -5.872233       7.639413
         1    1      -2.006254      -6.944089       7.906230
         1    1      -3.416712      -5.953286       7.656803


You can customise the second line with the desired flags for processing the NBO_ input files. For more info on using NBO_ and its output, please visit https://nbo6.chem.wisc.edu/tutor_css.htm 
