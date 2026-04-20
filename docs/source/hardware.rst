.. -*- encoding: utf-8 -*-

.. include:: /includes/defs.rst
.. include:: /includes/links.rst

.. meta::
   :description: Hardware requirements for QM/MM simulations with AMBER, TeraChem and NBO. GPU recommendations for TeraChem CUDA, pmemd.cuda and CPU requirements for sander QM/MM and NBO analysis.
   :keywords: TeraChem GPU requirements, AMBER pmemd.cuda GPU, sander CPU QM/MM, NBO CPU, CUDA cores, RTX 3090, RTX 4090, Nvidia GPU QM/MM

****************************
Hardware Requirements
****************************

==========================================
What You Need to Run This Tutorial
==========================================

This tutorial couples three distinct computational tools — AMBER_, TeraChem_, and NBO_ — and each has
different hardware demands. The table below gives a quick overview; detailed guidance for each component
follows.

.. list-table::
   :header-rows: 1
   :widths: 20 20 20 40

   * - Software
     - Step in Tutorial
     - Hardware
     - Notes
   * - ``pmemd.cuda``
     - Classical MD (Steps 1–3)
     - Nvidia GPU
     - Any modern Nvidia GPU; CUDA-enabled
   * - ``sander``
     - QM/MM minimisation and production MD
     - CPU (multi-core)
     - AMBER's QM/MM interface does not use the GPU
   * - TeraChem_
     - QM calculations within QM/MM
     - Nvidia GPU (CUDA)
     - CUDA core count is the key metric, not vRAM
   * - NBO_
     - NBO analysis alongside QM/MM SMD
     - CPU (multi-core)
     - Runs on CPU only; scales well with core count


TeraChem: GPU is Essential, CUDA Cores are the Key
===================================================

TeraChem_ performs all its electronic structure calculations directly on the GPU. It is written entirely
in CUDA and achieves substantial speedups over CPU-based QM packages precisely because it maps the
linear-algebra operations of DFT onto the massive parallelism of a GPU's shader cores.

**What matters most: CUDA core count, not vRAM.**

The QM region in a typical enzyme simulation (50–150 atoms with a 6-31G* basis) fits comfortably within
4–8 GB of GPU memory. What limits throughput is floating-point throughput, i.e., the number of CUDA
cores running in parallel. A high-end gaming GPU with a large core count will therefore outperform a
workstation GPU that has more vRAM but fewer cores.

.. admonition:: Best price-to-performance GPUs for TeraChem

        Consumer-grade Nvidia GPUs offer an excellent price-to-performance ratio for TeraChem. Our
        recommended choices (in order of increasing performance):

        * **RTX 3090** — 10,496 CUDA cores, 24 GB GDDR6X. A strong performer for QM/MM and widely
          available second-hand.
        * **RTX 4090** — 16,384 CUDA cores, 24 GB GDDR6X. Currently one of the best single-GPU
          options for TeraChem.
        * **RTX 5090** — 21,760 CUDA cores, 32 GB GDDR7. The latest generation; best single-GPU
          performance available as of 2025.

        For multi-GPU runs (``ngpus = 2`` in the TeraChem template), two RTX 4090s or two RTX 3090s
        are a very practical and cost-effective setup. The demo version of TeraChem supports up to
        two GPUs and a maximum runtime of 15 minutes per job, which is sufficient for the QM/MM MD
        steps in this tutorial.

.. note::

        TeraChem requires an Nvidia GPU with CUDA compute capability ≥ 3.5. AMD and Intel GPUs are
        not supported. Always install the CUDA toolkit version that matches your TeraChem build.


AMBER ``pmemd.cuda``: GPU-Accelerated Classical MD
====================================================

The classical MD steps (minimisation, thermalisation, NPT equilibration in :doc:`4-settle_system`)
use ``pmemd.cuda``, AMBER's GPU-accelerated production engine. For these steps the GPU is used
primarily for non-bonded force evaluation, and any modern Nvidia GPU (Turing architecture or newer)
will provide a substantial speedup over CPU-only ``pmemd``.

There is no strict minimum vRAM for the system sizes typical in this tutorial (~70,000 atoms with
solvent), but 8 GB or more is comfortable. The same RTX 3090/4090/5090 GPUs recommended for
TeraChem work equally well here.

.. important::

        ``pmemd.cuda`` and TeraChem cannot share the same GPU simultaneously, as TeraChem claims the
        full GPU memory for its QM calculations. In practice this is not an issue because the
        ``pmemd.cuda`` classical equilibration steps complete before the QM/MM production runs begin.
        On a multi-GPU node you can run ``pmemd.cuda`` on one GPU while TeraChem runs on another.


AMBER ``sander``: QM/MM Runs on CPU
=====================================

The QM/MM production runs and SMD simulations (:doc:`6-qmmm_production`, :doc:`8-smd_simulations`)
use AMBER's ``sander`` engine, not ``pmemd.cuda``. This is because the QM/MM interface in AMBER —
the file-based protocol that hands coordinates to TeraChem and reads back energies and gradients —
is implemented only in ``sander``. The MM part of the force evaluation in ``sander`` runs on CPU.

In practice, ``sander`` is not the computational bottleneck: TeraChem on the GPU handles the
expensive QM step, and ``sander`` simply manages the I/O and MM calculation between QM calls.
A modern multi-core workstation CPU (8–32 cores) is more than sufficient for the ``sander`` side.


NBO: CPU-Only, Scales with Core Count
=======================================

NBO_ (Natural Bond Orbital) analysis runs entirely on CPU. At each step of the NBO-coupled QM/MM
SMD simulations (:doc:`9-nbo-smd`), TeraChem writes a ``.47`` wavefunction file and calls the NBO
binary, which processes the orbital information and returns the results to TeraChem before the next
MD step proceeds.

NBO7 parallelises well across CPU cores; providing 8–16 dedicated CPU cores will keep the NBO step
from becoming a bottleneck in the overall QM/MM SMD pipeline. Ensure the NBO executable path is
correctly set in your environment before running these simulations:

.. code-block:: bash

        export NBOEXE="$your_nbo_install_dir/bin/nbo7.i4.exe"


Summary: a Practical Single-Workstation Setup
==============================================

The simulations in this tutorial were carried out on a workstation with two consumer-grade Nvidia
GPUs. The following configuration is representative of what you need:

* **GPU**: 2 × Nvidia RTX 3090 (or RTX 4090 / 5090 for better performance)
* **CPU**: 16–32 cores (Intel or AMD) for ``sander`` MM evaluation and NBO analysis
* **RAM**: 64–128 GB system RAM (TeraChem and NBO both make heavy use of system memory)
* **Storage**: Fast NVMe SSD recommended — QM/MM SMD runs generate large numbers of small files
  (TeraChem scratch, NBO ``.47`` files, AMBER restart files) and I/O speed matters

Cloud-based GPU instances (e.g., AWS p3/p4, Google Cloud A100 nodes) can also be used, but
consumer-grade gaming GPUs remain the most cost-effective option for research groups running
TeraChem at this scale.
