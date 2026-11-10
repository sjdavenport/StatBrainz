# CLAUDE.md - StatBrainz Repository Guidelines

## Package Overview
StatBrainz is a MATLAB toolbox for statistical inference on, and visualisation
of, brain imaging data. It provides functions for:
- resampling and permutation inference (`Inference/Permutation`, `Inference/Resampling`)
- multiple hypothesis testing and TDP bounds (`Inference/MHT`, `Inference/TDP_inference`)
- clustersize inference, TFCE and cluster TDP (`Inference/ClusterInference`)
- CoPE / confidence sets, single and simultaneous (`Inference/CopeSets`)
- first level and Bayesian GLMs, ICA (`Inference/FirstLevel`, `Inference/BayesGLM`, `Inference/ICA`)
- statistics, signal and noise generation, smoothing and masks (`StatisticsFunctions/...`)
- reading, viewing and plotting volumes (`ImageViewing`, `BrainFunctions`, `Atlases`)
- reading, smoothing and plotting surfaces (`Surface/...`)

Data used by the functions and examples (MNI templates, fsaverage surfaces,
atlases) is in `BrainImages/` and `Atlases/`. `Tutorials/` holds the live scripts.
Load the package by running `addSB2path` from the repo root.

## Repo Layout

| Folder | Contents |
|---|---|
| `<module>/` (e.g. `Inference/ClusterInference`) | Package functions |
| `Examples/<module>/ex_<name>.m` | Example scripts, one per function |
| `Tests/<module>/test_<name>.m` | Test scripts with `assert`, one per function |
| `Examples/example_output*`, `Tests/test_output*` | Generated run output. Do not edit by hand |

`Examples/` and `Tests/` mirror the folder structure of the package.
Example scripts use the `ex_` prefix and test scripts use the `test_` prefix.
This is necessary because `addSB2path` adds the full repo to the path, so the
two must not have the same name.

Third-party code is not ours. Do not restyle it or add examples or tests for it:
`Surface/SurfStat/`, `Surface/ReadSurfaceFiles/freesurfer*`, `read_gifti.m`,
`read_fs_geometry.m`. Files with the suffix `_dep` are deprecated and stay as they are.

## Code Structure Rules

### One Function Per File
- Each `.m` file contains **one public function**. Local helper functions at
  the bottom of the file are permitted when only that file uses them.
- The filename must match the function name (e.g. `mvtstat.m` contains
  `function [tstat, xbar] = mvtstat( data, ... )`).
- When asked to create or modify a function (or its tests or examples), follow
  the Function Development Workflow below.

## Code Changes
- Don't make changes to the code or the files in the repo unless asked to.
- Do not rename existing functions unless explicitly directed to.
- Maintain the current structure of the package unless explicitly directed otherwise.
- Warn the user when a change might make the current branch incompatible with its base branch.
- If a big change is made that deserves a change to the README, suggest doing so to the user.
- StatBrainz must run in base MATLAB where possible. Do not add a dependency on
  SPM or a toolbox. If a toolbox function is needed, give a fallback
  (see `conncomp_bw.m`) and list it in the README Requirements.

### Function Structure Template

All functions use this help-comment structure (the StatBrainz house style):

```matlab
function [ out1, out2 ] = function_name( arg1, arg2, opt_arg )
% FUNCTION_NAME( arg1, arg2, opt_arg ) brief description of what the
% function does.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  arg1      a description of arg1, e.g. a Dim by nsubj array of data
%  arg2      a description of arg2
% Optional
%  opt_arg   a description of opt_arg. Default is 0.05.
%--------------------------------------------------------------------------
% OUTPUT
%  out1      a description of out1
%  out2      a description of out2
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt_arg', 'var' )
    % Default value
    opt_arg = 0.05;
end

%%  Main Function Loop
%--------------------------------------------------------------------------

end
```

### Key Conventions
- The first help line is the function name in capitals followed by a short description.
- Separator lines are `%` followed by exactly 74 dashes (75 characters in total).
- Arguments are split into `Mandatory` and `Optional` sub-headings. If there
  are none, write `% None`.
- Optional arguments state their default as `Default is <value>.`
- Set defaults for optional arguments with `if ~exist( 'arg', 'var' )`.
- The Copyright line gives the year the function was written.
- Spaces inside the brackets of the signature and of `exist( ... )` calls.
- Don't use classes unless it is unavoidable.

## Running MATLAB

- In the sandbox, use the MATLAB clone at `/mounts/matlab_clone/build-arm/matlab_clone`.
  Run code with `-e "<code>"` from the repo root, e.g.
  ```
  /mounts/matlab_clone/build-arm/matlab_clone -e "cd('/workspace'); addSB2path; set(0, 'DefaultFigureVisible', 'off'); run('Tests/<module>/test_<name>.m')"
  ```
  The clone does not have `runtests`, `functiontests` or `knnsearch`, and its
  graphics support is limited (no `findobj`, `ishandle` or `isgraphics`).
- On the Mac, use `/Applications/MATLAB_R2024b.app/bin/matlab -batch "..."`.
- Run all the tests with `Tests/run_clone_tests.sh` and all the examples with
  `Examples/run_clone_examples.sh` (clone), or `Examples/run_all_examples.sh` (MATLAB).
- If the clone and MATLAB give different results, do not change StatBrainz to
  work around a clone bug. Tell the user.

## Function Development Workflow

All paths below are relative to the repo root. `<module>` is the folder of the
function in the package, e.g. `Inference/ClusterInference/TFCE`.

### Allowed Edit Directories

- Functions: `<module>/`
- Tests: `Tests/<module>/`
- Examples: `Examples/<module>/`

Do NOT edit files outside these three directories. Do NOT git commit anything yourself.

### Search Scope

When searching for context, patterns, or existing implementations, search the
full package. This ensures you understand existing conventions and avoid
duplicating functionality.

### When asked to create or modify a function:

**Before starting:** If the user has not said where the function goes, ask,
suggesting sensible `<module>` options. Summarise the task and ask clarifying
questions about any ambiguities.

Then follow these steps:

1. **Check for existing functions first** - Search the full package for
   existing functions that provide the needed functionality. Reuse existing
   utilities rather than duplicating. Only create new functions when no
   suitable alternative exists.

2. **Create/modify the function** - Write it following the conventions above.
   One function per file, filename matching the function name.

3. **Write tests** - Create a test script at `Tests/<module>/test_<name>.m`:
   - A plain script (not a test class), so that it runs in the clone with
     `run` and in MATLAB with `run` or `runtests`.
   - One `%%` section for each check, with a short title.
   - Check results with `assert`: known values, sizes, edge cases, and
     error conditions (`try ... end` and assert that an error occurred).
   - Use small inputs and set `rng` so the test is fast and deterministic.
   - For plotting functions, assert that the call runs and returns valid handles.

4. **Execute tests** - Run the test script with the clone (command above) and
   make sure that all asserts pass before you continue.

5. **Write examples** - Create an example script at `Examples/<module>/ex_<name>.m`:
   - Start with the banner
     ```
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%
     %%%    This script gives examples of the <name> function
     %%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     ```
   - Include 3 relatively simple examples, separated with `%%`.
   - Use data in `BrainImages/` or generated data, not paths on a local disk.

6. **Execute examples** - Run the example script with the clone and make sure
   that it runs to the end. Do NOT skip this step. Execution is mandatory.

### When modifying an existing function:
- Follow the same workflow as creating a function.
- Update existing test and example files if they exist; create them if not.
- Ensure backwards compatibility: existing examples must still work after
  modifications (unless explicitly told otherwise).

### When asked to create tests only:
Run steps 3-4 above.

### When asked to create examples only:
Run steps 5-6 above.
