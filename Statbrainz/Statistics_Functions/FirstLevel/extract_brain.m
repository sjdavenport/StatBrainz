function extract_brain( filename, doplay, runnet )
% EXTRACT_BRAIN runs the HD-BET brain extraction tool on a NIfTI file.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  filename   path to the input NIfTI file (e.g. a T1w .nii or .nii.gz)
% Optional
%  doplay     1 to use the HD-BETplay variant, 0 for standard HD-BET; default is 0
%  runnet     1 to execute the brain extraction command, 0 to print it; default is 1
%--------------------------------------------------------------------------
% OUTPUT
% None
%--------------------------------------------------------------------------
% EXAMPLES
% filename = '/Users/sdavenport/Documents/Data/fMRI/Flanker/Unprocessed/sub-01/anat/sub-01_T1w.nii.gz';
% extract_brain( filename )
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'doplay', 'var' )
   % Default value
   doplay = 0;
end

if ~exist( 'runnet', 'var' )
   % Default value
   runnet = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
pythonversion = '/opt/homebrew/bin/python3.9';

if doplay
    hdbetloc = '~/Documents/Code/Python/Other_Packages/HD-BETplay/HD_BET/hd-bet';
else
    hdbetloc = '~/Documents/Code/Python/Other_Packages/HD-BET/HD_BET/hd-bet';
end

cpustr = ' -device cpu -mode fast -tta 0';

subid = 1;
substr = ['sub-0', num2str(subid)];
job2run = [pythonversion, ' ', hdbetloc, ' -i ', filename, cpustr];

if runnet
    system(job2run)
else
    disp(job2run)
end

end

