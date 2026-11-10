# Known bugs (StatBrainz)

Found on 2026-11-10 while writing `Examples/ex_*.m` and `Tests/test_*.m` and
running them in the MATLAB clone. No function code was changed to fix these.
Each failing test keeps the assert for the correct behaviour.

Clone run: 111 of 169 tests pass, 158 of 178 examples run.
Line numbers are from the working tree on 2026-11-10.

## 1. Functions that are called but are not in the repo

| Missing function | Called by |
|---|---|
| `capstr` | `Atlases/get_mask.m:96` (so `get_mask`, `atlas_masks('HOc1mm')`, `mask_bndry` example fail) |
| `fastperm`, `fastperm_mean` | `Inference/CopeSets/scopes.m`, `srf_scopes.m` |
| `fastlmperm`, `lmthresh2scb` | `Inference/CopeSets/scopes_lm.m` |
| `plot_contour` | `Inference/CopeSets/cope_display.m` (truth / docontours options) |
| `lmindices` | `Inference/Resampling/perm_thresh.m` (mask code) |
| `pad_vals`, `sbasis` | `ImageViewing/brainmove.m:46,52` |
| `save_mgh2` (and `MRIread` in the example) | `Surface/ReadSurfaceFiles/mgzwrite.m` |
| `fdr_cope_sets` | `Examples/Inference/CopeSets/ex_fdr_crs_dep.m` |
| `overlay_brain3` | `Examples/ImageViewing/ex_overlay_brain3_dep.m` (`overlay_brain3_dep.m` declares `overlay_brain3`) |

## 2. Files that do not parse or cannot be called

- `Deprecated/fit_bayesglm.m:120-122` (moved from `Inference/BayesGLM`): unbalanced brackets in
  `diff(range(find(any(mask_r, 2))) * res(1)`. With the brackets fixed (in a
  copy), the test asserts pass. Also line 45 checks `nargin < 5` but must check
  `< 6`, and all outputs are empty because the INLA fit is not implemented.
- `Deprecated/fdr_simul_cs.m:52` (moved from `Inference/CopeSets`): a bare `for`. Also lines 30 and 55 use
  `thresh` but the argument is `thresh_vec`, `pvals = [..]` must be `zeros(..)`,
  and `data_tstat` and `data_std` are not defined.
- `Deprecated/brain_extraction2.m:19` (moved from `StatisticsFunctions/FirstLevel`): an extra `)`. Also
  `sorted_input`, `vec_of_max_cluster_sizes`, `alpha` and `h` are not defined.
- `Deprecated/bayespw.m` (moved from `Inference/BayesGLM`): the function in the file is named
  `GLM_est_resid_var_pw`. With `do_pw = 1`, line 76 fails: the placeholder `phi`
  (line 164) is ar_order x 1 but goes into an nV x ar_order slice.
- `Deprecated/fs_smooth.m` (moved from `Surface/ReadSurfaceFiles`), `Deprecated/srfgui.m` (moved from `Surface/Plotting`): stubs.
  `fs_smooth` never assigns its output `out`.
- Function name is not the file name (MATLAB uses the file name, so these work,
  but they are confusing):
  `slidergui3.m` (`sliderGUI3`),
  `bayespw.m` (see above), `overlay_brain3_dep.m` (`overlay_brain3`).

## 3. Wrong results

### Inference/ClusterInference
- `numOfConComps.m:84`: `hist(sizeArray, unique(sizeArray))` reads the size as
  a number of bins when all clusters have the same size (also when there is one
  cluster). Two clusters of size 3 give sizes 3.17, 3.5, 3.83. Because of this:
  - `perm_cluster`: `vec_of_max_cluster_sizes` has values that are not integers.
  - `localized_csi`: a region with one cluster of size 9 gives 9.94.
- `TDP_inference/templates/get_pivotal_stats.m:35`: calls
  `inverse_template(p0(:,i), i+1, p)` with 1-based `i`, so it computes
  p0(k)·m/(k+1), not p0(k)·m/k. Probably an off-by-one from the Python port.
- `TFCE/perm_tfce.m:132`: columns 2 to nperm of `permuted_tstat_store` hold the
  TFCE image, column 1 holds the t-statistic. The help says t-statistics.
- `Clusterextent/perm_cluster.m:87-91`: when no voxel is above the CDT, the early
  return leaves `permuted_tstat_store` unassigned, so a call with 3 outputs fails.
- `bestclusterslice.m:33`: a cell input goes to `index2mask` and errors, so the
  cell branch (line 47) cannot run. That branch also takes `dim` from the size of
  the cell array.
- No failing assert:
  - `tfce`, `LCE`, `perm_tfce` help says the default h0 is 3.1, the code uses 0.
  - `real_tfce_clusters.m:83` does not pass `h0` to `tfce`.
  - The `perm_cluster` help EXAMPLES block calls `perm_tfce`.

### Inference/MHT
- `imBH.m:24`, `fdp_calc.m:22`: `if size(a) ~= size(b)` is true only when all
  sizes differ, so the size error never shows. Use `~isequal(size(a), size(b))`.
- `imBH.m:38`, `imBH_data.m:38`: `pvals <= maxp+eps` is not limited to the
  mask, so a small p-value outside the mask is rejected and counted.
- `fdrthresh.m:33`: `tinv(maxp, df)` gives a negative threshold for upper-tail
  p-values. Probably `tinv(1-maxp, df)`.
- `localized_vi.m:38`: the maximum is over the full image with zeros outside the
  region, so a region with only negative values gives 0.
- `spatialBH.m:45`: `FWHM` is optional in the help but has no default.

### Inference/FirstLevel, Resampling, Permutation
- `prewhiten.m:39`: `data_pw` is overwritten in each loop, so only the last row
  comes back (1 x ntime). It also prints `I` for each row.
- `Xgen2.m:52`: the AR(1) process does not start at stationarity, so column 1
  has variance 1−ρ², not 1. The help shows `'armix'` and a 5-argument form that
  do not exist.
- `perm_thresh.m:58`: `if ~exist('subject_mask','var') mask = NaN` always sets
  the mask to NaN, so the mask input is ignored.
- `spintest.m`: `nperm` has no default, but the help says 1000.

### Inference/CopeSets
- `scopes.m`: `show_loader` and `alpha` have no defaults.
- `srf_scb2cope.m:35-36`: for both hemispheres, the full `srf` goes to
  `srf_contour`, not `srf.lh` / `srf.rh`.
- `srf_cope_display.m`, `srf_cope_display2.m`: the output `out` is never
  assigned. At line 56 (both hemispheres) the `srfplot` arguments are in the
  wrong order: 0.05 goes to `dointerp` and `'top'` to `dofullscreen`.
- `srf_color_crs.m:61-62`: the `'red'` scheme has the same colours as `'blue'`.

### StatisticsFunctions
- `convind.m:56`: tests `size_of_array(1) == 1` two times. The second must be
  `size_of_array(2) == 1`. `convind(3,[5,1])` gives `[3,1]`, not `3`.
- `ImageOperations/Kernels/GkerMV2.m:38`: the exponent uses only `x(1,:)` and
  `x(2,:)`, so it is correct only for D = 2. For D = 3,
  `GkerMV2([1;1;1],[2;3;4])` gives 0.0127, not 0.0107. For D = 1 it errors.
- `ImageOperations/fast_conv.m:161,184`: a column vector with no D comes back as
  a row (41x1 in, 1x41 out). The values are correct.
- `Mask_functions/pad_im.m:50-54`: negative padding (cropping) has no 2-D branch.
  `pad_im(magic(5), [-1 -1])` never assigns `padded_im`.
- `Mask_functions/region_bndry2D.m:22`: `zeros(2*[91,109,91])` is 3-D, so the
  output is 182x218x182, not 2-D.
- `Aux_functions/pearsrnd.m`:
  - Lines 85-87: skew = 0, kurt > 3 (type VII) uses the type 2 path and gets
    complex roots. Type 7 is never returned, but the help says it can be.
  - Lines 167-201 (`type4_`): wrong moments. `pearsrnd(0,1,1,6)` gives sample
    skewness −0.25 and kurtosis 4.36 (n = 200000).
- `Aux_functions/SystemFunctions/filesindir.m:48-49`: with `hiddenfiles = 1`,
  `pattern` is ignored. Line 51: no match gives `{[]}`, not an empty cell.
- No failing assert:
  - `MkRadImg` help says squared distance, the code returns Euclidean distance.
  - `doubleim` works only for 91x109x91 input.
  - `mask_bounds` loops or errors on an empty mask.
  - `peakgen` does not support 1-D.
  - `pval2tstat`, `distbn2pval`: unused defaults (`do2sample`, `opt1`).
  - `brain_extraction.m:34` prints `I` on each loop. `brain_extraction3.m:26`
    has a fixed lower threshold of 25.
  - `histpdf.m:25` prints `do_plot = 1` (unused). `histpdf.m:38` runs `close all`.
  - `mytiles.m:55` prints the screen size (no `;`).
  - The `asinh_trans` help EXAMPLES call `asinh_data_trans`.
    `stdsmo` in `asinh_data_trans` is not used.

### ImageViewing
- `overlay_brain.m:70`: calls `doubleim(underim)` when `underim` is the default
  `[]`, which errors. Line 109 `any(isnan(underim(:)))` ignores an underlay
  that has no NaNs and shows the MNI brain in its place (possibly not intended).
- `pan3.m:33-37`: calls `overlay_brain` with an old argument order, and the
  slice is `[x,0,0]`. The output `out` is never assigned.
- `combine_brains.m:71`: with `use_bounds = 0` and the default `outerpad = {0,0}`,
  `if outerpad > 0` compares a cell. Line 72 calls `pad_im` with one argument.
  Lines 68-69 hard-code 2mm sizes. The help says `outerpad` is `{rows, cols}`,
  the code uses `{lower, upper}`.
- `viewdata2.m:39`: uses `alphas(1)`, not `alphas(I)`, so every region gets the
  first alpha.
- `Shape_screen/screenshape.m`: `screen_size` is never assigned.
- `brainmove.m`: see section 1. It also blocks on `waitforbuttonpress`.
- `loadbrains.m:31`: the default for `subfilenames` cannot be reached, because
  `directory` is the second argument.

### Surface
- `resample_srf.m:47-48`: the second check is `isfield(surface_data,'lh')`, and
  rh is resampled from `surface_data.lh`.
- `resample_srf_nn.m:28`: checks `'lh'`, not `'rh'`, so a struct with only `.lh`
  errors on the missing `rh`.
- `smooth_surface.m:56,60`: the lh/rh branch does not pass `metric` and `niters`.
- `spin_surface.m:103,107`: `right_rotations` uses the left index from `bl`, not
  `br`. Line 52 has a Windows default path for the sphere. With
  `include_orig = 0` you get only nperm−1 rotations.
- `srf_noise.m:78`: a logical mask goes to `SurfStatSmooth`, which treats it as a
  struct ("Dot indexing requires a struct"). Real MATLAB fails the same way.
- `srf_face_area.m:61,66`: uses `srf.nvertices` and `srf.nfaces`, so a struct
  with only faces and vertices fails, and so does a path input. The help says
  both are valid.
- `Plotting/srf_colour.m:44-45`: the lh/rh branch does not pass
  `background_gradient`.
- `Plotting/srfplot.m:146`: `srfplot(srf)` with an lh/rh struct and no data
  fails on `[].lh`.
- `Plotting/srfplot2.m:88`: reads `srf.nfaces` before the lh/rh branch. Lines
  116, 118 and 131 call `srfplot` with the argument order of `srfplot2`.
- `mgzwrite.m` uses the `gzip` and `mv` commands, so it works only on Unix.
- No failing assert:
  - `graph_cc` counts clusters with one vertex in `number_of_clusters` but not in
    `cluster_sizes` or `occurences`. It has an unused `opt1`.
  - `srf_dilate_mask` erosion returns a double, the help says logical.
  - `loadmask` has an unused hard-coded `sbdir`.

### BrainFunctions, Atlases, root
- `BrainFunctions/gen_mask.m:35`: `ones(prod(stdsize))` makes an n x n matrix,
  not an n x 1 vector. It also uses a global `stdsize`, which usually has no
  value. The test passes in the clone only because of a clone global bug; it
  must fail in MATLAB.
- `addSB2path.m:19`: `a(end-9:end)` errors when the current folder path has
  fewer than 10 characters (e.g. `/tmp`). Found by reading the code.
- `Atlases/get_mask.m:96`: see `capstr` in section 1.

## 4. Examples that still fail and are not in the list above

- `Examples/Surfaces/ex_SurfStatEdge.m`: local Windows path to a neuromaps file.
- `Examples/Surfaces/ex_scopes.m`: undefined `data` and local HCP paths.
- `Examples/Inference/ClusterInference/ClusterTDP/ex_ctp_scores.m`: clone
  `textscan` bug (see section 5). Should run in MATLAB.
- `fgreedy`: the binary in `ClusterTDPccode` is x86-64, so it does not run on
  aarch64. The test checks only that the call runs.

## 5. Clone bugs (MATLAB behaves differently)

These cause test failures that are not StatBrainz bugs.

- `randsample(pop, n, true, w)` ignores the weights (`test_gmrnd`).
- `tcdf`, `tinv`, `normcdf` change N-D input to 2-D: 3x2x2 gives 3x4
  (`test_tstat2pval`). `tinv(0.5, 7)` gives 2.1e-08, not 0.
- `textscan(fid,'%s','Delimiter','\n')` splits at the letter "n"
  (`test_ctp_extract_score`, `test_ctp_scores`).
- `[zeros(0,1); zeros(0,1)]` gives 0x0, not 0x1 (`test_sss_cope_sets`).
- `binornd(1, p)` with a vector `p` errors (`test_Xgen2`, option `'012'`).
- `get(groot,'CurrentFigure')` returns `[]` and `figure('Position',...)` is
  ignored (`test_fullscreen2`).
- A global set in the base workspace has no value inside a function.
- `exist(name, 'file')` gives 0 for a function on the path (MATLAB gives 2).
- `circshift(A,[a b c])` on a 3-D array gives a wrong 2-D result.
- `repelem(A,a,b,c)` returns a 2-D array.
- `str2num` on text with more than one line gives only the first number.
- `>` on complex values errors (MATLAB compares the real parts).
- Does not parse `parfor` (`bayespw` shows as undefined).
- Missing: `runtests`, `functiontests`, `knnsearch`, `lastwarn`, `findobj`,
  `ishandle`, `isgraphics`, `isvalid`. `get` on graphics objects returns 0 and
  `Children` is empty, so the plotting tests only check that the calls run.
- `format long` has no effect. `mkdir`/`rmdir` without `;` print their status.
