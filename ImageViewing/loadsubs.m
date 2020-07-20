function data = loadsubs( subjsubset, directory, usenif, as3D, subfilenames  )
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
% exsubs = loadsubs( 3:5,'C:/Users/12Sda/davenpor/data/RestingStateData/Oulu/', 0, 1);
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

std_size = [91,109,91];
nsubj = length(subjsubset);

if as3D == 1
    data = zeros([std_size, nsubj]);
    if usenif == 1
        for I = 1:length(subjsubset)
            nif = nifti([directory,subfilenames{subjsubset(I)}]);
            data(:,:,:,I) = nif.dat(:,:,:);
        end
    else
        for I = 1:length(subjsubset)
            data(:,:,:,I) = spm_read_vols(spm_vol([directory,subfilenames{subjsubset(I)}]));
        end
    end
else
    data = zeros([prod(std_size), nsubj]);
    if usenif == 1
        for I = 1:length(subjsubset)
            nif = nifti([directory,subfilenames{subjsubset(I)}]);
            data(:,I) = nif.dat(:);
        end
    else
        for I = 1:length(subjsubset)
            img = spm_read_vols(spm_vol([directory,subfilenames{subjsubset(I)}]));
            data(:,I) = img(:);
        end
    end
end

end
