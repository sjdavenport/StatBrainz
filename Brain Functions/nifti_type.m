function file_type = nifti_type( files )
% NIFTI_TYPE( files ) determines whether the files are .nii, .nii.gz or
% some other file
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  files        an nvals by 1 cell array where each entry is a string
%               referring to file name to be classified
%--------------------------------------------------------------------------
% OUTPUT
%  file_type    0/1/2. 0 means not .nii or .nii.gz, 1 means .nii.gz, 2
%               means .nii
%--------------------------------------------------------------------------
% EXAMPLES
% nifti_type( {'nii', '.nii', '.nii.gz.asdf'})
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
% Initialize file_type vector
file_type = zeros(length(files), 1);

% Assign the nifti file type
for I = 1:length(files)
    if contains(files{I}, '.nii.gz')
        file_type(I) = 1;
    elseif contains(files{I}, '.nii')
        file_type(I) = 2;
    else
        file_type(I) = 0;
    end
end

end

