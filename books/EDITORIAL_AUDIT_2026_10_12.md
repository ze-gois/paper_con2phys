# Editorial and mathematical audit — 2026-10-12

**Scope:** first pass over the October expansion committed as `8a5d5e4` to
`feat/lean-formal-inventory-pilot`. The review samples added passages in
electrophysiology (biophysics, filters, causality) and foundations (integers,
logic). This is **not** a proof-by-proof validation of every new claim.

## Corrections applied

- **GHK current exercise** (`05b_biophysics_inverse.tex`): the
  equal-concentration formula is exactly linear in voltage in this
  constant-field model, with reversal potential zero, but the unqualified
  phrase "reduces to Ohm's law with constant conductance when concentrations
  agree" obscured the special assumptions. The exercise now asks for the
  analytic limit and explicitly distinguishes other concentration regimes.
- **GCV denominator** (same chapter): make the scalar square of the
  trace explicit: `[\\tr(I-A_\\lambda)]^2`. This is not generally
  `\\tr((I-A_\\lambda)^2)`, a different expression.
- **Greatest common divisor** (`02_integers.tex`): specify
  *nonnegative* gcd for integer arguments, avoiding ambiguity with
  negative common divisors.

## Items requiring a deeper technical check

1. **Line-source LFP forward equation**: check sign conventions,
   coordinate definitions, distance geometry and normalization against a
   reference derivation; the current description of `h` and `l` deserves
   a diagram and numerical limiting-case test.
2. **Cable frequency attenuation**: verify the specified
   frequency-dependent length constant and its dimensions with a
   compartmental/cable calculation.
3. **Spectral factorization**: add explicit positivity/minimum-phase
   assumptions for the Kolmogorov--Szegő and Wilson discussions; the
   AR(1) example alone does not justify an unrestricted multivariate
   factorization.
4. **Logic chapter correspondence**: its English source changed in the
   expansion; the five existing registry fingerprints should *not* be
   refreshed without rechecking the exact theorem statements and the
   side-by-side pedagogical proofs.
5. **LaTeX/Lean source boundaries**: `.lake/` build artifacts and Git
   gitlinks were accidentally tracked again. Restore a clean Git index
   before merging; retain `lake-manifest.json`.

## Verification status

The expanded books compiled successfully in GitHub Actions, but formal
CI failed at the editorial fingerprint audit because five English logic
sources changed. Compilation demonstrates syntactic integrity only; it
does not establish correctness of the expanded derivations. Existing
Lean proofs should be rechecked independently before renewing evidence.
