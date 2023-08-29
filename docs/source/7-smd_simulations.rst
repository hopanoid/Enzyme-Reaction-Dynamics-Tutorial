.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

####################################
Part - IV (Free Energy Calculations)
####################################

*********************
QM/MM SMD Simulations
*********************

===================================
Selection of A Collective Variables  
===================================

Steered molecular dynamics (SMD) simulations are employed to explore potential structural variations along a pre-defined reaction coordinate or collective variable (CV). This technique is particularly useful for speeding up processes that might otherwise take a considerable amount of time to happen naturally. Subsequently, these generated configurations can serve two main purposes: they can shed light on the structural alterations relevant to the underlying reaction, and they can be employed to calculate free energy changes along the given CV. In the context of our work, we are examining a sequential reaction involving an initial hydride transfer followed by a proton transfer. Guided by our QM/MM scan, we've determined that the hydride transfer occurs first, necessitating that we focus on steering the system along the CV corresponding to hydride transfer before turning our attention to the proton transfer CV. Details concerning our chosen CVs are provided in supplementary figure S27. Here is the CV file for the hyride transfer CV to be used for running QM/MM SMD simulations :file:`tutorial/simulations/mdin/cv-hy-1.in`  

.. code-block:: 
        :emphasize-lines: 4,5,6,7
        :caption: Collective variable file for hyride transfer

        cv_file
        &colvar
           cv_type = 'LCOD',
           cv_ni = 4, cv_i = 11078,11007,10996,11007,
           cv_nr = 2, cv_r = 1.0,-1.0,
           npath = 2, path = 1.0,-1.0, path_mode = 'LINES',
           nharm = 1, harm = 1000.0
        /
        
The first highlighted line defines the atom numbers of the three atoms involved in hydride transfer. 11078 is substrates N1 atom, 11007 is the hyride ion, 10996 is the flavin's N5 atom. The hyride ion is being transferred from the N5 atom of the flavin to N1 atom of the substrate. The second highlighted line consist of the weightage factor for the respective distance, whereas the third highlighted line describe the starting and the end values of the handle position, respectively. The last highlighted line contains the value of spring constant.  


Here is the amber *mdin* file for running QM/MM SMD simulation along the hydride transfer CV. :file:`tutorial/simulations/mdin/qmmm-smd-hy-1.in`

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


Now, given the stochastic nature of molecular dynamics simulations, it is generally advised to run multiple SMD trajectories from different initial configurations to better sample the reaction coordinate. We have chosen mutliple starting configrations from our last three QM/MM production runs, where the hydride CV has a value of 2.0\AA Here is the content of the :file:`tutorial/pre-processing/2-amber-qm-vs-hirs-chrgs.sh`

.. admonition:: Trick the Amber using its old ways!.

        Using Amber's QM/MM functionality, you can take advantage of using a QM package seprately,
        like if you want to compute a specific property related to QM region along with running a
        QM/MM MD simulation, specific atomic charges, dipole moment etc. And later on, the output
        from the QM package could be saved separately to analyse the respective property of
        choice. Amber will prepare the input file for chosen QM package on its own and will run the
        QM package using path specified in your machine. Each QM package will then run indepdently,
        while *sander* is in wait for their output. Once the QM package finished their job, *sander*
        reads the output and proceed for the next step. The new input file for the QM package will
        be prepared and the old input and output files then renamed with a prefix *old*. We are going
        to move these *old* files and will store them in a separate folder for later processing. There
        are also various other ways to automatise this, you can also modify the Amber QM/MM source code
        during installation , and then specific purpose Amber can be compiled using these modified scripts.  

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

.. important::

        Please pay attention to the variables used in this script. In our case we had 6 different QM regions, hence
        the $sys variable in this script should have a range 1-6. We aimed to run 5 short 200 fs QM/MM runs to monitor
        the atomic charges, hence the $i variable should have a range 1-5. The $sys and $i variable have been further
        passed to *sander* input and output flags, and for naming the QM log files. In your case, the QM regions may 
        differ, the number of simulations may vary. So, read the above script carefully, there is a risk that you may
        overwrite existing files if you don't know this bash script very well.

This script will save and rename the *gau_job.log* file at each step for each of the QM system. You can parse CM5 atomic charges from the Gaussian log file using any text file reader or using the progamming languagge of your choice. 

Whereas, the output of TeraChem_ is a bit different. It write a dat file as an output that consist of general stuff like SCF, energy, homo-lumo gap etc., whereas the extra parameters like the charges are stored in the scratch directory. Here, we are storing both the dat file as well as the charge_vdd.xls at each step. Here is the content of the :file:`tutorial/pre-processing/2-amber-qm-vs-vdd-chrgs.sh`    

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

.. admonition:: We Recommend!

        Monitoring HOMO-LUMO Gap

        It has been reported for QM/MM simulations of proteins and other solvated molecules,
        that the HOMO-LUMO gap turned down to zero! [#f6]_ This case should be avoided, hence we
        suggest to monitor the HOMO-LUMO gap for your chosen QM region. The corresponding 
        figure depicting the HOMO-LUMO gap for our QM regions is supplementary figure S25(b).  

Finally, we have analysed the total atomic charges of the substrate *vs* the six different QM regions. Please follow the supplementary figure S25(a), where you can see that the substrate's partial charge don't vary significantly from QM4 to QM6. Hence, we have selected the QM4 region as our choice for subsequent QM/MM simulations as follows.



.. rubric:: Footnotes

.. [#f1] https://doi.org/10.1021/acs.jpcb.6b07814 https://doi.org/10.1021/acs.jcim.2c01522
.. [#f2] https://doi.org/10.1021/j100084a048
.. [#f3] https://doi.org/10.1021/ct200866d
.. [#f4] https://www.degruyter.com/document/doi/10.1515/crll.1908.134.198/html
.. [#f5] https://doi.org/10.1002/jcc.10351 https://doi.org/10.1021/acs.joc.8b02740
.. [#f6] https://doi.org/10.1088/0953-8984/25/15/152101
