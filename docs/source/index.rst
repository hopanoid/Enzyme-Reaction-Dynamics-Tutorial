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
barrier is computed using QM/MM Steered Molecular Dynamics (SMD) simulations. For full
details of the science behind this tutorial, please read `Sahrawat et al. (2024)`_:

        Sahrawat, A. S. *Deciphering the Unconventional Reduction of C=N Bonds by Old Yellow
        Enzymes Using QM/MM.* **ACS Catalysis** 2024.
        `doi:10.1021/acscatal.3c04362 <https://pubs.acs.org/doi/full/10.1021/acscatal.3c04362>`_


Tutorial files
==============

All of the necessary tutorial files can be found on GitHub in the
`hopanoid/Enzyme-Reaction-Dynamics-Tutorial
<https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/>`_
directory, which can be easily obtained by git-cloning the repository::

  git clone https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial.git


How to Cite
===========

If this tutorial contributes to your research, please cite the accompanying peer-reviewed article:

.. admonition:: Citation

        Sahrawat, A. S. *Deciphering the Unconventional Reduction of C=N Bonds by Old Yellow
        Enzymes Using QM/MM.* **ACS Catalysis** 2024.
        `doi:10.1021/acscatal.3c04362 <https://pubs.acs.org/doi/full/10.1021/acscatal.3c04362>`_

A ``CITATION.CFF`` file is included in the repository for automated citation tools (e.g., GitHub's
*Cite this repository* button).


Workflow overview
=================

For this tutorial we'll use Amber_ (v22) to set up the system, combined with TeraChem_ (v1.96H-beta,
CUDA 12.1) to run the QM/MM simulations, and NBO_ (v7.0) to perform orbital analysis.
Exact version details and hardware requirements are documented in the :doc:`hardware` page. An initial structure is provided, which can be found in the
:repodir:`tutorial/metadata/input_structures` directory, as well as the input files that
are necessary for running Amber. The overall workflow consists of the following steps:

Contents
--------

.. toctree::
   1-protein
   2-ligand
   3-system_setup
   4-settle_system
   5-qm_region
   6-qmmm_production
   7-qmmm_geom_opt
   8-smd_simulations
   9-nbo-smd
   adapt
   hardware
   glossary
   alternatives
   api
