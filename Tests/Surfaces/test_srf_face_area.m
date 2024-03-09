%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srf_face_area function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf4white = loadsrf('fs4', 'white');
fa_white = srf_face_area(srf4white.lh);

srfplot(srf4white.lh, fa)

%%
srf4sphere = loadsrf('fs4', 'sphere');
fa_sphere4 = srf_face_area(srf4sphere.lh);

srfplot(srf4sphere.lh, fa_sphere4)
sum(fa_sphere4)
%%
srf5sphere = loadsrf('fs5', 'sphere');
fa_sphere5 = srf_face_area(srf5sphere.lh);

srfplot(srf5sphere.lh, fa_sphere5)
sum(fa_sphere5)