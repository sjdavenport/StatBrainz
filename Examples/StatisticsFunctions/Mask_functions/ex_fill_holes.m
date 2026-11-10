%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the fill_holes function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% A square with a hole in the middle
BW = zeros(7); BW(2:6,2:6) = 1; BW(4,4) = 0;
fill_holes( BW )

%%
% A ring: the inside is filled, the outside is not
BW = MkRadImg([50, 50], [25.5, 25.5]);
BW = (BW <= 15) & (BW >= 12);
subplot(1,2,1); imagesc(BW)
subplot(1,2,2); imagesc(fill_holes( BW ))

%%
% Background that touches the border is not a hole
BW = zeros(6); BW(2:5,2:5) = 1; BW(3:4,3:6) = 0;
fill_holes( BW )
