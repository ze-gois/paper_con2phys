# Books moved to neuronal

Both manuscripts and their editorial tooling now belong to
[ze-gois/neuronal](https://github.com/ze-gois/neuronal/tree/main/books):

- [Computational Electrophysiology](https://github.com/ze-gois/neuronal/tree/main/books/electrophysiology) — MATLAB examples.
- [Formal Foundations](https://github.com/ze-gois/neuronal/tree/main/books/formal_foundations) — Lean 4/Mathlib proofs.

Build both in the neuronal checkout with `make -C books all`.
The migration imports the newer manuscript work from commit
`97e1375116ab9281457f0fc74cdf045a863b58b0` on
`feat/lean-formal-inventory-pilot`, not only the older books on main.
History remains accessible in this repository. Continue editorial changes in neuronal.

The questionnaire scripts, `path/`, references and questionnaire tests remain
here. Reusable methods moved from `arsenal/` to `neuronal/matlab/`;
`a00_startup` loads the sibling neuronal checkout or `NEURONAL_ROOT`.
