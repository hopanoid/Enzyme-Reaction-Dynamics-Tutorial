.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

***************************
QM/MM Geometry Optimisation
***************************

==================================
Chose rightly and truncate wisely!
==================================

From our three 5 ps QM/MM production runs, we can summarise the geomterical parameters of ligand-protein interactions. However, to get a representative
structure for reactant, transition state and product state we need to optise the structure further. For this, we choose to took a random frame from our
last QM/MM production run, and further truncated it to be used as input for a QM package. The truncation step involves, the removal of solvent molecules
those are not within 5 Angstrom from any protein atom. Truncation step can be done by using the graphical structure modelling programs like VMD_ or Pymol_
or by using any programming tools like Biopdb module of Biopython library in python. Our main goal is to understand the structure of the active site and
the nearby residues, we believe it would be better to leave the solvent molecules far apart from the active site, at the same time, it would save some 
computation time as well. 

.. admonition:: How to choose a snapshot from the MD simulations for QM/MM geometry optimisation?

        For modelling the structural coordinates of the biocatalysis reactions, we often took random snapshots from the
        MD simulations, usually more than one for better statistical assessment. We advice a more investigative approach
        rather than choosing a random snapshot. In our case, we monitor some key geomterical parameters pertaining to hydride
        transfer, like the distance between the hydride acceptor (N1) and donor (N5), the angle between the N5, N1 and hydride (H1)
        etc. A table summarising these geometrical parameters is available in our supplementary file (Table S1). The average value
        of the these parameters have been considered to obtain a frame from QM/MM MD simulations. This ensures that the chosen
        structure represents the active site better than a randomly chosen structure.
         

We have used Qsite_ (the QM/MM module of the Schroedinger package) for modelling the reaction coordinates using the truncated structure as an input.
A brief details of our chosen parameters for QM/MM geometry optimisation is available in our methodolgy section of supplementary information. There
are already several tutorial available demonstrating the QM/MM geomtery optimisation of reaction coordinates:

.. hlist::
        :columns: 1

        * QM/MM Geometry Optimisation Tutorials

                * Qsite    --> `<https://www.schrodinger.com/training/defining-qm-and-mm-regions-qsite221>`_

                * Gaussian --> `<http://schlegelgroup.wayne.edu/Software/oniomtoolTAO/TAOtutorial.html>`_

                * Orca     --> `<https://www.orcasoftware.de/tutorials_orca/multi/basics.html>`_

                * NWChem   --> `<https://nwchemgit.github.io/ONIOM.html>`_

