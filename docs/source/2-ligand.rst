*********************
Parameterizing Ligand
*********************

==================
Know your ligands!
==================

So far we have not paid attention to the ligand. We will now move to check the protonation state of the ligand.
We have to check the pKa of the ligand. There are several options to do so, the most reliable one if available
is PubChem, where you can find experimental pKa values.

In this example, there are no pKa values (neither experimental nor calculated) reported for this molecule, so we
need to use another resource. I like Marvin Sketch because it is free to use (you need to register and cannot
use it for comercial purposes), it gives calculated pKa values and it has a nice visualisation of the chemical
species at a different pH values.

.. admonition:: Don't rush and pay attention towards polar groups in your ligand!

        Pay attention to the polar hydrogens in your ligands, physiochemical pH tend to modulate
        ionization of your ligands based on the pKa of these polar groups. Like in our case, calculated 
        pKa of the hydroxyl group is 7.11, which means both neutral and negatively charged species of 
        OHP can exist equally in the solution at physiological pH (7.4). However, enzymes do modulate the
        pKa of the ligands, for example, the reduced flavin (FMNH) in the active site of OYE prefer a 
        positive substrate rather than a negatively charged substrate [#f1]_. This prefernce could shift 
        the equilibrium towards neutral OHP. Hence, we considered modelling a neutral OHP based on the 
        prefernce of active-site of our enzyme.

        .. figure:: /figs/marvin-pka-step-4.png
                :align: center
                
                The predicted pKa of OHP in solution
 



.. rubric:: Footnotes

.. [#f1] https://doi.org/10.1038/ncomms16084
