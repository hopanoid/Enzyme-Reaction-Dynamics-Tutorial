.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

*********************
Parameterizing Ligand
*********************

==================
Know your ligands!
==================

We will now move to check the protonation state of the ligand. We have to check the pKa of the ligand. 
There are several options to do so, the most reliable one if available is PubChem, where you can find 
experimental pKa values.

Exactly for our ligand (OHP) there are no pKa values (neither experimental nor calculated) reported. So we
need to calculate it. We have used quantum chemistry software Jaguar_, a paid tool, alternatively you can
use MarvinSketch_, which is free for academic research (need registeration to get a academic licence key), 
it has a nice visualisation of the chemical species at a different pH values.

.. admonition:: Don't rush and pay attention towards polar groups in your ligand!

        Pay attention to the polar hydrogens in your ligands, physiochemical pH tend to modulate
        ionization of your ligands based on the pKa of these polar groups. Like in our case, calculated 
        pKa of the hydroxyl group is 7.11 (quite close to an experimentally reported pka of a similar molecule) [#f1]_ , 
        which means both neutral and negatively charged species of OHP can exist equally in the solution at 
        physiological pH (7.4). However, enzymes do modulate the
        pKa of the ligands, for example, the reduced flavin (FMNH) in the active site of OYE prefer a 
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

We will use antechamber to assign atom types to the GWS ligand and calculate a set of point charges. We will have to specify GAFF2 force field (-at gaff2, more information on the parameters here: $AMBERHOME/dat/leap/parm/gaff2.dat), the AM1-BCC2 charge method (-c bcc), the net charge of the molecule (-nc 0) and the name of the new residue generated (We are going to keep GWS: -rn GWS). We are going to output a mol2-type file (-fo mol2) containing the atomtypes and the point charges.

.. code-block:: console 

        antechamber -i OHP.pdb -fi pdb -o OHP.mol2 -fo mol2 -c bcc -nc 0 -rn OHP -at gaff2

.. rubric:: Footnotes

.. [#f1] https://doi.org/10.1016/S0040-4039(01)87602-4
.. [#f2] https://doi.org/10.1038/ncomms16084
