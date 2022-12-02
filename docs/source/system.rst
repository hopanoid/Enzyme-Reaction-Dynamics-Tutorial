System Preparation
==================

.. _parametrisation:

Parametrisation
---------------

.. note::

Know your ligands and enzyme! This is very important before start following this or
any other tutorials. Use any structural visualisation program VMD_ , Pymol_ , Chimera_
Maestro_ etc, to open input structural coordinate files. This will familarise you with 
your input and will help you to track down any structural modelling deformity/error in
subsequent processes. Especially, during force field (ff) parametrisation, where some programs
guess bond order using supplied 3D coordinates and will assign ff parameter based on their 
guess. Be careful at this point! Sometime a dobule bond might treated as single or vice-versa.

.. code-block:: console

   source   /$amber-home-directory/amber.sh
