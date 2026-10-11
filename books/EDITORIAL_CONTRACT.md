# Two-book source inclusion contract

**Electrophysiology = MATLAB.** Mathematical modeling, scientific assumptions,
numerical implementations and figures are explained in English and supported
by executable `.m` files. Chapters include these with `\\lstinputlisting`.
A MATLAB listing is *not* a proof of numerical correctness.

**Formal Foundations = Lean 4/Mathlib.** Natural-language definitions, theorem
statements and proofs appear alongside imported `.lean` files using
`\\lstinputlisting`. Statements may only be called machine-verified when
the pinned Lake project passes the Lean kernel and the registry records
verification evidence.

Rules:
- Never embed Lean source in the electrophysiology volume.
- Never embed MATLAB source in the formal-foundations volume.
- Cross-volume concepts are linked by theorem IDs, not copied source text.
- Preserve both volumes' prose and their separate PDF targets.
- Neither build requires executing the other book's programming language.
- Generated figures belong to the MATLAB scientific workflow, rather than
  being prerequisites for the mathematical proof book.

Run `python3 books/tools/check_language_boundaries.py` to validate inclusions.
