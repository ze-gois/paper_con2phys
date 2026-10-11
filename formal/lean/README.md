# CON²PHYS Lean 4 formal mathematics

Pinned Lean: `leanprover/lean4:v4.34.0`.
Pinned Mathlib: `5ed2965256430c3649e86755f9576b54eca72435` (Mathlib v4.34.0).

```sh
cd formal/lean
lake update
lake exe cache get
lake build
lake env lean Con2physFormal/Logic.lean
```

The pilot corresponds to the **logic chapter** of `books/formal_foundations`.
It contains five declarations for De Morgan laws, contraposition and quantifier
negation. Check the `Formal Lean` GitHub workflow for the actual kernel-check
result before describing any particular declaration as verified.

`#print axioms` reports underlying axiomatic assumptions; these are
different from source imports and tactics. The proof scripts contain no
`sorry`, `admit` or new `axiom` declarations.

All other results are pending a matching formalization. The automated
inventory is intentionally a *syntactic first pass* and does not claim to
identify every implicit theorem in ordinary text.

Mathlib source and proofs are licensed under Apache-2.0; see
https://github.com/leanprover-community/mathlib4/blob/v4.34.0/LICENSE .
The proof scripts written in this repository are original and do not
copy Mathlib proof implementations.
