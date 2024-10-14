function extract_brain( filename, doplay, runnet )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
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

