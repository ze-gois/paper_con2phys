# Mathematical Foundations revision: gap-analysis response

Source: *Gap Analysis: Mathematical Foundations of Computational Electrophysiology*, 4-page editorial review supplied October 2026.

This is a **substantial first corrective revision**, not a claim to have closed every gap in that review. The existing 92 numbered catalogue results remain part of the original text; 11 dedicated foundational chapters are inserted at prerequisite-appropriate locations. Short proofs and counterexamples are included.

| Reviewer priority | New chapter | Addressed | Remaining depth |
|---|---|---|---|
| 1. Field generation / inverse problems | `05b_biophysics_inverse.tex` | Nernst, cable/HH orientation, quasistatic conduction, Poisson boundary uniqueness, Green/point-source, source nonuniqueness and Tikhonov | Full HH derivation, GHK permeability inversion, anisotropic FEM, Helmholtz decompositions, complete Picard and compact operator proofs |
| 2. Digital filtering / Poisson summation | `05a_filtering_sampling.tex` | Aliasing sum, Z transform, BIBO poles, FIR/IIR, group delay, filtfilt boundaries | Detailed filter design and pole/zero root-locus proofs |
| 3. GLM / optimization | `06a_glm_optimization.tex` | Poisson exponential family, Hessian concavity, IRLS/Fisher scoring, Jensen ELBO/EM, ALS caveat | Nonlinear-ICA theorem and full restricted-eigenvalue compressed sensing |
| 4. Point-process spectrum / renewal | `06b_spike_renewal_spectra.tex` | Bernoulli-to-Poisson/Le Cam, renewal CV2 asymptotic, Bartlett spectrum, LFP shot noise, Hawkes stability | Full renewal central-limit proof and Rényi characterization |
| 5. BBP, geometry and identifiability | `07a_population_geometry.tex` | Spiked covariance detectability, shrinkage distinction, rotational/similarity ambiguity, Procrustes SVD, CCA | CKA/RSA estimator properties; nonlinear ICA assumptions |
| 6. Dependent/selective inference | `07b_dependence_causality.tex`, `07d_robust_numerical_inference.tex` | Exact dependent mean variance, HAC, block bootstrap conditions, Holm/BY/max statistic, selection caveat; DKW, robustness, information bias | Full asymptotic CLT proofs under mixing; cluster topology and DKW full proof |
| 7. Causal identification and spectral Granger | `07b_dependence_causality.tex` | DAG/backdoor, intervention formula, confounding, Gaussian TE/Granger identity, spectral factorization prerequisite | Wilson factorization proof, full spectral Granger implementation |
| 8. Oscillators and stochastic dynamics | `07c_dynamics_oscillators.tex` | Hopf normal form, PRC, jPCA skew blocks, Itô, OU, Fokker–Planck | Center manifold proof, Kuramoto/Arnold tongues, reach/persistent homology |

**Cross-cutting:** `02b_measure_probability.tex` introduces sigma-algebras, measures, conditional expectation, weak stationarity, predictability; `04b_gaussian_toolkit.tex` introduces Gaussian conditioning, Wishart, Stein and Gaussian KL; `05c_wavelets_spectral_inference.tex` adds periodogram statistics, admissibility, PLV/PPC and surrogates; `07d_robust_numerical_inference.tex` also explains median/MAD, entropy bias and conditioning.

## Editorial corrections

- Retain elementary Cantor/number-system ideas because the separate *From Ordinary Language* volume explicitly aims to teach mathematics from its foundations; they are not substitutes for the newly introduced Gaussian toolkit.
- Relocate and retitle the former `08_foundational_nine.tex`: it is now treated as a subject chapter, not a revision-history addendum. Its 11 formal theorem statements remain intact (despite the historical filename).
- Explain Jensen through the ELBO and connect KL to PAC rather than asserting that the participation ratio follows from Jensen.
- Correct the spectral-localization description under Paley–Wiener, and include a pointer to the stronger finite-support result by Benedicks.
- Eliminate the catalogue's reference to nonexistent “Gaussian KL theory”; the actual Gaussian KL formula now appears in the Gaussian toolkit.
- Add explicit physical and inferential cautions to the source-to-arsenal crosswalk.

## Validation

The 11 new modules independently compile with pdflatex using the theorem catalogue's environments (22 A4 pages of new material). The entire integrated repository should additionally be compiled via `make -C latex all` and inspected for overfull boxes and PDF bookmarks. Do not claim a full integrated PDF build passed until a GitHub Actions run or a local fresh checkout confirms it.

Nothing in this revision changes MATLAB implementations or claims scientific validation of the exploratory arsenal.
## Follow-up expansion (October 2026)

A second pass appended proofs, derivations, examples and exercises to every chapter. Several items from the "Remaining depth" column now have text in the book. Each is marked below with how far it goes.

| Remaining-depth item | Where | Coverage |
|---|---|---|
| Full HH derivation, GHK permeability inversion | `05b_biophysics_inverse.tex` | Full HH system, GHK current and voltage equations with worked resting potential, identifiability of permeability ratios (exercise) |
| Complete Picard condition | `05b_biophysics_inverse.tex` | Discrete Picard condition, Picard plots, discrepancy/L-curve/GCV parameter choice |
| Filter design detail | `05a_filtering_sampling.tex` | Linear-phase FIR proof, Butterworth and bilinear transform with pre-warping, notch filters, causal zero-phase impossibility |
| Full renewal CLT, Rényi characterization | `06b_spike_renewal_spectra.tex` | CLT proof sketch via the ordinary CLT; Rényi stated with a void-probability diagnostic; Hawkes mean rate and spectrum |
| CKA/RSA estimator properties | `07a_population_geometry.tex` | CCA as an SVD (proof), reduced-rank regression (proof sketch), CKA invariances, BBP worked example |
| Wilson factorization | `07b_dependence_causality.tex` | Minimum-phase factorization, Kolmogorov--Szegő with AR(1) proof, description of Wilson's algorithm (no implementation) |
| Center manifold, Kuramoto/Arnold tongues | `07c_dynamics_oscillators.tex` | Center manifold theorem stated, Adler locking with drift frequency, Kuramoto critical coupling |
| DKW full proof | `07d_robust_numerical_inference.tex` | DKW confidence bands applied; full proof still not given |

Still open: full proofs of DKW, BBP and the center manifold theorem; asymptotic CLTs under mixing; nonlinear ICA; restricted-eigenvalue compressed sensing; anisotropic FEM. None of the new material has been checked by a MATLAB run or formalized in Lean.
