.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

*********************
Parameterizing Ligand
*********************

==================
Know your ligands!
==================

Pay attention to the polar hydrogens in your ligands, physiochemical pH tend to modulate the
ionization of your ligands based on the pKa of these polar groups.There are several options to do so, 
the most reliable is PubChem_, where you can find experimental pKa values if available for your ligand.

We don't found any identical chemical structure for our ligand (OHP) on PubChem_. So we
need to calculate it. We have used quantum chemistry software Jaguar_, a paid tool, alternatively you can
use MarvinSketch_, which is free for academic research (need a registration to get an academic licence key), 
it has a nice visualisation of the protonation states at a different pH values.

.. admonition:: Don't rush! Active site do modulates pKa of the ligand.

        Like in our case, calculated pKa of the hydroxyl group is 7.11 (quite close to an experimentally 
        reported pka of a similar molecule) [#f1]_ , 
        which means both neutral and negatively charged species of OHP can exist equally in the solution at 
        physiological pH (7.4). However, enzymes do modulate the
        pKa of the ligands, for example, the reduced flavin (FMNH-) in the active site of OYE prefer a 
        positive substrate rather than a negatively charged substrate. [#f2]_ This prefernce could shift 
        the equilibrium towards neutral OHP. Hence, we considered modelling a neutral OHP based on the 
        prefernce of active-site of our enzyme.

        .. figure:: /figs/marvin-pka-step-4.png
                :align: center
                
                The predicted pKa of OHP in solution
 

Generating point charges and assigning atomtypes with antechamber
=================================================================

Antechamber allows the rapid generation of topology files for use with the AMBER simulation programs.
It is a higher-level wrapper around other AmberTools programs (sqm, divcon, atomtype, am1bcc, bondtype, espgen, respgen and prepgen) 
and is able to:

* Automatically identify bond and atom types
* Judge atomic equivalence
* Generate residue topology files
* Find missing force field parameters and supply reasonable suggestions

We will use antechamber to assign atom types to the OHP ligand and calculate a set of point charges. We will have to specify GAFF2 force field (``-at gaff2``, more information on the parameters here: ``$AMBERHOME/dat/leap/parm/gaff2.dat``), the AM1-BCC2 charge method (``-c bcc``), the net charge of the molecule (``-nc 0``) and the name of the new residue generated (We are going to keep OHP: ``-rn OHP``). We are going to output a mol2-type file (``-fo mol2``) containing the atomtypes and the point charges.

.. code-block:: console 

        antechamber -i OHP.pdb -fi pdb -o OHP.mol2 -fo mol2 -c bcc -nc 0 -rn OHP -at gaff2

Once we are sure that the point charges were generated The MOL2 file contains tridimensional information of the molecule as well as atom type and point charges. You can find more information on the MOL2 format here. The resulting MOL2 file is shown below:

.. code-block:: bash
        
        @<TRIPOS>MOLECULE
        OHP
        23    22     1     0     0
        SMALL
        bcc
        
        
        @<TRIPOS>ATOM
        1 C1         -16.4490    22.8370    -1.2760 c3         1 OHP      -0.175400
        2 N1         -15.0740    20.4220    -0.4270 n2         1 OHP      -0.269200
        3 O1         -17.9960    18.7030     0.1070 os         1 OHP      -0.468900
        4 C2         -17.1290    21.4970    -1.4840 c          1 OHP       0.521800
        5 O2         -18.1780    21.4070    -2.0380 o          1 OHP      -0.485100


Looking for missing force field parameters with parmchk2
========================================================

While the most likely combinations of bond, angle and dihedral parameters are defined in the parameter file it is possible that our molecule might contain combinations of atom types for bonds, angles or dihedrals that have not been parameterised. If this is the case, we will have to specify any missing parameters before we can create our prmtop and inpcrd files in LEap.

We will use parmchk2 to test if all the parameters we require are available.

.. code-block:: console
        
        parmchk2 -i OHP.mol2 -f mol2 -o OHP.frcmod -s gaff2

parmchk2 generates a parameter file that can be loaded into Leap in order to add missing parameters. It contains all of the missing parameters. If possible, it will fill in these missing parameters by analogy to a similar parameter. Let's look at the generated OHP.frcmod file:

.. code-block:: console

        Remark line goes here
        MASS

        BOND

        ANGLE

        DIHE
        c -ce-n2-oh   2    1.600       180.000           2.000      same as X -ce-ne-X , penalty score=160.5

        IMPROPER
        c3-ce-c -o         10.5          180.0         2.0          Using general improper torsional angle  X- X- c- o, penalty score=  6.0)
        c -c -ce-n2         1.1          180.0         2.0          Using the default value
        ce-o -c -os        10.5          180.0         2.0          Same as X -X -c -o , penalty score= 24.5 (use general term))

        NONBON

You should check these parameters carefully before running a simulation. If antechamber can't empirically calculate a value or has no analogy it will either add a default value that it thinks is reasonable or alternatively insert a place holder (with zeros everywhere) and the comment "**ATTN: needs revision**". In this case you will have to manually parameterise this yourself. See the links at the beginning of the section.

.. note::
        
        FURTHER INFORMATION:
        
        This step is not trivial and there are many ways to do it. In this example, as we are aiming to use a QM description of the ligand, we can use a simple approach. If you have trouble parameterising your ligands here are some useful links:
        
        * `AMBER tutorial on simple ligand parameterisation <https://ambermd.org/tutorials/basic/tutorial4/index.htm>`_
        * `AMBER tutorial on advanced ligand parameterisation <https://ambermd.org/tutorials/advanced/tutorial1/section1.htm>`_
        * `Parameterisation of dihedral angles <http://www.ub.edu/cbdd/?q=content/small-molecule-dihedrals-parametrization>`_
        * `AMBER parameter database <http://research.bmh.manchester.ac.uk/bryce/amber/>`_
        * `Paramfit tutorial <http://ambermd.org/tutorials/advanced/tutorial23/>`_




.. rubric:: Footnotes

.. [#f1] https://doi.org/10.1016/S0040-4039(01)87602-4
.. [#f2] https://doi.org/10.1038/ncomms16084
