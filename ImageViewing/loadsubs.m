 function [ data, bounded_mask ] = loadsubs( subjsubset, directory, usenif, mask, as3D, subfilenames  )
% LOADSUBS( subjsubset, directory, usenif, mask, as3D, subfilenames )
%--------------------------------------------------------------------------
% ARGUMENTS
% subjsubset     a vector of positive integers denoting the files in the
%               directory that you would like to load
% directory      the directory to load the files from
% usenif         retained for backward compatibility; ignored. Files are now
%               always read with the base-MATLAB niftiread (handles both .nii
%               and .nii.gz), so no SPM dependency is required.
% mask           a 3D binary mask; default is the MNImask
% as3D           0/1 whether to load the images as 3D matrices or 1D
%               vectorized versions. Default is 0.
% subfilenames   a cell array giving the names of the different files in the
%               directory that you would like to access
%--------------------------------------------------------------------------
% OUTPUT
% data           a matrix of size [prod(Dim), nsubj] (as3D=0) or
%                [Dim, nsubj] (as3D=1) containing the loaded brain data
% bounded_mask   the brain mask cropped to its bounding box
%--------------------------------------------------------------------------
% EXAMPLES
% exsubs = loadsubs( 3:5,'C:/Users/12Sda/davenpor/data/RestingStateData/Oulu/', 0 );
%
% %As 3D
% MNImask = imgload('MNImask');
% exsubs = loadsubs( 3:5,'C:/Users/12Sda/davenpor/data/RestingStateData/Oulu/', 0, MNImask, 1 );
% imagesc(exsubs(:,:,50,1))
%
% loadsubs( 1:2, '/vols/Scratch/ukbiobank/nichols/SelectiveInf/feat_runs/RS_2Block_warped/', 0, MNImask, 1 )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------
if ~exist('usenif', 'var')
    usenif = 1;
end
if ~exist('subfilenames', 'var')
    subfilenames = filesindir(directory, '.nii');
end
if ~exist('as3D', 'var')
    as3D = 0;
end
if ~exist('mask', 'var')
    mask = imgload('MNImask');
end

% Obtain the bounded mask
bounds = mask_bounds( mask );
bounded_mask = mask(bounds{:});

% Obtain the size of the bounded mask
Dim = size(bounded_mask);

% Obtain the number of subjects
nsubj = length(subjsubset);

if as3D == 1
    data = zeros([Dim, nsubj]);
    for I = 1:length(subjsubset)
        img = niftiread([directory,subfilenames{subjsubset(I)}]);
        data(:,:,:,I) = img(bounds{:});
    end
else
    data = zeros([prod(Dim), nsubj]);
    for I = 1:length(subjsubset)
        img = niftiread([directory,subfilenames{subjsubset(I)}]);
        img = img(bounds{:});
        data(:,I) = img(:);
    end
end

end
