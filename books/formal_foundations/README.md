# Formal Foundations — from ordinary language to neuroscience

This is the mathematics manuscript (112 pages when migrated; **176 pages** after the October 2026 expansion), formerly `latex/foundations/main.tex`, containing the original foundational chapters, 48 bridging lemmas, appendices, and exercises.

The mathematical exposition remains in LaTeX. The first five logic results now have **kernel-verified Lean 4 proofs**, displayed directly beside the English explanation in [the logic chapter](chapters/00_language/02_logic.tex). The remaining results are pending formalization. The pinned [Lean project](../../formal/lean), [verification registry](../../mathematics/formal_registry.json), and [full-source inventory audit](../../mathematics/audit_formal.py) distinguish implemented proofs from pending mathematical claims.

The October 2026 expansion adds new sections to all 34 chapters (each marked in the source by `% --- expanded edition (October 2026) ---`): definitions, propositions with complete proofs, second worked examples, and extra exercises. These include the algebra of sets, the equivalence-relation/partition theorem, Cantor's theorem, well-definedness of the integer and rational constructions, completeness consequences, limit laws, Bolzano--Weierstrass, mean value and Taylor theorems, the spectral theorem and SVD, the pseudoinverse and Tikhonov filter factors, probability axioms and inequalities, laws of large numbers, DFT inversion, periodogram statistics, Hilbert/PAC estimator bias, coherence under common input, quasistatic field theory, point-process constructions, GLM concavity, linear Fisher information, Kalman filtering, multiple comparisons, and floating-point error analysis. None of the new results are formalized in Lean; they count as pending in the formal registry.

Build: `make -C books formal_foundations`; PDF: `books/formal_foundations/build/main.pdf`.

See also [MATLAB-oriented volume](../electrophysiology/README.md), [book index](../README.md), and [theorem registry](../../mathematics/theorems.yml).
