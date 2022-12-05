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

===============================
Preparing your enzyme for amber
===============================


Splitting the PDB in protein, ligand and water molecules
========================================================


First, we will split the PDB in 3 different groups: protein, ligands and water molecules as we need to treat them separately:

.. code-block:: bash

   grep -v -e "FMH" -e "OHP" -e "CONECT" -e "HOH" 5xxx.pdb >  wt_protein.pdb
   grep "FMH" 5xxx.pdb > FMH.pdb
   grep "OHP" 5xxx.pdb > OHP.pdb
   grep "HOH" 5xxx.pdb > waters.pdb

Assessing the protonation states of the enzyme with careful attention for active site residues
==============================================================================================

There are several methods to assess the protonation state of the residues in a protein. Not limited to following:

* Online Servers
        
        * `H++ server <http://biophysics.cs.vt.edu>`_ 

                * The H++ program uses AmberTools modules to preprocess a PDB file, 
                  and it is able to generate basic topology and coordinate files in AMBER format.

        * `PROPKA <https://www.ddl.unimi.it/vegaol/propka.htm>`_
        
        * `PDB2PQR <https://server.poissonboltzmann.org/pdb2pqr>`_

        * `MCCE <https://sites.google.com/site/mccewiki/>`_

* GUI Tools

        * Maestro_ 
          
                * `Protein-Preparation-Wizard <https://www.schrodinger.com/science-articles/protein-preparation-wizard>`_
        
        * Chimera_ 
          
                * `AddH <https://www.cgl.ucsf.edu/chimera/docs/ContributedSoftware/addh/addh.html>`_ 

        * Pymol_   
                
                * `H Add <https://pymolwiki.org/index.php/H_Add>`_
        
.. note::

        Histidines are tricky residues, they have three possible protonation states: HID, HIE and HIP. 
        HIP is the protonated residue. HID and HIE correspond to the two natural tautomers of the neutral 
        histidine, where the proton can be found in delta or epsilon positions. In solution, the most 
        common conformer is HIE but always visualise your structure before assuming any histidine protonation state.

        Here is an example showing the typical active site of Old Yellow Enzymes (OYE). XenA is a member of this class
        and after protonation, we found that protonation state of H178 predicted as HID, which is not correct, considering 
        the presence of substrate, the H178 forms a hydrogen bond with the carbonyl oxygen.

        .. image:: /figs/XenA-oxH-prod.png
                :width: 200
                :align: center
                :alt: Xenobiotic reductase A (XenA) complexed with Flavin and Oxime Colored (Green, Yellow and Red, respectively)

How to select protonation state of a residue?
=============================================

.. code-block:: bash
        
        module load amber/amber20
        tleap -f leaprc.protein.ff14SB
        s = loadpdb protein.pdb
        set {s.177 s.180} name "HID"
        savepdb s wt_protein.pdb
        quit

