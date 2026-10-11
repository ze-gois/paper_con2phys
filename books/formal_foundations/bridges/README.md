# Forty-eight mathematical bridges

These are **48 short, original, proved propositions or theorems**, added to the first textbook *From Ordinary Language to Computational Neuroscience*. Each contains a precise statement, a worked derivation or proof, and a neuroscience/data-analysis connection. They are not 48 newly discovered theorems. Their purpose is to eliminate implicit logical and algebraic steps in the reader's route to electrophysiology.

The six chapters are interleaved into `../main.tex` directly after the relevant original chapters, rather than placed in an appendix. Bridge labels use `\ref{bridge:...}`. The original 34 chapters remain intact, so the additional chapters bring the foundations manuscript to 40 chapters.

| Bridges | Source | Prerequisites |
|---|---|---|
| 1–8 | `01_language_relations.tex` | Logic, sets, ordered pairs, relations and functions |
| 9–16 | `02_numbers.tex` | Natural, integer, rational, real and complex systems |
| 17–26 | `03_analysis.tex` | Sequences, continuity, differentiation and integration |
| 27–34 | `04_linear_algebra.tex` | Vector spaces, operators and covariance |
| 35–42 | `05_probability.tex` | Events, random variables and conditional expectations |
| 43–48 | `06_discrete_signals.tex` | Finite sums, complex numbers and sampled signals |

## Recommended reading pattern

Read the original chapters leading to a bridge chapter; then reproduce each proof without looking at the text, translate its statement into ordinary English, and work through its neural-data example. Finally, test the result with a minimal MATLAB simulation. A computation that matches a theorem is not itself evidence for a physiological mechanism.

The separately maintained theorem catalogue at `../../main.tex` covers more advanced results (Wiener–Khinchin, Slepian concentration, GLMs, stochastic-process inference, observability, and manifold geometry). The two books have different roles: this first book builds **prerequisite fluency**; the catalogue provides an **advanced reference**.

## Caveats

- The proofs assume the indicated mathematical object classes. They do not establish stationarity, physiological connectivity, identifiability, or calibration of experimental measurements.
- Sampling and DFT results distinguish *finite sequences* from *continuous signals*.
- `arsenal/path/` files are exploratory functions with individual implementation status documented in `arsenal/METHODS.tsv`.

## Build

From repository root run `make -C latex foundations`, or from `latex/foundations/` run `make pdf`.