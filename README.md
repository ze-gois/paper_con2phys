# paper_con2phys

MATLAB scripts analyzing the CON²PHYS questionnaire. Run from this directory.
The existing `a`, `b`, `c`, and `d` scripts remain the loading/exploration pipeline.

## Questionnaire analyses: q01–q15

Run `a01_probing` to load one animal, then any question script. Each question
calls the **script** `q00_prepare` and leaves a result named `q01`, …, `q15`.
No question reloads or modifies `data`, generates a figure, or writes files.
Local functions implement the calculations; there is no package or class API.
MATLAB R2019a or newer and Signal Processing Toolbox are required. No Statistics
and Machine Learning Toolbox is required.

```matlab
a01_probing
q01_firing_rate
q02_broadband_power
q01.summary
q02.summary
% Save the small result structures, not the multi-GB data workspace:
save('animal01_questionnaire.mat','q01','q02')
```

`a01_probing` now retains source paths and resolves trial column names from the
spreadsheet headers. Existing numeric fields and their shapes are unchanged.
For an already loaded `data`, set the column map **after checking the actual
spreadsheet**. The eight-column shape alone does not reveal its semantics.

```matlab
% EXAMPLE ONLY: use these indices only if your headers confirm them.
qcfg.trial_columns = struct('trial_start',2,'stim_start',3, ...
    'outcome',4,'trial_end',5,'A',6,'C',8);
q10_intrinsic_timescale
q11_variable_a_information
q12_variable_c_decoding
q13_dimensionality
q14_modularity
q15_signal_complexity
```

The trial-based scripts stop on an unresolved map. They exclude nonfinite,
nonpositive, out-of-recording and overlapping trial intervals. Intervals use
`[start,end)` throughout. Spikes are seconds; LFP time starts at zero and exposure
is `number_of_samples / data.srate`. Waveforms use **30 kHz**, not LFP sampling.
Cluster IDs are explicitly mapped to waveform rows; unmatched or out-of-range
spikes are counted in provenance. Silent mapped units remain in Q1.

| Script | Operational question / estimate | Resampling unit |
|---|---|---|
| `q01_firing_rate` | Lowest mean single-unit firing rate | Units |
| `q02_broadband_power` | Highest channel-averaged integrated 1–100 Hz Welch power | 30 s blocks |
| `q03_ripple_density` | Highest candidate 120–200 Hz event rate; channel-union detector | 30 s blocks |
| `q04_spike_interactions` | Strongest mean absolute pairwise 100 ms spike-count correlation | 30 s blocks |
| `q05_undirected_connectivity` | Strongest absolute inter-area population-count correlation | 30 s blocks |
| `q06_directed_connectivity` | Conditional VAR log residual-variance ratio for 1→2, 3→2, 3→1 | 30 s blocks |
| `q07_fast_spiking` | Largest narrow-waveform fraction among classifiable recorded units | Units |
| `q08_phase_locking` | Largest 4–10 Hz spike–LFP pairwise phase consistency | Units |
| `q09_excitation_inhibition` | Broad/narrow waveform count ratio, **not physiological E/I** | Units |
| `q10_intrinsic_timescale` | Shortest accepted exponential baseline correlation decay | Units |
| `q11_variable_a_information` | Most whole-trial held-out decoded information about A | Held-out trials |
| `q12_variable_c_decoding` | Highest C balanced accuracy among the three trial segments | Class-stratified held-out trials |
| `q13_dimensionality` | Highest stimulus-to-outcome covariance participation ratio | Trials + matched unit subsets |
| `q14_modularity` | Lowest mean blockwise positive weighted graph modularity | 30 s blocks |
| `q15_signal_complexity` | Highest stimulus-to-end LFP permutation entropy | Trials |

## Choices and interpretation

Results include `summary`, `units`, `method`, `config`, and `provenance`, plus
question-specific intermediate outputs. Q1–8, Q10, Q14–15 tables report finite
resampling-unit counts (`n`); other tables retain their appropriate diagnostics.
NaN means unavailable, excluded, or not estimable: it never silently becomes zero.
Intervals are percentile bootstrap estimates with a deterministic local random
stream. These are **within-recording descriptive intervals**, not population
confidence intervals across the 18 animals. Channels, units and time blocks can
remain dependent; resampling does not magically remove this dependence.

Default parameters are assigned only if missing from `qcfg`; inspect or override
before running. Defaults: seed 42, 1000 bootstrap draws, 30 s blocks, 5 matched
units for Q11/Q13/Q14 (reduced to the smallest available area), waveform width
threshold 0.4 ms, at least 50 spikes for PPC, and LFP channel 1 in each area for
Q8. Local random streams do not change the caller's random state. Change
`qcfg.lfp_channels` to assess phase-reference sensitivity. Rerun scripts after
switching animals; old `qNN` results in the workspace are not automatically cleared.

- **Q2:** original amplitude units are unspecified; power is reported in original
  units squared, never assumed to be µV². Nonfinite or flat channel blocks are
  excluded. Incomplete terminal blocks are omitted.
- **Q3:** robust envelope thresholds (2 onset, 5 peak), 25–150 ms duration and
  20 ms merging across channels define a candidate screen. Filtering uses 2 s
  padding; boundary-touching detections are rejected. No sharp-wave validation,
  behavioral state classification or artifact adjudication is inferred. More
  channels can increase detections. Review events before claiming SWRs.
- **Q4/Q5:** absolute correlation defines “strongest”; Q4 also retains signed
  block means. Shared task drive is not removed. Q5 population averaging is
  sensitive to unequal unit counts.
- **Q6:** fixed five-lag VAR on 20 ms population counts (100 ms history), with
  the third area retained as a conditioning variable. Linear detrending occurs
  per block. In-sample Granger scores have positive bias and need model-order,
  stationarity, residual and surrogate checks before scientific interpretation.
- **Q7/Q9:** negative trough to subsequent positive peak; invalid waveforms
  remain unclassified. Narrow does not prove inhibitory identity. Q9 zero
  inhibitory denominator gives an unavailable point estimate; infinite bootstrap
  upper limits are retained rather than discarded. The physiological E/I question
  is explicitly left unresolved.
- **Q8:** fixed reference channel; two-second recording edges excluded; complex
  analytic signal interpolated to spike times. PPC reduces spike-count bias,
  but spike dependence and reference-channel sensitivity remain.
- **Q10:** one second immediately before trial onset, wholly outside other
  trials, is the baseline definition. Correlations are computed across trials
  at pairs of 50 ms positions, never across concatenated trial boundaries.
  At least 20 trials and six finite lags are required. Fit A exp(-lag/tau)+C;
  accept positive A, tau 25–1000 ms and R²≥0.5. Inspect rejected fits and selection bias.
- **Q11/Q12:** fixed ridge one-vs-rest classifier, contiguous five-fold testing,
  training-only standardization and no hyperparameter search. Q11 uses whole
  trial mean rates (no ITIs) and matched unit counts. Its confusion-matrix MI
  measures decoded information, not full neural information. Q12 pools all
  units with the same valid trials/folds for all segments. Both retain 100
  circular-label-shift null fits. Bootstrap intervals condition on already-fitted
  models; do not interpret them as full training uncertainty. Inspect temporal
  drift, null distributions, class coverage, and duration-matched sensitivity.
- **Q13:** raw count covariance, 100 ms bins wholly inside stimulus-to-outcome;
  partial final bins are dropped. Point estimate averages 100 matched-unit
  subsets; bootstrap resamples whole trials and unit subsets. High-variance
  neurons dominate raw covariance; PR is not a latent-factor model.
- **Q14:** matched fixed unit subset, positive edges only, resolution one,
  greedy community merging. All complete blocks contribute; blocks with silent
  selected nodes are excluded. This estimates mean local modularity across the
  recording, not a single static whole-recording graph. Compare graph-size and
  null-network sensitivity; greedy optimization is not guaranteed global.
- **Q15:** linearly detrended LFP, order-three ordinal patterns at 10 ms delay,
  tied patterns excluded, at least 100 patterns, entropy normalized by log(6).
  Channels are averaged within each trial before bootstrap. No extra spectral
  filter is applied. Noise can raise entropy; this is one operational complexity
  measure, not evidence of richer computation.

For questionnaire submission, run all animals, retain each animal's estimates,
then compare **paired animal-level** differences with an explicitly chosen
multiple-comparison procedure. Do not choose a categorical answer by ranking
one recording's means or by comparing overlapping marginal CIs. This revision
implements single-recording analyses and does not claim numerical cohort answers.
Q9 remains a proxy even after aggregation. Section 2 confidence/experience ratings
must come from the participant, not be generated from these scripts.

## Validation

`tests/smoke_questionnaire.m` creates a deterministic synthetic recording and
runs all 15 scripts, checking known firing rates, sinusoidal band power, waveform
fractions, count ratios, and bounded metrics. Run in a **fresh MATLAB session**:

```matlab
run('tests/smoke_questionnaire.m')
```

This revision was parsed with the tree-sitter MATLAB grammar and checked with
`git diff --check`. MATLAB and the recordings were unavailable in the authoring
environment: the synthetic test and real-data numerical analyses have **not**
been executed there. Passing a parser is not a numerical validation.

## Sources

- [Repository questionnaire](questionnaire/questionnaire.pdf), scientific questions Q1–Q15.
- [Official dataset structure](https://mchini.github.io/con2phys/data_structure.html)
  for timestamp units, waveform sampling and row alignment.
- [Participation/data version](https://mchini.github.io/con2phys/how_to_participate.html):
  verify dataset v1.1; mouse 12 LFP was corrected on 15 July 2026.
