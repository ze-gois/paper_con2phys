# CON²PHYS mathematical library

Two complementary **standalone** LaTeX books are maintained in this folder.

## Volume I: From Ordinary Language to Computational Neuroscience

- **Source:** [foundations/main.tex](foundations/main.tex)
- **Contents:** 34 original chapters in 8 numbered parts, three formal appendices, an introductory reader guide, and an embedded bibliography.
- **Pedagogy:** ordinary English, logic, proof, sets, relations, functions, number systems, analysis, algebra, statistics, stochastic processes, electrophysiology, and neural population methods.
- **Build:** `make -C latex foundations` from the repository root; output is `latex/foundations/build/main.pdf`.
- **Provenance:** imported as an intact, previously compiled source edition; its preface and arsenal-map appendix explicitly reflect the earlier provisional status of method matching. See [foundations/INTEGRATION.md](foundations/INTEGRATION.md) for verified repository context.

The original supplied source edition was independently compiled into **92 A4 pages**. The former shorthand '9 parts' was inaccurate: the LaTeX master explicitly contains **8** `\\part` commands.

## Volume II: Mathematical theorems for computational electrophysiology

- **Source:** [main.tex](main.tex) (at `latex/main.tex`).
- **Contents:** 92 numbered theorem/principle/identity entries, nine additional theorem families from the original inventory, derivations, exercises, and an actual-file crosswalk to MATLAB `arsenal/path`.
- **Build:** `make -C latex theorems`; output `latex/build/main.pdf`. Requires `pdflatex` and `bibtex`.

## Commands

```sh
make -C latex foundations   # Volume I; pdflatex only
make -C latex theorems      # Volume II; pdflatex + bibtex
make -C latex all           # Both volumes
make -C latex clean         # Remove both build directories
```

Both manuscripts have independent preambles and namespaces. Do **not** blindly `\\input` one master book into the other. Mathematical results must state hypotheses, and no analytical function is automatically validated for scientific inference.

For implementation statuses, use [../arsenal/METHODS.tsv](../arsenal/METHODS.tsv) and [../arsenal/README.md](../arsenal/README.md).
