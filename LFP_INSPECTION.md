# Visual LFP inspection

Run a01_probing once to obtain data. Then run:

```matlab
fig = lfp_inspector(data);
```

The inspector uses data.srate and data.lfp_1, data.lfp_2, data.lfp_3.
Select an area, enter three channel numbers separated by spaces, and choose
a window duration in seconds (up to 60). The slider updates on release.
Buttons and left/right arrows move half a window; arrows are ignored while
an edit field has focus. Close the figure when done to release its callbacks.

Each of the three line objects contains only the requested window. At
500 Hz, the default 10-second window uses 5,000 samples per line.
Time is assumed to start at zero at the first sample. Original amplitudes
are preserved, with automatic vertical scaling per channel/window. This
scaling is for inspection and must not be used to compare amplitudes by eye
without checking axis values. There is no filtering or decimation.

The input arrays are already in RAM: this is bounded graphics allocation,
not disk streaming. MATLAB's copy-on-write avoids an eager second copy of
unchanged inputs, but the figure keeps its input alive until closed. A
future matfile reader would need suitable MAT storage (v7.3) and would be
a separate loading path.

Implementation targets classic figure/uicontrol APIs and MATLAB R2019a,
without toolboxes. It has not been executed in MATLAB in the development
environment; validate interactively using the first/last slider position,
different areas/channel counts, short windows, and a recording shorter
than the requested window.
