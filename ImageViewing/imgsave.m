function imgsave( array, filename, directory, header )
% IMGSAVE( array, filename, directory, header) saves an array as a nifti
% file using MATLAB's built-in niftiwrite (which requires MATLAB version
% >= 2017), so that no SPM installation is required. It is the write
% counterpart to imgload.
%
% Note it can also take a 91*109*91 vector as an input as it will
% automatically reshape it to be the right size.
%--------------------------------------------------------------------------
% ARGUMENTS
% array     the array to be saved (typically [91,109,91]). A 902629x1 (or
%           1x902629) vector is automatically reshaped to [91,109,91].
% filename  the name of the file to save (the .nii extension is added
%           automatically if not present).
% directory the directory to save to. Default is the current working
%           directory (pwd). The saved file is <directory>/<filename>.nii.
% header    optional nifti header info struct (as returned by niftiinfo).
%           If not provided, geometry is taken from the bundled template
%           BrainImages/Volume/ExData.nii and adjusted to match array.
%--------------------------------------------------------------------------
% OUTPUT
% A saved image at <directory>/<filename>.nii
%--------------------------------------------------------------------------
% EXAMPLES
% % Save an example image to a temporary directory
% imgsave( zeros(91,109,91), 'examplesave', tempdir )
% % reload it to check
% im = niftiread( fullfile(tempdir, 'examplesave.nii') );
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

sb_dir = statbrainz_maindir;

%%  Add/check optional values
%--------------------------------------------------------------------------
if nargin < 3 || isempty( directory )
    directory = pwd;
end

if ~(exist( directory, 'dir' ) == 7)
    error( 'This directory does not exist' )
end

% Reshape a flattened MNI-space vector back to [91,109,91]
if isequal( size(array), [1, 902629] ) || isequal( size(array), [902629, 1] )
    array = reshape( array, [91,109,91] );
end

% niftiwrite writes single/double as-is; ensure a concrete numeric type
array = double( array );

%%  Obtain a header (geometry) for the file
%--------------------------------------------------------------------------
if nargin < 4 || isempty( header )
    % Borrow the spatial geometry from the bundled example image, exactly as
    % the previous SPM-based version did with spm_vol(...'ExData.nii').
    header = niftiinfo( [sb_dir, 'BrainImages/Volume/ExData.nii'] );
end

% Make the header consistent with the array actually being written,
% otherwise niftiwrite errors on a size/type mismatch.
header.ImageSize   = size( array );
header.Datatype    = class( array );
header.PixelDimensions = header.PixelDimensions(1:ndims(array));

%%  Write the file
%--------------------------------------------------------------------------
% Strip a trailing .nii from filename if present (niftiwrite adds it back).
if length(filename) > 4 && strcmp( filename(end-3:end), '.nii' )
    filename = filename(1:end-4);
end

file = fullfile( directory, filename );
niftiwrite( array, file, header );

end
