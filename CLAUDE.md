# CLAUDE.md - package_name Repository Guidelines

## Package Overview
package_name is a MATLAB toolbox for <purpose>. It provides utilities for:
- <area 1>
- <area 2>

## Code Structure Rules

### One Function Per File
- Each `.m` file should contain **exactly one function**
- The filename should match the function name (e.g., `filter_nones.m` contains `function out = filter_nones(...)`)
- When asked to create or modify a function (or its tests or examples), follow the Function Development Workflow below. 

## Code Changes
- Don't make changes to the code or the files in the repo unless asked to.
- Do not rename existing functions unless explicitly directed to.
- Maintain the current structure of the package unless explicitly directed otherwise.
- Warn the user when a change might make the current branch incompatible with its base branch.
- If a big change is made that deserves a change to the readme, suggest doing so to the user.

### Function Structure Template

All functions must follow this exact help-comment structure:

```matlab
function output = function_name( arg1, arg2, optional_arg )
% FUNCTION_NAME Brief one-line description of what the function does.
%
%   output = function_name(arg1, arg2, optional_arg)
%   extended description if needed, explaining the function's purpose
%   and behavior in more detail.
%
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       arg1          - Description of arg1.
%       arg2          - Description of arg2.
%   Optional
%       optional_arg  - Description of optional_arg (default: default_value).
%--------------------------------------------------------------------------
% OUTPUT
%   output        - Description of what is returned.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - <year> - <author>
%--------------------------------------------------------------------------

if ~exist( 'optional_arg', 'var' )
    optional_arg = default_value;
end

% Function implementation

end
```

### Key Conventions
- The first help line is the function name in capitals followed by a one-line description
- The help block uses dashed separator lines `%` followed by exactly 74 dashes (75 characters in total)
- Arguments are split into `Mandatory` and `Optional` sub-headings
- Optional arguments note their default as `(default: value)`
- Set defaults for optional arguments with `if ~exist( 'arg', 'var' )`
- Don't use classes unless its unavoidable.

## Function Development Workflow

All paths below are relative to the repo root. `<module>` is the folder path
of the function inside `package_name/`, e.g. `module_a` or `subpackage/module_b`.

### Allowed Edit Directories

- Functions: `package_name/<module>/`
- Tests: `tests/<module>/`
- Examples: `examples/auto_examples/<module>/`

Do NOT edit files outside these three directories. Do NOT git commit anything yourself.

### Search Scope

When searching for context, patterns, or existing implementations, search the
full package. This ensures you understand existing conventions and avoid
duplicating functionality.

### When asked to create or modify a function:

**Before starting:** If the user has not said where the function goes, ask,
suggesting sensible `<module>` options. Summarize the task and ask clarifying
questions about any ambiguities.

Then follow these steps:

1. **Check for existing functions first** - Search the full package for existing functions that provide the needed functionality. Reuse existing utilities rather than duplicating. Only create new functions when no suitable alternative exists.

2. **Create/modify the function** - Write it following the conventions above. One function per file, filename matching the function name.

3. **Write tests** - Create a test file at:
   `tests/<module>/test_<function_name>.m`

4. **Execute tests** - Run the test file from the repo root with:
   ```
   matlab -batch "addpath(genpath('package_name')); results = runtests('tests/<module>/test_<function_name>.m'); assertSuccess(results)"
   ```
   Verify all tests pass before proceeding.

5. **Write examples** - Create examples at:
   `examples/<module>/ex_<function_name>.m`

   - Include 3 relatively simple examples
   - Separate each example with `%%`

6. **Execute examples** - Run to verify they work:
   ```
   matlab -batch "addpath(genpath('package_name')); run('<examples_file>.m')"
   ```

   Do NOT skip this step. Execution is mandatory.

### When modifying an existing function:
- Follow the same workflow as creating a function
- Update existing test and example files if they exist; create them if not
- Ensure backwards compatibility: existing examples must still work after modifications (unless explicitly told otherwise)

### When asked to create tests only:
Run steps 3-4 above.

### When asked to create examples only:
Run steps 5-6 above.
