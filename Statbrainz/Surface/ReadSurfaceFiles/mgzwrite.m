function [ out ] = mgzwrite( voldata, filename )
% MGZWRITE Writes a volume array to an .mgh or .mgz file.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  voldata   3-D volume array to write
% Optional
%  filename  output file path ending in '.mgh' or '.mgz'
%            (default: './ex.mgh')
%--------------------------------------------------------------------------
% OUTPUT
%  (none)  writes the file to disk
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

