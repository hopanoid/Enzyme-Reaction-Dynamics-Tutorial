.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst
.. highlight:: bash
	     
.. αβγδΔ


========================
Oxime Catalysis Tutorial
========================

.. image:: /figs/XenA-oxH-prod.*
   :width: 50%
   :alt: Falvin in Action (XenA)
   :align: right

..   Adenylate Kinase (XenA). Secondary structure elements are colored
..   (magenta: α-helices, yellow: β-sheets).


:Amber: aiming for 2021 (maybe will work for later)
:Tutorial: |release|
:Date: |today|

.. note::

   This project is under active development.


.. warning::

   Please raise any problems in the `issue tracker
   <https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/issues>`_.

   
.. seealso::

   Other Alternatives
        Bioexcel's excellent tutorials 
                `Biomolecular QM/MM simulations with CP2K using AmberTools
                <https://docs.bioexcel.eu/2020_06_09_online_ambertools4cp2k/>`
                
                `Biomolecular QM/MM simulations with Gromacs + CP2K
                <https://docs.bioexcel.eu/2021-04-22-qmmm-gromacs-cp2k/10-gmx+cp2k/index.html>`


       

Objective
=========

Perform an all-atom molecular dynamics (MD) simulation—using the Amber_
MD package—of the apo enzyme adenylate kinase (AdK) in its open conformation in
a physiologically realistic environment, and carry out a basic analysis of its
structural properties in equilibrium.


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
work) to set up the system, run the simulation, and perform
analysis. An initial structure is provided, which can be found in the
:file:`tutorial/metadata/input_structures` directory, as well as the MDP files that
are necessary for input to Gromacs. The overall workflow consists of
the following steps:

Contents
--------

.. toctree::
   Parametrisation
   usage
   api
