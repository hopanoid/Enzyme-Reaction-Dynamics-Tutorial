Scripts Reference
=================

The following automation scripts are provided in the tutorial repository
under ``tutorial/``.

Pre-processing
--------------

``pre-processing/1-amber-pre-run.sh``
    Runs the full classical and QM/MM minimisation/equilibration pipeline
    (Steps 1–5: MM minimisation, thermalisation, equilibration, SQM-MM and
    QM-MM energy minimisation).

``pre-processing/2-amber-qm-vs-hirs-chrgs.sh``
    QM/MM MD runs using Gaussian as the external QM package; captures
    Hirshfeld CM5 charge log files at each step.

``pre-processing/2-amber-qm-vs-vdd-chrgs.sh``
    QM/MM MD runs using TeraChem as the external QM package; captures
    VDD charge output files at each step.

Simulations
-----------

``simulations/3-amber-tc-prod.sh``
    Runs three independent 5 ps QM/MM production simulations using TeraChem.

``simulations/4-amber-tc-smd-hy-1.sh``
    Runs 95 independent QM/MM SMD simulations for the hydride-transfer CV,
    randomly selecting starting configurations.

``simulations/nbo/5-amber-tc-nbo-smd-hy-1.sh``
    Runs 5 QM/MM SMD simulations (indices 96–100) coupled with NBO analysis;
    saves ``.47`` NBO input files at each step.
