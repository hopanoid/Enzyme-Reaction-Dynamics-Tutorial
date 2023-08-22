.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

******************
Select A QM System 
******************

===============================================
How to choose appropriate QM atoms for QM layer  
===============================================

What should be the composition of QM regions and which residues should be included. This is an important question to ask while modelling an enzymatic reaction using QM/MM simulations. A couple of articles available on this [#f1]_, [#f2]_ but there are no straightforward answers. However, chemical intution or proximity is a basic choice to begin, later on the perimter of QM region could be expanded if your computational resources permits. Following this, we also begin with the OYE active site residues e.g. H178, H181, Y183. Overall, we have modelled six different QM regions, details of which are availabe in our supplementary pdf file of our article. We have evaluated the convergence of total atomic charges on the substrate along the increasing number of atoms in QM region, finally we have choosed the QM region comprising of Y27, H178, H181, Y183, LumiFlavin, substarte and the nearest water molecule.   

Again, the method for the calculation of atomic charges are also debatable. We have considered Hirshfeld CM5 method, based on the recommendation of Wiberg et. al. [#f3]_.

1. Classical Energy Minimization
        * Will try to optimize the position of atoms using the supplied molecular mechanics parameters e.g. bond-length, angle, van-der-waal etc

.. code-block:: 
        :emphasize-lines: 7,8
        :caption: Step 1 --> Classical Minimization

        Minimisation of system
        &cntrl
        imin=1,        ! Perform an energy minimization.
        maxcyc=4000,   ! The maximum number of cycles of minimization.
        ncyc=2000,     ! The method will be switched from steepest descent to conjugate gradient after NCYC cycles.
        ntr=1,         ! Enabling restraints
        restraint_wt = 10,          ! 10 kcal/mol/A**2 restraint force constant
        restraintmask = '!@H=&!:WAT,Na+' ! Restraints on the solute heavy atom
         /
        
We are aiming to preserve the heavy atom positions, for this we are using a small restraint (10 kcal/mol/A^2) on the protein's heavy atom. You can commentout the highlighted lines (just add ! in the begining) if you wanna minimise all atoms.       
                
Here is the final system, we just build and minimised


.. rubric:: Footnotes

.. [#f1] https://doi.org/10.1021/acs.jpcb.6b07814
.. [#f2] https://doi.org/10.1021/acs.jcim.2c01522
.. [#f3] https://doi.org/10.1021/acs.joc.8b02740
