%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the loadmask function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = loadmask( 'fs6', 'medial_wall' );
srf = loadsrf('fs6');

subplot(1,2,1)
srfplot(srf.rh, mask.rh, 1)
subplot(1,2,2)
srfplot(srf.lh, mask.lh, 1)
