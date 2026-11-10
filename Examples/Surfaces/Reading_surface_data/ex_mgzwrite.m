%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the mgzwrite function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mgzwrite needs save_mgh2 and MRIread from the FreeSurfer MATLAB folder
% ($FREESURFER_HOME/matlab) on the path. Writing .mgz files uses gzip.

%% Write a volume to an .mgh file
vol = fast_conv(randn([50,50,50]), 3, 3);
subplot(1,2,1)
imagesc(vol(:,:,25))
axis off image
title('Original')
mgzwrite(vol, [tempdir, 'ex_mgzwrite.mgh'])

%% Write a volume to an .mgz file and load it
mgzwrite(vol, [tempdir, 'ex_mgzwrite.mgz'])
testim = MRIread([tempdir, 'ex_mgzwrite.mgz']);
subplot(1,2,2)
imagesc(testim.vol(:,:,25))
axis off image
title('Saved and loaded')

%% The filename must end in .mgh or .mgz
try
    mgzwrite(vol, [tempdir, 'ex_mgzwrite.nii'])
catch err
    disp(err.message)
end
