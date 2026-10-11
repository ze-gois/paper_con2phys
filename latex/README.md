# CON²PHYS mathematical theorems

This modular LaTeX textbook progresses from ordinary English propositions to computational electrophysiology.

## Build

From the repository root: make -C latex pdf

Requires pdflatex and bibtex. Output: latex/build/main.pdf.

## Layout

- main.tex: book entry point
- preamble/: packages, theorem styles, notation
- chapters/01 through 07: 92 numbered mathematical results with hypotheses, formulae, and neural connections
- chapters/08_foundational_nine.tex: nine additional results from the initial inventory, with corrected limitations
- chapters/09_proofs.tex: selected complete proofs and derivations
- chapters/10_arsenal_crosswalk.tex: mapping to actual MATLAB functions
- chapters/11_exercises.tex: proof and computational exercises
- refs/references.bib: methodological reading references

## Editorial contract

1. Introduce symbols and hypotheses before their use.
2. Distinguish theorems, identities, axioms, criteria and model choices.
3. Explain counterexamples and failure modes.
4. Link only to functions actually present in arsenal/path.
5. A successful smoke test does not establish physiological validity.
6. Keep this in latex/; do not modify MATLAB implementations for documentation.
