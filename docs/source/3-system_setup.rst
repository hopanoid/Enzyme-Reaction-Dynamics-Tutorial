.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

************
System Setup
************

===============
Bring together!
===============


Build system with tLEap
=======================

We are going to use default force fields (amberff14SB, tip3p and GAFF2) in this tutorial, so we can use the leaprc scripts already included in AMBER to load them into tleap:

* leaprc.protein.ff14SB for the protein
* leaprc.gaff2 for the ligand molecule
* leaprc.water.tip3p for the water molecules

.. code-block:: console
        :caption: Load force field parameters

        source leaprc.protein.ff14SB
        source leaprc.gaff2
        source leaprc.water.tip3p

Now we have to load our three units (protein, ligand and water molecules) into tLeap. We are going to start with the ligand by lading the two files we have created before: GWS.frcmod and GWS.mol2 (In this case the mol2 file already includes the correct coordinates of the ligand). After, we load the coordinates for the protein and the water molecules with the loadPB command.

.. code-block:: console
        :caption: Load force field parameters

        loadamberparams GWS.frcmod

        protein = loadPDB protein4amber.pdb
        GWS = loadmol2 GWS.mol2
        waters = loadPDB waters.pdb

From the very beginning of this series, we have split the system into these three pieces, now we join them again with the combine command.

.. code-block:: console
        :caption: Build system
        
        system = combine {GWS protein waters}
        savepdb system system.dry.pdb

        check system


