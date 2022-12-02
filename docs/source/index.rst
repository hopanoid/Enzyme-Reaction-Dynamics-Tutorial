.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst
.. highlight:: bash
	     
.. αβγδΔ


========================
Oxime Catalysis Tutorial
========================

.. figure:: /figs/XenA-oxH-prod.png
        :scale: 1%
        :align: right

        Xenobiotic reductase A (XenA) complexed with Flavin and Oxime Colored (Green, Yellow and Red, respectively)
   


:Author: Amit Singh, University of Graz
:Tutorial: |release|
:Date: |today|

.. note::

   This project is under active development.


.. warning::

   Please raise any problems in the `issue tracker
   <https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/issues>`_.

   
Objective
=========

To perform QM/MM simulation of XenA in complex with cofactor flavin (FMNH) and substrate
Oxime (OHP), where flavin first reduces OHP to an intermediate Amine, which is further 
converted into corresponding Imine by dehydration reaction. We aim to model the respective 
reaction coordinates (Reactant, Transition States and Products) for each reaction.


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
work) to set up the system, combined with Gaussian_ to run the QM/MM simulations, and perform
analysis. An initial structure is provided, which can be found in the
:file:`tutorial/metadata/input_structures` directory, as well as the IN files that
are necessary for input to Amber. The overall workflow consists of
the following steps:

Contents
--------

.. toctree::
   system
   alternatives
   api
