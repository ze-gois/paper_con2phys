# From Ordinary Language to Computational Neuroscience

**Expanded bridge edition:** 112 A4 pages, 40 chapters in 8 parts, plus three formal appendices. This edition extends the original 92-page / 34-chapter manuscript with **48 proved bridges in six supplementary chapters**. Each new bridge includes a formal statement, proof, and example grounded in computational electrophysiology. The original 34 chapters remain in their existing locations.

## How to build

From the repository root:

```sh
make -C latex foundations
```

Or from `latex/foundations/`:

```sh
make pdf
```

Output: `latex/foundations/build/main.pdf` (the checked 112-page local build). `pdflatex` is required; the Foundations volume uses its own typeset bibliography rather than invoking BibTeX.

## Reading order

Start at `main.tex`. The six bridge chapters are interleaved after the relevant portions of the foundational text: mathematical language; number systems; calculus; linear algebra; probability; and spectral analysis. See [`bridges/README.md`](bridges/README.md) for the 48-result index and suggested study method.

The separate theorem-driven research catalogue remains at [`../main.tex`](../main.tex). Do not merge the two masters into one preamble. The mathematical catalogue has different scope and includes advanced theorems that need not be mastered to read this volume.

## Links to the real arsenal

- Existing MATLAB functions: [`../../arsenal/path/`](../../arsenal/path/)
- Method-by-method implementation status: [`../../arsenal/METHODS.tsv`](../../arsenal/METHODS.tsv)
- Updated theorem/function crosswalk: [`../chapters/10_arsenal_crosswalk.tex`](../chapters/10_arsenal_crosswalk.tex)
- Historical provenance and limitations of the older appendix: [`INTEGRATION.md`](INTEGRATION.md)

The mathematical validity of a derivation does **not** validate an empirical neurophysiological inference. Treat the MATLAB arsenal as exploratory unless independently validated for the particular task.