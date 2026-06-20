%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the loadbrains function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exsubs = loadsubs( 3:5,'C:/Users/12Sda/davenpor/data/RestingStateData/Oulu/', 0 );

%% As 3D
MNImask = imgload('MNImask');
exsubs = loadsubs( 3:5,'C:/Users/12Sda/davenpor/data/RestingStateData/Oulu/', 0, MNImask, 1 );
imagesc(exsubs(:,:,50,1))

%%
loadsubs( 1:2, '/vols/Scratch/ukbiobank/nichols/SelectiveInf/feat_runs/RS_2Block_warped/', 0, MNImask, 1 )
