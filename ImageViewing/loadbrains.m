 function [ data, bounded_mask ] = loadbrains( subfilenames, directory, mask, as3D, subjsubset)
% loadbrains( subfilenames, directory, mask, as3D, subjsubset)
%--------------------------------------------------------------------------
% ARGUMENTS
% subfilenames   a cell array giving the names of the different files in the
%               directory that you would like to access
% directory      the directory to load the files from
% mask           a 3D binary mask; default is the MNImask
% as3D           0/1 whether to load the images as 3D matrices or 1D
%               vectorized versions. Default is 0.
% subjsubset     a vector of indices into subfilenames specifying which
%               subjects to load. Default is 1:length(subfilenames).
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
if ~exist('subfilenames', 'var')
    subfilenames = filesindir(directory, '.nii');
end
if ~exist('as3D', 'var')
    as3D = 0;
end
if ~exist('mask', 'var')
    mask = imgload('MNImask');
end
if ~exist('subjsubset', 'var')
    subjsubset = 1:length(subfilenames);
end

if strcmp(subfilenames{1}(end-1:end), 'gz')
    usenif = 0;
else
    usenif = 1;
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
    if usenif == 1
        for I = 1:length(subjsubset)
            nif = niftiread([directory,subfilenames{subjsubset(I)}]);
            data(:,:,:,I) = nif.dat(bounds{:});
            fprintf('Loaded subject %i\n', I)
        end
    else
        for I = 1:length(subjsubset)
            % img = spm_read_vols(spm_vol([directory,subfilenames{subjsubset(I)}]));
            img = niftiread([directory,subfilenames{subjsubset(I)}]);
            data(:,:,:,I) = img(bounds{:});
            fprintf('Loaded subject %i\n', I)
        end
    end
else
    data = zeros([prod(Dim), nsubj]);
    if usenif == 1
        for I = 1:length(subjsubset)
            nif = nifti([directory,subfilenames{subjsubset(I)}]);
            bounded_nif = nif.dat(bounds{:});
            data(:,I) = bounded_nif(:);
            fprintf('Loaded subject %i\n', I)
        end
    else
        for I = 1:length(subjsubset)
            img = spm_read_vols(spm_vol([directory,subfilenames{subjsubset(I)}]));
            img = img(bounds{:});
            data(:,I) = img(:);
            fprintf('Loaded subject %i\n', I)
        end
    end
end

end
