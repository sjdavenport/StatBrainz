# StatBrainz test report

Generated after creating `test_<fn>.m` scripts for every package function and running
each one under MATLAB R2024b (`/Applications/MATLAB_R2024b.app/bin/matlab -batch`), with
the package on the path via `addSB2path`. Each test was run in its own MATLAB process with
a 45 s wall-clock timeout.

A test "passes" if its example script runs to completion without error. These are
illustrative scripts (matching the existing convention), **not** assertion-based unit
tests — passing means "runs clean", not "output verified correct".

---

## Update — 2026-06-29: placeholder tests filled + reproducibility pass

Ten placeholder tests (TODO header + commented-out skeleton, no runnable body) were
given real, runnable bodies that pass headless. Inputs are synthetic where the function
is pure, or read from bundled data otherwise.

| Test | How filled |
|------|------------|
| `test_inverse_linear_template` | pure numeric inputs |
| `test_get_pivotal_stats` | random null-pval matrix + `@inverse_linear_template` handle (docstring says "string" but source calls it as a function); seeded |
| `test_bestclusterslice` | synthetic 3D cluster; **`slice_no` is a dim index (1/2/3)**, not a slice number |
| `test_voxLCE` | synthetic TFCE image; **H and h0 are mandatory** (no defaults despite docstring) |
| `test_expand2mask` | MNImask sub-image; **call `expand2mask`** (file name) — declared name `expand2MNI` is not dispatchable |
| `test_region_bndry2D` | two synthetic sub-volume regions of MNImask. NB: function hardcodes dim-3 slice 80, which is empty in the 91×109×91 mask, so output is 0 — function appears written for a different orientation/resolution |
| `test_srf_blue_crs` / `test_srf_redblue_crs` / `test_srf_color_crs` / `test_srf_scb2cope` | `loadsrf('fs4','white').lh` + synthetic per-vertex bands; output is `size()` (deterministic) |
| `test_fs2surf` | bundled `BrainImages/Surface/fs5.{lh,rh}.white` |
| `test_addSB2path` | run from repo root, confirm `loadsrf` on path |

**Still blocked (left as documented placeholders):**

- `test_gifti2surf` — `gifti2surf` calls the third-party `gifti` reader, not installed
  in this environment (bundled `.gii` files exist under `BrainImages/Gifti_files/`).

**Reproducibility:** ran the full suite once and diffed against the existing baseline.
Most diffs were just the new result-echoing lines (deterministic). The only output that
actually varied run-to-run via RNG was `test_get_pivotal_stats` (`min` of a random
matrix); `rng(0)` added there (and to `test_voxLCE`/`test_expand2mask` as belt-and-braces
where `rand`/`randn` feed the echoed value). `test_resample_srf` differs only in `toc`
timing lines — inherent, not seedable.

**Source name≠file mismatches surfaced here** (add to the list at the bottom):
`expand2mask.m` declares `expand2MNI`.

---

## Update — 2026-06-24: headless plotting run

Nine plotting tests were given an `exportgraphics(gcf, ...)` line so they save a PNG to
`Tests/Figures/` and can run headless (no frozen / interactive windows). Run under MATLAB
in `-batch` mode.

**Passed — 6 figures written to `Tests/Figures/`:**

| Test | Output |
|------|--------|
| `test_BigFont` | `BigFont.png` |
| `test_custom_colormap` | `custom_colormap.png` |
| `test_histpdf` | `histpdf.png` |
| `test_srf_colour` | `srf_colour.png` |
| `test_srf_contour` | `srf_contour.png` |
| `test_srfplot2` | `srfplot2.png` |

**Not captured — inherently interactive / animated (no static PNG produced):**

- `test_animatefun` — animation loop, no single steady frame
- `test_sliderGUI` — interactive slider GUI
- `test_slidergui3` — interactive slider GUI

These three run but do not yield a meaningful static export; they need a live session to
verify.

---

## Environment blockers (affect many tests, not fixable in the tests)

Two dependencies the package assumes are on the MATLAB path are **not installed in this
environment**. Tests that rely on them cannot pass here regardless of the test code.

1. **RFTtoolbox is not on the path.** The following functions are used throughout the
   docstring examples but do not exist in StatBrainz — they live in the author's companion
   RFTtoolbox: `wfield`, `convfield`, `fconv`, `Field`, `SpheroidSignal`, `contrast_tstats`.
   Installing RFTtoolbox (and adding it to the path) would unblock most of these.

2. **SPM is not installed** (`spm_vol` / `spm` absent). `imgsave` writes NIfTI via SPM, so
   any test that saves an image is blocked. (Note: `imgload` works for bundled images.)

---

## Tests fixed (test-side bugs corrected)

These failures were genuine problems in the test scripts (bad example code copied from
docstrings, or scaffolding bugs), and have been corrected. Examples were kept faithful to
the original intent; only the broken parts were changed.

| Test | Problem | Fix |
|------|---------|-----|
| `test_mvtstat` | example used `noisegen` (missing) + undefined vars `mu`, `data` | `normrnd` noise of correct shape; fixed undefined vars |
| `test_mvtstat_dep` | same `noisegen` pattern | `normrnd` noise |
| `test_slidergui3` | called `sliderGUI3`; MATLAB dispatches on file name `slidergui3` | call `slidergui3` (+ note on source name/case mismatch) |
| `test_plotImagesInTile` | referenced `image1.png` … which don't exist | commented out, marked needs-real-images |
| `test_GkerMV` | example requested 3 outputs; `GkerMV` returns only `val` | reduced to single output (derivative calls removed) |
| `test_Gkerderiv` | called `GkerMVderiv` (missing) | commented that one comparison line |
| `test_peakgen` | 1D example marked "NEED TO IMPLEMENT" (errors) | commented the 1D cell (2nd cell still blocked, see below) |
| `test_gen_mask` | `imgload('MNImask')(:)'` — illegal chained indexing | split into two statements |
| `test_unwrap` | used `fconv` (missing) | `fast_conv` (in-repo equivalent) |
| `test_numOfConComps` | 2nd cell used `fconv` 2-output form | `fast_conv` (single output) |
| `test_getBrainRegionNames` | hardcoded Windows path to an XML | `statbrainz_maindir` + in-repo `Atlases/HarvardOxford/...xml` |
| `test_getregion` | `[35,62,23]*1.15` → non-integer array indices | `round(...)` |
| `test_srf_fwhm2niters` | passed lh/rh container; function wants one hemisphere | pass `srf.lh` |
| `test_imgsave` | machine-specific `global lobal`/`CSI` dirs | save to `tempdir` (still blocked by SPM, see below) |
| `test_Xgen2` | called `Xgen` (file is `Xgen2.m`); 5-arg + `armix`/`Gaussian` cells unsupported | call `Xgen2`; commented unsupported method cells |
| `test_imgload` | body called `pan3` (a buggy sibling), not `imgload` | exercise `imgload` directly + `imagesc` a slice |
| `test_viewdata` | input built with `wfield`/`convfield`/`get_mask` (missing) | drive `viewdata` with a bundled mask + `fast_conv(randn)` |

---

## Tests blocked (cannot pass in this environment — NOT fixed)

### Blocked by missing RFTtoolbox (`wfield` / `convfield` / `fconv` / `SpheroidSignal` / `contrast_tstats`)

- `test_cope_display` (`SpheroidSignal`)
- `test_fdr_crs_dep` (`wfield`)
- `test_fdr_simul_cs` (`wfield`)
- `test_scopes` *(pre-existing test)* (`wfield`)
- `test_scopes_lm` (`contrast_tstats`)
- `test_srf_scopes` (`wfield`)
- `test_sss_cope_sets` (`wfield`)
- `test_imBH` (`wfield`)
- `test_imBH_data` (`wfield`)
- `test_pc` (`wfield`)
- `test_perm_cluster` (`SpheroidSignal`)
- `test_perm_tfce` (`SpheroidSignal`)
- `test_perm_thresh` (`wfield`)
- `test_viewdata` (`wfield`)
- `test_peakgen` — 2nd cell: `peakgen` internally calls `SpheroidSignal`

### Blocked by missing SPM

- `test_imgsave` — `imgsave` needs `spm_vol`

### Blocked by missing in-repo helper functions (source gaps in StatBrainz)

- `test_mask_bndry`, `test_get_mask` — `get_mask` calls `findstrings` **and** `capstr`,
  neither of which exists anywhere in the repo. Adding these two small helpers would
  unblock both tests (offered earlier; you chose to leave them).

### Blocked by unimplemented / stub source functions

- `test_fs_smooth` — `fs_smooth` is an empty stub (never assigns its output).
- `test_clustertdp` *(pre-existing test)* — `clustertdp` does not support the 2D case the
  test exercises (file itself notes "Need to code up the bound for 2D!"); the 3D cell also
  uses `mask` before defining it and needs real UKB data.

### Blocked by missing data files / external resources

- `test_brainmove` — `imgload('fullmean')` fails although `fullmean.nii` exists under
  `BrainImages/Real_data/DerivedUKB/`; `imgload`'s search path does not cover that subdir.
- `test_loadbrains`, `test_loadsubs` — examples point at hardcoded data dirs
  (`C:/Users/.../Oulu/`, `/vols/Scratch/ukbiobank/...`) not present here.
- `test_fsannot2mask` — `read_annotation` (third-party) needs a real `.annot` file.
- `test_fgreedy` — `fgreedy` does `cd ./ClusterTDPccode` relative to the caller and runs a
  compiled binary; the folder/binary isn't reachable from the test dir.

### Blocked by source bugs (in non-test code)

- `test_imgload` — the `pan3` demo call routes into `overlay_brain` → `combine_brains`,
  which errors with an invalid index (bug in that call path).
- `test_overlay_brain3_dep` — the **deprecated** `overlay_brain3_dep` calls `combine_brains`
  with incompatible arguments and errors (independent of the function-name mismatch).

---

## Pre-existing source issues surfaced (FYI — not changed)

Function-name ≠ file-name mismatches (MATLAB dispatches on the file name, so the declared
name is unreachable). Tests were written/fixed to call the file name:

- `slidergui3.m` declares `sliderGUI3`
- `Xgen2.m` declares `Xgen`
- `overlay_brain3_dep.m` declares `overlay_brain3`
- `bayespw.m` declares `GLM_est_resid_var_pw`
- `brain_extraction3.m` declares `brain_extraction`

Missing helpers referenced by shipped code: `findstrings`, `capstr` (in `get_mask`).
Unimplemented stubs: `fs_smooth`, `gen_mask`, `surf4` (`newfun.m`), several `bayespw`
sub-functions.
