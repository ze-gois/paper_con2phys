# Formal Foundations — from ordinary language to neuroscience

This is the migrated **112-page** mathematics manuscript, formerly `latex/foundations/main.tex`, containing the original foundational chapters, 48 bridging lemmas, appendices, and exercises.

The mathematical exposition remains in LaTeX. The first five logic results now have **kernel-verified Lean 4 proofs**, displayed directly beside the English explanation in [the logic chapter](chapters/00_language/02_logic.tex). The remaining results are pending formalization. The pinned [Lean project](../../formal/lean), [verification registry](../../mathematics/formal_registry.json), and [full-source inventory audit](../../mathematics/audit_formal.py) distinguish implemented proofs from pending mathematical claims.

Build: `make -C books formal_foundations`; PDF: `books/formal_foundations/build/main.pdf`.

See also [MATLAB-oriented volume](../electrophysiology/README.md), [book index](../README.md), and [theorem registry](../../mathematics/theorems.yml).
