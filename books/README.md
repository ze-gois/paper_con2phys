# CON²PHYS books

Two books, two different kinds of mathematical evidence:

| Book | Entry point | Intended role | Current state |
|---|---|---|---|
| [Computational Electrophysiology](electrophysiology/main.tex) | `books/electrophysiology/main.tex` | MATLAB-linked methods, simulations, and scientific interpretation | Existing theorem/method manuscript migrated intact; MATLAB executable examples still need expansion |
| [Formal Foundations](formal_foundations/main.tex) | `books/formal_foundations/main.tex` | Mathematics from ordinary language, eventually checked in Lean 4 / Mathlib | Existing 112-page introductory manuscript migrated intact; Lean formalizations are **not** yet present |

No theorem is called formally proved by software unless it builds with Lean. Neither a MATLAB numerical test nor a TeX proof constitutes a machine-checked theorem.

## Build

From repository root:

```sh
make -C books check
make -C books all
make -C books electrophysiology
make -C books formal_foundations
```

Outputs: `books/electrophysiology/build/main.pdf` and `books/formal_foundations/build/main.pdf`.

The legacy commands `make -C latex all`, `make -C latex theorems`, and `make -C latex foundations` forward to these targets for compatibility.

## Shared registry and code paths

- [mathematics/theorems.yml](../mathematics/theorems.yml) is a seed registry for stable theorem identifiers; it does not claim all catalogue entries are formally proved.
- [arsenal/path](../arsenal/path) and [path](../path) retain the MATLAB method libraries.
- [formal/lean](../formal/lean) is reserved for a future Lake/Mathlib project and is deliberately not presented as implemented.
- [examples/matlab](../examples/matlab) is the designated place for future reproducible textbook demonstrations.
- [examples/lean](../examples/lean) is reserved for future verified examples.

The original editorial text is preserved in each migrated book. Some historical mentions of `latex/` or provisional method maps remain as provenance, not canonical build paths. 
