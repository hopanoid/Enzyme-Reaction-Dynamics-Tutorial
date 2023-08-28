.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

*********
QM Region 
*********

===================================
Selection of Residues for QM Region  
===================================

What should be the composition of QM regions and which residues should be included. This is an important question to ask while modelling an enzymatic reaction using QM/MM simulations. A couple of articles available on this [#f1]_ but there are no straightforward answers. However, chemical intution or proximity could be a guiding approach, later on the perimter of QM region could be expanded if your computational resources permits. Following this, we also begin with the OYE active site residues and overall modelled six different QM regions, details of which are availabe in our supplementary pdf file of our article. We have evaluated the convergence of total atomic charges on the substrate along the increasing number of atoms in QM region, finally we have choosed the QM region comprising of Y27, H178, H181, Y183, LumiFlavin, substarte and the nearest water molecule.   

Computationally, there are mainly two ways to compute the atomic charges, one is via population anaylsis and other one is using partitioning of electron density. [#f2]_ We have considered the both, CM5 charges were computed using Hirshfeld Population Analysis [#f3]_ and Vornoi Deformation Density (VDD) charges were computed from the extent to which electron density of a bonded atom differs from that of an unbonded atom [#f4]_ . For chemically meaningfull charges, both Hirshfeld and VDD approahces are recommended. [#f5]_ We have used Gaussian_ as an external QM package for the calculation of CM5 charges and TeraChem_ QM package for VDD charges. Here are the modified amber $.in files for generating the Hirshfeld and VDD charges using Gaussian_ and TeraChem_ as an external package. 

1. For computing Hirshfeld CM5 Atomic Charges using Gaussian_ 
        * First prepare a template Gaussian_ input file mentioning the flags for route section only. Name this file specifically as "gau_job.tpl", don't rename it to any other way. Here is the content of the :file:`tutorial/pre-processing/gau_job.tpl` 

.. code-block:: 
        :emphasize-lines: 1
        :caption: Gaussian template file to compute CM5 charges

        #P B3LYP/6-31G* SCF=(Conver=8) pop=hirshfeld
        
This line specify the QM method/basis set, the maximum number of cycles for SCF convergence, and at the end set the flag for computing the hirshfeld charges via "pop=hirshfeld". You can do a lot more here, if you know Gaussian_ and wanna compute any other properties, use this template file. However, you can't provide the xyz coordinate here, or the Z-matrix information or the point charges. Amber will not process lines startingwith "%" since these are handled by sander. In short, the advanced Gaussian_ capabilities related to the Link 0 commands, inter-molecular interactions energy calculations etc. are not allowed. The run time flags like number of processors, memory etc should be specified in the below amber ".in" file. Here, is the content of the :file:`tutorial/pre-processing/mdin/qmmm-sys-hir-chrg.in`

.. code-block::
        :emphasize-lines: 17,27,28,29,30,31,32
        :caption: Amber mdin file to run Gaussian_ as an external QM package to compute the CM5 charges

        298K constant temp QMMMMD
        &cntrl
        imin= 0,                       ! Run molecular dynamics.
        nstlim=200,                    ! Number of MD-steps to be performed.
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
        &gau                           ! Syntax for using Gaussian as external QM software
        method       = 'B3LYP',        ! Choice of QM theory
        basis        = '6-31G*',       ! Basis set
        num_threads  =  72,            ! Choice for number of CPUs to use for Gaussian
        mem          = '64GB',         ! Amount of RAM to use
        use_template =  1,             ! Read Gaussian template file "gau_job.tpl"
        dipole = 1,                    ! Print the dipole moment
        /

2. For computing VDD Atomic Charges using TeraChem_
        * First prepare a template TeraChem_ input file mentioning the flags for VDD charges. Name this file specifically as "tc_job.tpl", don't rename it to any other way. Here is the content of the :file:`tutorial/pre-processing/tc_job.tpl`

.. code-block:: 
        :emphasize-lines: 3,4,5,6
        :caption: Terachem template file to compute VDD charges

        # Run using SANDER file-based interface for TeraChem
        #
                basis 6-31g*
                method b3lyp
                precision mixed
                poptype vdd
        end
        
These highlighted lines specify the basis set, QM method, the mixed precision (most effiecint way), and at the end set the flag for computing the vdd charges. You can do a lot more here, if you know TeraChem_ and wanna compute any other properties, use this template file. The run time flags like number of GPUs, memory etc should be specified in the below amber ".in" file. Here, is the content of the :file:`tutorial/pre-processing/mdin/qmmm-sys-vdd-chrg.in`

.. code-block::
        :emphasize-lines: 17,27,28,29,30,31,32,33,34,35
        :caption: Amber mdin file to run TeraChem_ as an external QM package to compute the VDD charges

        298K constant temp QMMMMD
        &cntrl
        imin= 0,                       ! Run molecular dynamics.
        nstlim=200,                    ! Number of MD-steps to be performed.
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

Now, its time to demonstrate how to compute and collect these charges while running QM/MM MD simulations with *sander*. We are going to trick the *sander* output using bash scripting and will navigate the Gaussian_ and TeraChem_ output to a separate directory. We will use QM/MM minimised structure as an input for this step and will run 5 independent 200 ps QM/MM MD runs for each of the QM system under investigation. As you can read in the above *amber* mdin file, we are using a timestep of 1 fs, so in total we should have 1000 frames to analyse for each of the QM systems. Here is the content of the :file:`tutorial/pre-processing/2-amber-qm-vs-hirs-chrgs.sh`

.. code-block::
        :emphasize-lines: 21,35
        :caption: QM/MM MD run using Gaussian_ as an external QM package to compute the CM5 charges

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

                # Capturing QM log files at each step
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

This script will save and rename the *gau_job.log* file at each step for each of the QM system. You can parse CM5 atomic charges from the Gaussian log file using any text file reader or using the progamming languagge of your choice. 

Whereas, the output of TeraChem_ is a bit different. It write a dat file as an output that consist of general stuff like SCF, energy, homo-lumo gap etc., whereas the extra parameters like the charges are stored in the scratch directory. So, we have to store both the dat file as well as the charge_vdd.xls at each step. Here is the content of the :file:`tutorial/pre-processing/2-amber-qm-vs-vdd-chrgs.sh`    

.. code-block::
        :emphasize-lines: 21,35,36
        :caption: QM/MM MD run using TeraChem_ as an external QM package to compute the VDD charges

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
                sander -O -i mdin/qmmm-sys-${sys}-vdd-chrg.in -p xenA_h_OHP.parm7 -c ${ref}.rst7 -o ${step}.mdout -r ${step}.rst7 -inf ${step}.mdinfo -ref ${ref}.rst7 -x ${step}.nc &

                sleep 5s

                # Storing the qm-mm region for each defined system 
                mv qmmm_region.pdb qmmm_region_${sys}.pdb

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
        done

This script will save and rename the *charge_vdd.xls* file at each step for each of the QM system. The *.xls* is a text file consists of three columns namely atom number, atom name and the computed VDD charges for the respective atom.   

Finally, we have analysed the total atomic charges of the substrate *vs* the six different QM regions. Please follow the supplementary figure S25(a), where you can see that the substrate's partial charge don't significantly from QM4 to QM6. Hence, we have selected the QM4 region as our choice for subsequent QM/MM simulations as follows.



.. rubric:: Footnotes

.. [#f1] https://doi.org/10.1021/acs.jpcb.6b07814 https://doi.org/10.1021/acs.jcim.2c01522
.. [#f2] https://doi.org/10.1021/j100084a048
.. [#f3] https://doi.org/10.1021/ct200866d
.. [#f4] https://www.degruyter.com/document/doi/10.1515/crll.1908.134.198/html
.. [#f5] https://doi.org/10.1002/jcc.10351 https://doi.org/10.1021/acs.joc.8b02740
