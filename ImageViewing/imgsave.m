function imgsave( array, filename, directory, header)
% IMGSAVE( array, filename, directory, header) saves a [91,109,91] array 
% as a nifti file. Note it can also take a 91*109*91 vector an as input as
% it will automatically reshape it to be the right size.
%--------------------------------------------------------------------------
% ARGUMENTS
% array     is the [91,109,91] array to be saved.
% filename  is the name of the file that you would like to save.
% directory is the directory that you would like to save to. Note that
%           setting this to be 2 puts everything in the CSI directory.
% header    is the information about the file. If you're saving lots of 
%           images then its better to provide this so that it doesn't have 
%           to be loaded each time.
%--------------------------------------------------------------------------
% OUTPUT
% A saved image at the desired location.
%--------------------------------------------------------------------------
% EXAMPLES
% %At home:
% global lobal
% imgsave( zeros(91,109,91), 'examplesave', strcat(lobal,'TomsMiniProject/Matlab/' ) )
% % This saves the image to TomsMiniProject/Matlab/examplesave.nii in the
% % lobal directory.
% global CSI
% imgsave( zeros(91,109,91), 'examplesave', CSI )
% %The above saves to the CSI directory.
%
% Saving data on your computer
% imgsave( zeros(91,109,91), 'examplesave', 3 )
%--------------------------------------------------------------------------
if nargin < 3
    directory = 2;
end

global lobal
global parloc
global CSI
global where_davenpor
global stdsize
global bsloc
if directory == 1
    directory = parloc;
elseif directory == 2
    directory = CSI;
elseif directory == 3
    %Ie local saving of images.
    directory = strcat(where_davenpor, 'exampledata');
elseif directory == 4
    %Large Files
    directory = strcat(parloc, 'largefiles/');
end

if ~(exist(directory, 'dir') == 7)
    error('This directory does not exist')
end

if ~strcmp(directory(end), '/')
    directory = strcat(directory, '/');
    %     error('USER: this needs to be a valid directory and end in /.')
end

if (nargin < 4)
    header = spm_vol([bsloc, 'BrainImages/ExData.nii']);
%     if ~strcmp(TYPE,'jala')
%         header = spm_vol(strcat(lobal,'TomsMiniProject/Matlab/ExData.nii'));
%     else
%         header = spm_vol('/vols/Scratch/ukbiobank/nichols/SelectiveInf/BrainStat/BrainImages/MNImask.nii');
%     end
end

if isequal(size(array), [1, 902629]) || isequal(size(array), [902629, 1])
    array = reshape(array, stdsize);
end

file = strcat(directory, filename, '.nii');
header.fname = file;
header.private.dat.fname = file;
spm_write_vol(header, array)

end

