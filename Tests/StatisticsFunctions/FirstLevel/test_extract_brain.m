%% test_extract_brain
% Tests of the extract_brain function. These only print the HD-BET command
% (runnet = 0), as HD-BET is not part of StatBrainz.
%--------------------------------------------------------------------------
filename = [statbrainz_maindir, 'BrainImages/Volume/MNIbrain.nii.gz'];

%% The command uses HD-BET, the input file and the cpu options
out = evalc('extract_brain( filename, 0, 0 )');
assert(contains(out, ['-i ', filename]))
assert(contains(out, 'HD-BET/HD_BET/hd-bet'))
assert(~contains(out, 'HD-BETplay'))
assert(contains(out, '-device cpu -mode fast -tta 0'))

%% doplay = 1 uses HD-BETplay
out = evalc('extract_brain( filename, 1, 0 )');
assert(contains(out, 'HD-BETplay/HD_BET/hd-bet'))
assert(contains(out, ['-i ', filename]))

%% The command is a single line
out = strtrim(evalc('extract_brain( filename, 0, 0 )'));
assert(~contains(out, newline))
