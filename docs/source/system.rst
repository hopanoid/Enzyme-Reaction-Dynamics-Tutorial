.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

##################
System Preparation
##################

.. _parametrisation:

***************
Parametrisation
***************

.. important::

        Know your ligands and enzyme! This is very important before start following this or
        any other tutorials. Use any structural visualisation program like VMD_, Pymol_, Chimera_,
        Maestro_ etc, to open input structural coordinate files. This will familarise you with 
        your input and will help you to track down any structural modelling deformity/error in
        subsequent processes. Especially, during force field (ff) parametrisation, where some programs
        guess bond order using supplied 3D coordinates and will assign ff parameter based on their 
        guess. Be careful at this point! Sometime a dobule bond might treated as single or vice-versa.

Preparing your enzyme for amber
===============================


Splitting the PDB in protein, ligand and water molecules
--------------------------------------------------------


First, we will split the PDB in 3 different groups: protein, ligands and water molecules as we need to treat them separately:

.. code-block:: bash

   grep -v -e "FMH" -e "OHP" -e "CONECT" -e "HOH" 5xxx.pdb >  wt_protein.pdb
   grep "FMH" 5xxx.pdb > FMH.pdb
   grep "OHP" 5xxx.pdb > OHP.pdb
   grep "HOH" 5xxx.pdb > waters.pdb

Assessing the protonation states of the enzyme with careful attention for active site residues
----------------------------------------------------------------------------------------------

There are several methods to assess the protonation state of the residues in a protein. For example, the [H++ server](http://biophysics.cs.vt.edu) and [PROPKA](http://propka.org) open access softwares can be used. In our case we have used Maestro_ which can also be employed for academic use.



