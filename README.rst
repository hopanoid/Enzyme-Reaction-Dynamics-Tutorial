Deciphering Oxime Biocatalysis — A QM/MM Tutorial
===================================================

A step-by-step tutorial on modelling enzymatic oxime-to-amine conversion
using QM/MM simulations with Amber/TeraChem/NBO.

Tutorial: https://enzyme-reaction-dynamics-tutorial.readthedocs.io/

Source files: https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial


Prerequisites
-------------

- Amber 2021 or 2022 (with ``pmemd.cuda`` and ``sander``)
- TeraChem (demo or licensed) **or** Gaussian 16/09
- NBO 6 or 7 (for orbital analysis steps)
- AmberTools (``antechamber``, ``parmchk2``, ``tleap``, ``pdb4amber``)
- A visualisation program: VMD, PyMOL, or Chimera


Building the documentation locally
------------------------------------

.. code-block:: bash

   pip install sphinx sphinx-rtd-theme
   cd docs
   make html

Open ``docs/_build/html/index.html`` in your browser.


Issues
------

Please report problems at:
https://github.com/hopanoid/Enzyme-Reaction-Dynamics-Tutorial/issues
