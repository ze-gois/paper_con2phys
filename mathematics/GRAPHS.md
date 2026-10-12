# Three distinct proof and learning graphs

The project maintains **three noninterchangeable representations**:

1. **Kernel-reference graph**: machine-extracted constants occurring in Lean declaration types and elaborated terms. Generated from `formal/lean/Con2physFormal/DependencyGraph.lean` and bounded `TransitiveGraph.lean`; the bounded walk must **never** be described as a complete transitive closure.
2. **Mathematical prerequisite graph**: curated dependencies of the results as conventional mathematics. Stored in `mathematics/concept_dependencies.json`, field `math_prerequisites`.
3. **Pedagogical prerequisite graph**: the concepts a reader should study before a result, stored in field `pedagogical_prerequisites`.

The second and third graphs are **editorial annotations**, not consequences of the Lean kernel. Their edges can differ even when theorems match exactly.

Generate separate navigable JSON representations:
```sh
python3 mathematics/build_concept_graphs.py --check
python3 mathematics/build_concept_graphs.py --write
```

The initial curated corpus contains **only LOGIC-001 through LOGIC-005**.
Remaining bridges and hidden results require human statement-by-statement
audit and must not be silently populated with imagined dependencies.

Full Mathlib source is fetched through Lake under `formal/lean/.lake/packages/mathlib`, which must remain ignored by Git. Reference the exact pinned commit and record `#print axioms` separately from import/tactic dependencies.
