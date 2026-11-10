# StatBrainz tests on matlab_clone (2026-10-14)

Engine: `/mounts/matlab_clone/build-arm/matlab_clone` (aarch64, clone commit `c103e85`).
Runner: `Tests/run_clone_tests.sh` (one process per script, 12 parallel, 300 s timeout).
Comparison: `Tests/compare_clone_outputs.py` -> `comparison.txt`.
Raw results: `results.txt`; per-script output mirrors `Tests/test_output/`.

## Summary

| | MATLAB (2026-07-07) | Clone |
|---|---|---|
| Scripts | 166 | 168 (2 new) |
| OK | 136 | 136 |
| FAIL | 28 | 32 |
| Timeout / crash | 0 | 0 |

Status differs from the MATLAB run for 7 scripts:

| Test | MATLAB | Clone | Reason |
|---|---|---|---|
| `Aux_Functions/test_fast_conv.m` | FAIL | OK | SPM dependency removed since the MATLAB run |
| `ClusterTDP/test_fgreedy.m` | FAIL | OK | fixed in `b7c02fb`; the Linux `fgreedy` binary runs here |
| `test_clustertp_lowerbound.m` | FAIL | OK | clone is lenient: `load('./cluster92.mat')` searches the path (issue 6) |
| `ClusterInference/test_LCE.m` | OK | FAIL | clone `bsxfun` is 2-D only (issue 2) |
| `Surfaces/test_loadmask.m` | OK | FAIL | clone `fread(..., '*char')` shape (issue 1) |
| `ReadSurfaceFiles/test_gifti2surf.m` | OK | FAIL | no Java in the clone (issue 4) |
| `Plotting/test_histpdf.m` | OK | FAIL | intermittent function lookup failure (issue 3); passes when rerun alone |

All other failures have the same root cause as in MATLAB (missing `fdr_cope_sets`,
`overlay_brain3`, `contrast_tstats`, `fastperm`, `MRIread`, `gifti`; the
`loadsubs`/`loadbrains`, `imBH`, `clustertdp` and `fs_smooth` bugs; undefined
variables in `Surfaces/test_scopes.m`, `test_spin_surface.m`, `test_spintest.m`).
Some error messages are worded differently.

## Do the answers match?

- 63 passing scripts give identical output; 4 more match except for display format.
- Scripts that use random numbers cannot match: the clone RNG is not MATLAB's
  (`rng(0); rand` gives 0.5488, MATLAB gives 0.8147). This covers all the
  "values differ" rows in `comparison.txt` that were checked (`test_fdrBH`,
  `test_fdrthresh`, `test_Xgen2`, `test_vec_data`, `test_numOfConComps`, ...).
- About 55 scripts have no usable reference: the per-script MATLAB outputs
  (`Tests/test_output/**/*.txt`) date from 2026-06-25, and many tests were
  changed on 2026-06-28 to print a summary line. A fresh MATLAB run is needed
  to compare these.
- `test_filesindir` differs because the clone's `run` does not change to the
  script folder (issue 5).

## Issues found in the clone

1. **`fread(fp, n, '*char')` returns a row.** MATLAB returns an n×1 column.
   `read_annotation` then transposes it to a column and the concatenation at
   line 172 fails, so `loadmask` and anything using `.annot` files fail
   (`test_loadmask`, `test_srf_noise`).
2. **`bsxfun` handles only 2-D arrays.** `size(bsxfun(@ge, rand(4,5,6), 0.5))`
   gives `4 30`; `bsxfun(@times, rand(2,3,4), rand(2,1,4))` errors. Breaks
   `tfce` in 3-D via `conncomp_bw` (`test_LCE`).
3. **Intermittent "Undefined function" for a function on the path.**
   `test_histpdf` failed in about 5 of 16 runs while other clone processes were
   running, and in 0 of 60 runs on an idle machine. Not caused by `genpath` under
   file churn (checked). Cause not found.
4. **No Java** (`javaObject`), so the gifti reader fails (`test_gifti2surf`,
   `test_read_gifti`, `test_smooth_surface`). Also missing: `graph`
   (`test_graph_cc`) and `capstr` (`get_mask`, `mask_bndry`).
5. **Search path and `run`:**
   - `addpath(genpath('./'))` keeps the entries relative, so after any `cd`
     StatBrainz functions are not found. MATLAB stores absolute paths.
   - `path` separates entries with newlines, not `pathsep`.
   - `run(file)` does not change to the script's folder while it runs.
   - `which` returns `''` for functions on the path.
6. **`fopen`/`load` search the path for explicit relative names** such as
   `'./cluster92.mat'`. MATLAB does not, so the clone passes a test that fails
   in MATLAB.
7. **RNG differs from MATLAB** (see above).
8. **No `persistent`:** a function that declares `persistent x` fails with
   "Undefined function 'persistent'" (found while changing `conncomp_bw`).
9. **Display:** in an N-D array, an all-integer page of an otherwise
   non-integer array prints with width 5 and without "Columns ... through"
   wrapping. Graphics calls return a number (`1`) where MATLAB returns an `Axes`
   object.
