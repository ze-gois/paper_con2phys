# CON²EPHYS Mathematics — foundational edition

An original, modular English-language textbook whose path runs from ordinary mathematical language to advanced computational neuroscience: logic, sets, relations, functions, number systems, analysis, linear algebra, probability, signal processing, spike trains, and population dynamics.

The source tree is designed to live at `paper_con2ephys/latex/`, alongside `arsenal/path/`.

## Build

```sh
cd latex
latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex
# or, without latexmk:
# pdflatex main.tex && pdflatex main.tex && pdflatex main.tex
```

Outputs: `main.pdf`. Chapters live in numbered subdirectories under `chapters/`. The `appendices/` directory supplies an instructional guide, notation, an explicitly *provisional* method-to-math map, and exercises. The maintained source reference ledger is `references.bib`; the compiled bibliography is `appendices/bibliography.tex` so the project does not require a local BibTeX executable.

## Editorial principles

1. Begin with an English sentence and define the mathematical language before using it.
2. Move from examples to definitions to derivations and proofs; do not merely list methods.
3. State all hypotheses, constraints, units, and null models.
4. Make a distinction between numerical implementation, statistical inference, and physiological interpretation.
5. Put exercises and counterexamples near each mathematical concept.
6. Keep source material original. Halmos and Mendelson are pedagogical inspirations, not text to reproduce.
7. Until GitHub access is available, method names in the arsenal map are *families*, not verified MATLAB file names.

## Repository status

The GitHub connector did not locate `paper_con2ephys`; no remote changes are claimed. The former Portuguese 2026-10-11 source is retained under `legacy/2026-10-11-portuguese/`, and is not included in the new compiled book. Build artifacts and auxiliary files are excluded from release bundles.