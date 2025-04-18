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
# If there is a problem during minimization using pmemd.cuda, please try to use pmemd only for
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
