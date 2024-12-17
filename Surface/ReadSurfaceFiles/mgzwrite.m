function [ out ] = mgzwrite( voldata, filename )
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
% mask = MRIread('/Users/sdavenport/Documents/Data/Surface/Oasis_data/oasis_data_raw/disc1_freesurfer/OAS1_0001_MR1/mri/brainmask.mgz');
% subplot(1,2,1)
% imagesc(mask.vol(:,:,50))
% mgzwrite(mask.vol, './test.mgz')
% testim = MRIread('./test.mgz')
% subplot(1,2,2)
% imagesc(testim.vol(:,:,50))
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'filename', 'var' )
   % Default value
   filename = './ex.mgh';
end

% voldata = permute(voldata, [2, 1, 3]);

%%  Main Function Loop
%--------------------------------------------------------------------------
% Define an affine transformation matrix (4x4) for orientation
% You can use the identity matrix if no specific transformation is needed
M = eye(4);

% Save the volume using save_mgh2
if strcmp(filename(end-2:end), 'mgh')
    save_mgh2(voldata, filename, M);
elseif strcmp(filename(end-2:end), 'mgz')
    filename(end) = 'h';
    save_mgh2(voldata, filename, M);
    system(['gzip ', filename])
    system(['mv ', filename, '.gz ', filename(1:end-4), '.mgz'])
else
    error('The filename must end in .mgh or .mgz');
end

end

