.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

*******************************
Adapting This Tutorial to Your System
*******************************

This tutorial is built around a specific system: Xenobiotic reductase A
(XenA) complexed with the oxime substrate OHP and the flavin cofactor FMH.
Every step that references atom indices, residue numbers, ligand names or
simulation lengths is system-specific. This page walks through each of
those decision points so you can substitute your own enzyme and substrate.

.. contents:: On this page
   :local:
   :depth: 1

1. Input structure
==================

Replace :file:`8AU8.pdb` with your own PDB file. Before proceeding, check:

- **Chain IDs** — confirm whether your structure has multiple chains and
  adjust the ``grep`` splitting commands in :doc:`1-protein` accordingly.
- **Residue naming** — non-standard residues (cofactors, modified amino
  acids) may have different three-letter codes than expected by AMBER.
  Inspect the REMARK and HETNAM records of your PDB.
- **Completeness** — X-ray structures often have missing loops or
  disordered sidechains. Use Modeller_, Maestro_ or Chimera_ to rebuild
  them before parametrisation.
- **Alternate conformations** — remove all ``ALTLOC`` records (keep only
  the highest-occupancy conformer) before passing to ``pdb4amber``.

2. Residue and ligand names
============================

``FMH`` and ``OHP`` appear in every ``grep``, ``loadPDB``, and ``qmmask``
line throughout the tutorial. Replace them with the residue names used in
your PDB's ATOM/HETATM records.

.. note::

   If your cofactor is a standard AMBER residue (e.g. FAD, NAD, HEM),
   it is already parametrised in the force field. Skip the
   ``antechamber``/``parmchk2`` steps for that molecule and load it
   directly via ``leaprc``.

3. Protonation state residue numbers
=====================================

``H178`` and ``H181`` in :doc:`1-protein` are active-site histidines
specific to XenA. For your enzyme:

1. Run your protonated PDB through H++, PROPKA_ or PDB2PQR_ to get
   predicted protonation states.
2. Visualise the active site in VMD_ or Pymol_ — always override
   automated predictions if the chemistry demands it (see the HID/HIE
   warning in :doc:`1-protein`).
3. Update the LEaP ``set`` command with your own residue numbers::

     set {prot.YOUR_RES1 prot.YOUR_RES2} name "HID"

4. Recalculate the total QM charge (see point 5 below) after finalising
   protonation states — they directly affect it.

4. QM region atom masks
========================

The ``qmmask`` string (e.g. ``':723|@10985-11005,...'``) encodes atom
indices derived from the numbering in :file:`xenA_h_OHP.parm7`. These
indices **will be completely different** in your system. Use the following
workflow:

**Step 1 — run SQM-MM minimisation with** ``writepdb = 1``

This writes ``qmmm_region.pdb`` for whichever mask you supply. Start with
a minimal mask covering only your substrate and the nearest catalytic
residue.

**Step 2 — inspect visually**

Open ``qmmm_region.pdb`` in VMD_ or Pymol_ and confirm the selection is
chemically sensible (no broken bonds at the QM/MM boundary, no missing
link atoms).

**Step 3 — extract atom indices**

.. code-block:: bash

   grep "ATOM\|HETATM" solvated_system.pdb | awk '{print NR, $3, $4, $5}'

Cross-reference the residue name and number columns to identify the
indices for your active-site residues.

**Step 4 — converge the QM region size**

As described in :doc:`5-qm_region`, run short QM/MM MD simulations
with progressively larger QM regions and monitor the total atomic charge
of the substrate. Stop expanding once the charges stabilise (see
supplementary figure S26(a) in the original article for an example).

.. admonition:: Rule of thumb

   Begin with substrate + cofactor + the one or two residues that
   donate/accept a proton or hydride. Add the next shell of residues
   only if charges or energies have not converged.

5. QM total charge
===================

``qmcharge = -1`` reflects neutral OHP combined with the reduced flavin
FMNH⁻ in the QM4 region of this system. For your system:

1. Write out the formal charges of every atom in your ``qmmask``.
2. Sum them. That integer is your ``qmcharge``.
3. Double-check by comparing the charge of the isolated QM fragment
   (from ``writepdb = 1``) against the sum of residue formal charges.

A wrong ``qmcharge`` causes SCF convergence failures or qualitatively
incorrect electronic structure — it is one of the most common errors in
QM/MM setup.

6. Collective variable atom indices
=====================================

In :repo:`tutorial/simulations/mdin/cv-hy-1.in`, the indices
``11078`` (substrate N1), ``11007`` (hydride H5) and ``10996`` (flavin N5)
are system-specific. To replace them:

1. Identify the **donor**, **transferring atom** and **acceptor** in your
   reaction from the literature or from your QM/MM production trajectories.
2. Locate their atom numbers in your ``.prmtop``/``.pdb``::

     grep "ATOM\|HETATM" qmmm_region.pdb | grep " H5 \| N1 \| N5 "

3. Run a 1D QM/MM coordinate scan along the donor–acceptor distance using
   Qsite_ or Gaussian_ (as described in :doc:`8-smd_simulations`) to find
   the energy minimum. Use that distance as the SMD starting value.
4. Update ``cv_i``, ``path`` and ``harm`` in the CV file to reflect your
   atom indices and the scan-derived starting geometry.

.. warning::

   The spring constant ``harm = 1000.0`` kcal/mol/|kJ/mol/nm**2| and
   the 1 ps steering time are calibrated for a hydride/proton transfer
   in this system. For slower or longer-range CVs, reduce the velocity
   (increase ``nstlim``) to avoid non-equilibrium artefacts.

7. Number and length of simulations
=====================================

The simulation counts in this tutorial (3 × 5 ps production, 95 SMD runs)
are not universal — they reflect the convergence behaviour of this
particular reaction. For a new system:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Parameter
     - Recommendation
   * - QM/MM production length
     - Start with 1–2 ps per replica. Extend if key geometrical
       parameters (distances, angles) have not converged.
   * - Number of SMD replicas
     - Run 10–20 first. Plot the free energy profile and its standard
       deviation. Add more replicas until the profile shape is stable.
   * - SMD duration (``nstlim``)
     - 1 ps is appropriate for short-range transfers (< 1.5 Å). For
       conformational CVs or longer-range processes, use 5–10 ps per
       trajectory and reduce the spring constant proportionally.
   * - Starting configurations
     - Sample diverse starting frames (different values of key
       distances) rather than clustering around a single geometry.
