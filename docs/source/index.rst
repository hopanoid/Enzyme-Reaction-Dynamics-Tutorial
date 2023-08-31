.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst
.. highlight:: bash
	     
.. αβγδΔ


=================================================
Deciphering Oxime Biocatalysis (A QM/MM Tutorial)
=================================================

.. image:: /figs/XenA-oxH-prod.png
        :width: 200
        :align: right
        :alt: Xenobiotic reductase A (XenA) complexed with Flavin and Oxime Colored (Green, Yellow and Red, respectively)
   


:Author: Amit Singh Sahrawat, University of Graz (amit.amit@uni-graz.at)
:Tutorial: |release|
:Date: |today|

.. note::

   This project is under active development.


.. warning::

   Please raise any problems in the `issue tracker
   <https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/issues>`_.

   
Objective
=========

To decipher the newly discovered mechanistic intricacies of the conversion of oximes 
to amines via imines by reductive dehydration. Using QM/MM simulations, we aim to model 
the molecular structures corresponding to the respective reaction coordinates 
(Reactant, Transition States and Products) for each reaction pathway. Finally, the energy 
barrier would be computed using QM/MM Steered Molecular Dynamics (SMD) simulations. For more
details about this biotransformation scheme, please read our publication doi:xxxxxx(Yet to be 
issued).


Tutorial files
==============

All of the necessary tutorial files can be found on GitHub in the
`hopanoid/Enzyme-Reaction-Dynamics-Tutorial
<https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/>`_
directory, which can be easily obtained by git-cloning the repository::

  git clone https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial.git


Workflow overview
=================

For this tutorial we'll use Amber_ (2021, 2022 should
work) to set up the system, combined with Terachem_ to run the QM/MM simulations, and NBO_ to 
perform orbital analysis. An initial structure is provided, which can be found in the
:file:`tutorial/metadata/input_structures` directory, as well as the input files that
are necessary for running Amber. The overall workflow consists of the following steps:

Contents
--------

.. toctree::
   1-protein
   2-ligand
   3-system_setup
   4-settle_system
   5-qm_region.rst
   6-qmmm_production.rst
   7-smd_simulations.rst
   8-nbo-smd.rst
   alternatives
   api
