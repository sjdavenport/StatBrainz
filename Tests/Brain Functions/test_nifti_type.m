%% test_nifti_type
% Tests of the nifti_type function.
%--------------------------------------------------------------------------

%% Known values
file_type = nifti_type({'nii', 'img.nii', 'img.nii.gz', 'img.txt'});
assert(isequal(file_type, [0; 2; 1; 0]))

%% Output is a column vector with one entry per file
file_type = nifti_type({'a.nii'; 'b.nii.gz'; 'c'});
assert(isequal(size(file_type), [3, 1]))
assert(isequal(file_type, [2; 1; 0]))

%% Example from the help block
assert(isequal(nifti_type({'nii', '.nii', '.nii.gz.asdf'}), [0; 2; 1]))

%% Empty input
assert(isempty(nifti_type({})))
