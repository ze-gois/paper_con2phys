# Import provenance and theorems companion

This directory contains the **complete source edition** of *From Ordinary Language to Computational Neuroscience*, previously delivered as `con2ephys_latex_foundations_v2.zip` and independently compiled as a 92-page A4 PDF.

The import preserves all **34 chapter .tex files**, the original `main.tex`, the five appendix/support .tex files, the original BibTeX file, and build metadata. The manuscript is kept in its own namespace because `latex/main.tex` already assembles the separate theorem-driven companion.

## Important historical distinction

The older preface, reader-guide material, and `appendices/arsenal_map_new.tex` describe the method map as **provisional** because the repository name was unknown when the book was written. This is retained intentionally as a record of the source edition. The verified GitHub repository is now **ze-gois/paper_con2phys**, and the implementation map with actual existing MATLAB filenames lives at `../chapters/10_arsenal_crosswalk.tex`.

Do not interpret an exploratory numerical primitive as a full implementation of a publication, nor as validated physiological inference. The living statuses remain `../../arsenal/METHODS.tsv` and `../../arsenal/README.md`.

## Future editorial work

A later revision may add forward cross-references from each original textbook chapter to the individual mathematical results in the theorem catalogue. That change should be reviewed separately rather than modifying the imported edition silently.
