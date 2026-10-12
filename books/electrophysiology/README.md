# Computational Electrophysiology — MATLAB-linked textbook

This is the theorem-and-analysis manuscript, formerly `latex/main.tex` (61 pages when migrated; **98 pages** after the October 2026 expansion). It contains the mathematical catalogue, biophysical modeling, spectral estimation, GLMs, point processes, dynamics, and an [arsenal function crosswalk](chapters/10_arsenal_crosswalk.tex).

It is currently primarily a methodological/theorem textbook: the next editorial phase will add executable MATLAB examples tied to source files in [../../arsenal/path](../../arsenal/path) and to the existing question scripts at repository root.

The October 2026 expansion appends to every chapter a section of proofs and derivations for its catalogue results (e.g. Gauss--Markov, Schur/Woodbury, Weyl, Cramér--Rao, Hölder/Minkowski, Banach and Picard--Lindelöf, Gronwall, Holm, Gibbs and data processing, time rescaling), worked examples, and chapter exercises. It also adds material on the "remaining depth" items listed in [REVISION_2026_10_GAP_ANALYSIS.md](REVISION_2026_10_GAP_ANALYSIS.md). No new MATLAB listings were added; the numerical examples are stated in prose and still need executable `.m` counterparts.

Build: `make -C books electrophysiology`; PDF: `books/electrophysiology/build/main.pdf`.

Related: [Formal Foundations](../formal_foundations/README.md), [book index](../README.md), [shared registry](../../mathematics/theorems.yml).
