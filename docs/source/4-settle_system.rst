.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

*****************
Settle the System
*****************

===================
Energy Minimization
===================


Removing bad atomic contacts and minimizing vaccum!
===================================================

We have just modelled a "matured" system, means we have placed all required molecules in a box. This step-wise placement could lead 
to overlapping atomic positions or very close atomic contacts or very far atomic postions, this could results in atomic replusion or
can forbidden possible atomic interactions too. To minimize these positional artifacts energy minimisation is a 
crucial step before proceeding further. Essentially, we are going to use the potential energy terms derived from the force-field, 
that will use the 3D coordinate as input and will try to optimise the positions of atoms, so that any clashes or
vaccum therein will be minimsed.

Breifly, the system will undergo sequentially through steps:

#. Classical Energy Minimization
        * Will try to optimize the psotion of atoms using the supplied molecular mechanics parameters e.g. bond-length, angle, van-der-waal etc
#. Thermalisation
        * Kinetic energy or say the dynamics of the atoms increased step-wise 
#. Equilibration Run
        * Allowing the system to breathe for 100 ps
#. SQM-MM Energy Minimization
        * A part of the system treated with Semi-Empirical Method, rest of the system still under the classical ff
#. QM-MM Energy Minimization
        * A part of interest uses QM and rest is still under classical ff

Here is the content of the :file:`tutorial/metadata/system/2-tleap.in` 

.. code-block:: csh
        :emphasize-lines: 20, 26, 31, 36, 41
        :caption: Minimize, equilibrate and run!
        
        #!/bin/csh

        # Written By Amit Singh. This script is for the automation of amber simulations

        # Please change the variable below according to your system

        set system = xenA_h_OHP
        set amber = pmemd.cuda
        set init = xenA_h_OHP

        # These are just naming convention for different steps we are going to use 
        set mdin_prefix  = mdin
        set mini_prefix  = step1.0_mm_mini
        set heat_prefix  = step2.0_thermalisation
        set equi_prefix  = step3.0_equilibration
        set sqm_prefix   = step4.0_sqm_min
        set qmmm_prefix  = step5.0_qmmm_min


        # Step 1 --> Classical Minimization
        # In the case that there is a problem during minimization using a pmemd.cuda, please try to use pmemd only for
        # the minimization step.
        if ( ! -e ${mini_prefix}.rst7 ) then
        ${amber} -O -i ${mdin_prefix}/sander_min.in -p ${init}.parm7 -c ${init}.rst7 -o ${mini_prefix}.mdout -r ${mini_prefix}.rst7 -inf ${mini_prefix}.mdinfo -ref ${init}.rst7
        endif
        # Step 2 --> Thermalisation
        if ( ! -e ${heat_prefix}.rst7 ) then
        ${amber} -O -i ${mdin_prefix}/sander_heat.in -p ${init}.parm7 -c ${mini_prefix}.rst7 -o ${heat_prefix}.mdout -r ${heat_prefix}.rst7 -inf ${heat_prefix}.mdinfo -ref ${mini_prefix}.rst7 -x ${heat_prefix}.nc
        endif

        # Step 3 --> A Short 100ps Equilibration Run
        if ( ! -e ${equi_prefix}.rst7 ) then
        ${amber} -O -i ${mdin_prefix}/sander_equil.in -p ${init}.parm7 -c ${heat_prefix}.rst7 -o ${equi_prefix}.mdout -r ${equi_prefix}.rst7 -inf ${equi_prefix}.mdinfo -ref ${heat_prefix}.rst7 -x ${equi_prefix}.nc
        endif

        # Step 4 --> Energy Minimization using Semi-Empirical Appraoch (SQM-MM)
        if ( ! -e ${sqm_prefix}.rst7 ) then
        sander -O -i ${mdin_prefix}/sqm_min.in -p ${init}.parm7 -c ${equi_prefix}.rst7 -o ${sqm_prefix}.mdout -r ${sqm_prefix}.rst7 -inf ${sqm_prefix}.mdinfo -ref $#{equi_prefix}.rst7 -x ${sqm_prefix}.nc
        endif

        # Step 5 --> Energy Minimization using Quantum Mechanical Method (QM-MM)
        if ( ! -e ${qmmm_prefix}.rst7 ) then
        sander -O -i ${mdin_prefix}/qmmm_min.in -p ${init}.parm7 -c ${sqm_prefix}.rst7 -o ${qmmm_prefix}.mdout -r ${qmmm_prefix}.rst7 -inf ${qmmm_prefix}.mdinfo -ref ${sqm_prefix}.rst7 -x ${qmmm_prefix}.nc
        endif

Here is the final system, we just build


        


