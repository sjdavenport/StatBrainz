function [ data, bounded_mask ] = loadsubs( subjsubset, directory, usenif, mask, as3D, subfilenames  )
% LOADSUBS( subjsubset, directory, usenif, subfilenames, as3D )
%--------------------------------------------------------------------------
% ARGUMENTS
% subjsubset     a vector of positive integers denoting the files in the
%               directory that you would like to load
% directory      the directory to load the files from
% usenif        0/1 load the files using nifti or not. Default is 1 i.e. to
%               use nifti
% subfilensame   a cell arry giving the names of the different files in the
%               directory that you would like to access
% as3D          0/1 whether to save the images as 3D matrices or 1D
%               vectorized versions
%--------------------------------------------------------------------------
% OUTPUT
% data          a 
%--------------------------------------------------------------------------
% EXAMPLES
% exsubs = loadsubs( 3:5,'C:/Users/12Sda/davenpor/data/RestingStateData/Oulu/', 0 );
%
% %As 3D
% MNImask = imgload('MNImask');
% exsubs = loadsubs( 3:5,'C:/Users/12Sda/davenpor/data/RestingStateData/Oulu/', 0, MNImask, 1 );
% imagesc(exsubs(:,:,50,1))
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
    if usenif == 1
        for I = 1:length(subjsubset)
            nif = nifti([directory,subfilenames{subjsubset(I)}]);
            data(:,:,:,I) = nif.dat(bounds{:});
        end
    else
        for I = 1:length(subjsubset)
            img = spm_read_vols(spm_vol([directory,subfilenames{subjsubset(I)}]));
            data(:,:,:,I) = img(bounds{:});
        end
    end
else
    data = zeros([prod(Dim), nsubj]);
    if usenif == 1
        for I = 1:length(subjsubset)
            nif = nifti([directory,subfilenames{subjsubset(I)}]);
            bounded_nif = nif.dat(bounds{:});
            data(:,I) = bounded_nif(:);
        end
    else
        for I = 1:length(subjsubset)
            img = spm_read_vols(spm_vol([directory,subfilenames{subjsubset(I)}]));
            img = img(bounds{:});
            data(:,I) = img(:);
        end
    end
end

end
