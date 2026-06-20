%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the fsannot2mask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

annotfile = '/Users/sdavenport/Documents/Code/MATLAB/MyPackages/StatBrainz/BrainImages/Surface/fsaverage4/lh.aparc.annot';
[mask, region_names] = fsannot2mask( annotfile, 'medial_wall' );
srf = loadsrf('fs4', 'white')
srfplot(srf.lh, mask, 1)
mask = fsannot2mask( annotfile, 'bankssts' );
srf = loadsrf('fs4', 'white')
srfplot(srf.lh, mask, 0)
