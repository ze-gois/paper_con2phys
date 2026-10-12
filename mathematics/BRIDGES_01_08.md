# Formalization review — bridges 1–8

Source: `books/formal_foundations/bridges/01_language_relations.tex`

The first eight bridges cover set extensionality, inclusion as partial
order, Cartesian product and empty factors, relation composition,
equivalence classes, function image/preimage, two-sided inverses and
countability of pairs of naturals.

The indexed inventory is `mathematics/bridge_inventory.json`.
Its `mathlib_candidates_unverified` entries are **search hints**, not
confirmed theorem identities at the pinned Mathlib revision.

Each bridge contains a source proposition and a natural-language proof.
Bridge 3 has a definitional membership statement plus two empty-product
claims; bridge 6 has three distinct preservation identities; bridge 5
requires choosing an explicit notion of partition. The relation in
bridge 4 must be oriented consistently when translated to Lean's
relation composition. Bridge 7 requires a function type for both
inverse directions and explicit left/right inverse equations.

Before moving an entry to verified: inspect the exact Mathlib
declaration and type under commit
`5ed2965256430c3649e86755f9576b54eca72435`, construct a Lean
statement equivalent to the manuscript, record imports and source
license, run the kernel and `#print axioms`, then link the English
proof and update the three graphs.

Do not treat these eight as already formalized; they are inventoried
and curated for the next verification milestone.
