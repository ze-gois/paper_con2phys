# From Ordinary Language to Computational Neuroscience

Original 92-page foundational edition of the CON²PHYS mathematics textbook.

This modular manuscript was developed independently as a pedagogical progression from **ordinary English** through **logic, sets, relations, functions, number systems, analysis, linear algebra, probability, signals, spike trains, neural populations, and inference**.

The book has **34 chapters, 8 parts and 3 formal appendices**. A reader guide and bibliography are also included. The book is original instructional writing inspired by Halmos and Mendelson; it does not reproduce either source.

## Build

From the repository root:

```sh
make -C latex foundations
```

Or directly:

```sh
make -C latex/foundations pdf
```

Output: `latex/foundations/build/main.pdf`.

This volume does not require BibTeX to compile: it uses a maintained `references.bib` ledger and a self-contained `appendices/bibliography.tex` for typesetting.

## Research linkage

- Current MATLAB code: [../../arsenal/path](../../arsenal/path)
- Current implementation statuses: [../../arsenal/METHODS.tsv](../../arsenal/METHODS.tsv)
- Detailed mathematical theorem catalogue: [../main.tex](../main.tex)
- Existing-function crosswalk: [../chapters/10_arsenal_crosswalk.tex](../chapters/10_arsenal_crosswalk.tex)
- Provenance and integration notes: [INTEGRATION.md](INTEGRATION.md)

The existing chapter text and its period-specific statements were preserved on import. The master source is the same edition that independently compiled to **92 A4 pages**.
