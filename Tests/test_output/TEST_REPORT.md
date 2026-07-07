# StatBrainz Test Report

**Date:** 2026-07-07
**How run:** Every `Tests/**/test_*.m` script was executed headless in its own
MATLAB R2024b process (`-nodisplay -batch`), figures suppressed, with a hard
100 s per-script timeout so a blocking figure/GUI can't stall the run.

## Summary

| Status  | Count |
|---------|-------|
| Total   | 166   |
| **OK**  | **136** |
| **FAIL**| **28**  |
| Timeout | 0     |
| Crash   | 0     |

136 / 166 (82%) of test scripts run to completion. The 28 failures fall into
five root-cause groups below. Note: these are runnable demo/smoke scripts (cell
`%%` scripts), not assertion-based unit tests — "OK" means the script ran without
erroring, not that outputs were checked for correctness.

---

## Failures by root cause

### 1. Missing external toolboxes (not shipped with StatBrainz) — 7 scripts
These need SPM, FreeSurfer, or the `gifti` toolbox on the path. Not bugs in
StatBrainz per se, but the tests can't run without those installed.

| Test | Missing dependency |
|------|--------------------|
| `Aux_Functions/test_fast_conv.m` | `spm_smooth` (SPM) |
| `Surfaces/test_SurfStatEdge.m` | `gifti` (gifti toolbox) |
| `Surfaces/test_adjacency_matrix.m` | `gifti` |
| `Surfaces/test_smooth_surface.m` | `gifti` |
| `Surfaces/Reading_surface_data/test_mgzwrite.m` | `MRIread` (FreeSurfer) |
| `Inference/CopeSets/test_scopes.m` | cascades from `fast_conv` → `spm_smooth` |
| `Surfaces/test_scopes.m` | cascades from `fast_conv` → `spm_smooth` |

### 2. Called function does not exist anywhere in the package — 7 scripts
The function being tested (or a helper it calls) is not present in the repo —
either never written, or renamed/deleted without updating the caller.

| Test | Undefined function | Note |
|------|--------------------|------|
| `Atlases/test_get_mask.m` | `findstrings` | **`Atlases/get_mask.m` itself calls `findstrings`** — the function under test is broken, not just its test |
| `Statistics_Functions/Mask_functions/test_mask_bndry.m` | `findstrings` | same missing helper |
| `ImageViewing/test_overlay_brain3_dep.m` | `overlay_brain3` | `_dep` = deprecated; function removed |
| `Inference/CopeSets/test_cope_display.m` | `fdr_cope_sets` | only `sss_cope_sets` exists |
| `Inference/CopeSets/test_fdr_crs_dep.m` | `fdr_cope_sets` | deprecated |
| `Inference/CopeSets/test_fdr_simul_cs.m` | `fdr_cope_sets` | — |
| `Inference/CopeSets/test_scopes_lm.m` | `contrast_tstats` | not in repo |
| `Inference/CopeSets/test_srf_scopes.m` | `fastperm` | not in repo |

### 3. Missing data files / hard-coded paths — 3 scripts
Scripts reference data files or directories that aren't in the repo.

| Test | Missing path |
|------|--------------|
| `ImageViewing/test_brainmove.m` | "This file is not available" (calls `brainmove`, which loads an unavailable file) |
| `Inference/ClusterInference/ClusterTDP/test_fgreedy.m` | `./ClusterTDPccode` folder does not exist |
| `Inference/ClusterInference/test_clustertp_lowerbound.m` | `./cluster92.mat` not found |

### 4. Genuine code bugs (function errors on valid input) — 8 scripts
These point at real defects in the package functions or the tests.

| Test | Error | Likely cause |
|------|-------|--------------|
| `ImageViewing/test_loadbrains.m` | Index exceeds array elements (max 1) | `loadbrains` indexing assumption |
| `ImageViewing/test_loadsubs.m` | Index exceeds array elements (max 1) | `loadsubs` — same pattern |
| `Inference/ClusterInference/test_clustertdp.m` | Index in position 2 exceeds bounds (max 2) | dimension bug |
| `Inference/MHT/test_imBH.m` | Arrays have incompatible sizes | shape mismatch |
| `Surface/ReadSurfaceFiles/test_fs_smooth.m` | `fs_smooth` output "out" never assigned | function returns nothing on this path |
| `Surface/ReadSurfaceFiles/test_fsannot2mask.m` | `read_annotation` output "vertices" never assigned | (fn exists in repo; fails on this input/file) |
| `Surfaces/test_graph_cc.m` | `indices_notsurvived` undefined | variable never set before use |
| `Surfaces/test_srf_noise.m` | Dot indexing not supported for this type | struct/array type mismatch |

### 5. Test-script setup errors (undefined variable in the test) — 3 scripts
The script uses a variable before it's defined — the test itself is stale, not
necessarily the underlying function.

| Test | Undefined variable |
|------|--------------------|
| `Surfaces/test_spin_surface.m` | `srf` |
| `Surfaces/test_srfplot.m` | `g` |
| *(also)* `Surfaces/test_graph_cc.m` | `indices_notsurvived` (listed above) |

---

## Recommended priorities

1. **Fix `findstrings`** — it breaks `get_mask` and `mask_bndry`, both core
   functions (not just their tests). Either restore the helper or replace its
   call sites.
2. **CopeSets deprecated group** — `fdr_cope_sets`, `contrast_tstats`, `fastperm`,
   `overlay_brain3` are referenced by tests but absent. Decide whether to delete
   the `_dep` tests or restore the functions.
3. **loadbrains / loadsubs indexing bug** — same failure signature in both;
   likely one shared indexing assumption to fix.
4. **External-toolbox tests** — gate behind an `exist('gifti','file')` check or
   document SPM/FreeSurfer/gifti as required for those suites.

Raw results: `Tests/test_output/results.txt`
Per-script MATLAB logs: `Tests/test_output/logs/`
