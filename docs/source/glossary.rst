.. -*- encoding: utf-8 -*-

.. meta::
   :description: Glossary of QM/MM, AMBER, and computational chemistry terms used in this biocatalysis tutorial. Definitions for SMD, NBO, CV, GAFF2, electronic embedding, and more.
   :keywords: QM/MM glossary, AMBER terms, SMD definition, NBO definition, collective variable, GAFF2, electronic embedding, computational chemistry

********
Glossary
********

.. glossary::
   :sorted:

   AMBER
      Assisted Model Building with Energy Refinement. A family of force
      fields and a suite of molecular dynamics programs widely used for
      biomolecular simulations. In this tutorial, ``pmemd.cuda`` and
      ``sander`` are the primary executables.

   Antechamber
      An AMBER tool that automates the assignment of atom types and
      partial charges for small organic molecules. Used in :doc:`2-ligand`
      to generate GAFF2 parameters for the oxime substrate.

   CM5 charges
      Class IV charge model, variant 5. Atomic point charges derived from
      Hirshfeld population analysis and corrected for long-range
      electrostatics. Computed here using Gaussian as the external QM
      package.

   Collective Variable (CV)
      A reaction coordinate that describes the progress of a chemical or
      conformational transformation. In :doc:`8-smd_simulations` the CV is
      a linear combination of distances (LCOD) encoding the hydride
      transfer from flavin N5 to substrate N1.

   Electronic embedding
      A QM/MM coupling scheme in which the MM point charges are included
      in the QM Hamiltonian. This polarises the QM wavefunction by the
      electrostatic environment of the protein. Activated by
      ``qmmm_int = 1`` in AMBER.

   FMNH⁻ / FMN
      Flavin mononucleotide. The reduced form (FMNH⁻) carries the hydride
      at N5 of the isoalloxazine ring and acts as the hydride donor in Old
      Yellow Enzyme reactions. Abbreviated as FMH in the AMBER topology
      used in this tutorial.

   Force field
      A mathematical model describing the potential energy of a molecular
      system as a sum of bonded (bonds, angles, torsions) and non-bonded
      (van der Waals, electrostatics) terms. This tutorial uses ff19SB for
      the protein and GAFF2 for the ligands.

   Free energy profile
      The change in free energy along a reaction coordinate, computed here
      from QM/MM SMD trajectories using the fluctuation-dissipation (FD)
      estimator. Equivalent to a potential of mean force (PMF) when
      sampled sufficiently.

   GAFF2
      General AMBER Force Field version 2. An extension of the standard
      AMBER force field designed for small organic molecules. Parameters
      are stored in ``$AMBERHOME/dat/leap/parm/gaff2.dat``.

   HOMO-LUMO gap
      The energy difference between the Highest Occupied Molecular Orbital
      (HOMO) and the Lowest Unoccupied Molecular Orbital (LUMO). A gap of
      zero indicates a problematic electronic state. Monitoring this
      during QM/MM MD is recommended to detect SCF convergence failures.

   Hirshfeld charges
      Atomic partial charges derived by partitioning the electron density
      according to the weight of the promolecular density of each atom.
      The basis for CM5 charges. Requested in Gaussian via
      ``pop=hirshfeld``.

   Link atom
      A hydrogen atom inserted at the QM/MM boundary to cap a severed
      covalent bond. It satisfies the valency of the outermost QM atom
      and is invisible to the MM region. Handled automatically by AMBER
      ``sander``.

   MM region
      The part of the system described by classical molecular mechanics
      force field parameters. In this tutorial all protein atoms outside
      the QM mask, water molecules, and counter-ions form the MM region.

   NBO
      Natural Bond Orbital. A mathematical transformation of the
      Kohn-Sham or Hartree-Fock orbitals into an orthonormal set that
      closely resembles the Lewis dot structure picture of bonding.
      Used in :doc:`9-nbo-smd` to track bond order changes along the
      reaction coordinate.

   NPT ensemble
      Molecular dynamics at constant particle number (N), pressure (P)
      and temperature (T). Used during equilibration to allow the system
      volume to relax to the correct density.

   NVT ensemble
      Molecular dynamics at constant particle number (N), volume (V) and
      temperature (T). Used during thermalisation in :doc:`4-settle_system`.

   Old Yellow Enzyme (OYE)
      A family of flavin-dependent oxidoreductases. XenA (Xenobiotic
      reductase A) belongs to the OYE-3 subfamily and is the enzyme
      studied in this tutorial.

   prmtop / parm7
      The AMBER topology file containing force field parameters, atom
      types, charges, and connectivity for the entire system. Generated
      by ``tLEaP`` and read by all AMBER MD programs.

   QM region
      The subset of atoms treated with a quantum mechanical method
      (B3LYP/6-31G* here). Selected via the ``qmmask`` keyword in the
      AMBER ``.in`` file. In this tutorial the QM4 region comprises the
      substrate, lumiflavin, and four active-site residues.

   QM/MM
      Combined Quantum Mechanics / Molecular Mechanics. A multi-scale
      method in which a chemically important region (the active site) is
      treated with QM, while the surrounding protein and solvent are
      described by classical MM. The two regions are coupled
      electrostatically via electronic embedding.

   rst7
      The AMBER coordinate/restart file containing atomic positions and
      velocities at a given point in a simulation. Passed to subsequent
      steps via the ``-c`` flag.

   SHAKE
      A constraint algorithm that removes high-frequency bond vibrations
      involving hydrogen atoms, allowing a 2 fs time step. Activated by
      ``ntc=2, ntf=2`` in AMBER.

   SMD
      Steered Molecular Dynamics. An enhanced sampling method that applies
      a time-dependent harmonic restraint (the "steering force") to a
      collective variable, driving the system along a predefined reaction
      coordinate. The work done by the steering force is used to estimate
      the free energy change.

   SQM
      Semi-empirical Quantum Mechanics. A computationally inexpensive QM
      method (PM6-DH+ in this tutorial) used for a preliminary QM/MM
      minimisation step before the more expensive DFT-based QM/MM
      minimisation.

   TeraChem
      A GPU-accelerated quantum chemistry package developed by PetaChem.
      Used as the external QM engine for B3LYP/6-31G* calculations in
      this tutorial via AMBER's file-based interface (``qm_theory =
      'EXTERN'``).

   tLEaP
      The AMBER program for building molecular topology and coordinate
      files. Used in :doc:`3-system_setup` to combine the protein,
      cofactor, substrate, water and ions into a single solvated system.

   VDD charges
      Voronoi Deformation Density charges. Atomic partial charges obtained
      by integrating the deformation density (the difference between the
      molecular and promolecular electron density) over Voronoi cells.
      Computed in TeraChem via ``poptype vdd``.

   XenA
      Xenobiotic reductase A. An ene-reductase from *Pseudomonas putida*
      belonging to the Old Yellow Enzyme family. XenA reduces the
      carbon-carbon double bond of electron-poor alkenes using FMNH⁻ as
      the hydride donor. Crystal structure available as PDB entry 8AU8_.
