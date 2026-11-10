%% test_imgload
% Tests of the imgload function.
%--------------------------------------------------------------------------

%% MNImask is a logical mask in 2mm space
MNImask = imgload('MNImask');
assert(isequal(size(MNImask), [91, 109, 91]))
assert(islogical(MNImask))
assert(nnz(MNImask) > 0)

%% Same result with and without the extension
assert(isequal(imgload('MNImask.nii'), MNImask))

%% A .nii.gz image that is not a mask is returned as double
MNIbrain = imgload('MNIbrain.nii.gz');
assert(isequal(size(MNIbrain), [91, 109, 91]))
assert(isa(MNIbrain, 'double'))
assert(isequal(imgload('MNIbrain'), MNIbrain))

%% 1mm images
assert(isequal(size(imgload('MNIbrain1mm.nii.gz')), [182, 218, 182]))

%% Full path to a file outside BrainImages
file = fullfile(tempdir, 'test_imgload_tmp');
x = reshape(1:(91*109*91), [91, 109, 91]);
imgsave( x, 'test_imgload_tmp', tempdir )
assert(isequal(imgload([file, '.nii']), x))
delete([file, '.nii'])

%% A file that does not exist gives an error
errored = 0;
try
    imgload('this_file_does_not_exist');
catch
    errored = 1;
end
assert(errored == 1)
