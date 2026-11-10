%% test_imgsave
% Tests of the imgsave function.
%--------------------------------------------------------------------------
rng(1)
directory = tempname;
mkdir(directory);
x = randn(91, 109, 91);

%% Saving and reloading gives the same array
imgsave( x, 'save1', directory )
file = fullfile(directory, 'save1.nii');
assert(exist(file, 'file') == 2)
assert(isequal(double(niftiread(file)), x))

%% The .nii extension is not added twice
imgsave( x, 'save2.nii', directory )
assert(exist(fullfile(directory, 'save2.nii'), 'file') == 2)
assert(exist(fullfile(directory, 'save2.nii.nii'), 'file') == 0)

%% A vector of length 91*109*91 is reshaped
imgsave( x(:), 'save3', directory )
y = double(niftiread(fullfile(directory, 'save3.nii')));
assert(isequal(size(y), [91, 109, 91]))
assert(isequal(y, x))
imgsave( x(:)', 'save4', directory )
assert(isequal(double(niftiread(fullfile(directory, 'save4.nii'))), x))

%% Other array sizes
z = rand(10, 12, 8);
imgsave( z, 'save5', directory )
assert(isequal(double(niftiread(fullfile(directory, 'save5.nii'))), z))

%% Logical input is saved as double
imgsave( x > 0, 'save6', directory )
assert(isequal(double(niftiread(fullfile(directory, 'save6.nii'))), double(x > 0)))

%% Default directory is the current directory
olddir = pwd;
cd(directory)
imgsave( z, 'save7' )
cd(olddir)
assert(exist(fullfile(directory, 'save7.nii'), 'file') == 2)

%% A directory that does not exist gives an error
errored = 0;
try
    imgsave( x, 'save8', fullfile(directory, 'not_a_dir') )
catch
    errored = 1;
end
assert(errored == 1)

rmdir(directory, 's');
