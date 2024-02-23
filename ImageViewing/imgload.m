function img = imgload( filename )
% IMGLOAD( filename ) loads in a .nii or a .nii.gz using niftiread
% which requires MATLAB version >= 2017. It can be used to read in files
% from the BrainImages folder in the StatBrainz repository.
%--------------------------------------------------------------------------
% ARGUMENTS
% filename  is the name of the file to load
%--------------------------------------------------------------------------
% OUTPUT
% img       an array of the numbers in the image
%--------------------------------------------------------------------------
% EXAMPLES
% im = imgload('MNImask');
% pan3(im, [30,40,50])
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------
sb_dir = statbrainz_maindir;
bs_img_loc = [sb_dir, 'BrainImages/Volume/'];

if strcmp(filename(end-2:end), '.gz') || strcmp(filename(end-3:end), '.nii')
    try
        img = niftiread([bs_img_loc, filename]);
    catch
        try
            img = niftiread(filename);
        catch
            error('This file is not available\n')
        end
    end
else
    try
        img = niftiread([bs_img_loc, filename, '.nii']);
    catch
        try
            img = niftiread([bs_img_loc, filename, '.nii.gz']);
        catch
            error('This file is not available\n')
        end
    end
end

img = double(img);
% Set masks to be True/False
if isequal(unique(img), [0;1])
    img = img > 0;
end
% img = img > 0;

end
