%% test_region_bndry2D
% Tests for region_bndry2D: outer boundaries of regions on slice 80 of the
% doubled (182 x 218 x 182) image.
%--------------------------------------------------------------------------
mask = zeros(91, 109, 91); mask(20:70, 20:90, 30:60) = 1;
region1 = zeros(91, 109, 91); region1(20:40, 20:90, 30:60) = 1;
region2 = zeros(91, 109, 91); region2(41:70, 20:90, 30:60) = 1;

% Hand computed answer: only the row of region2 next to region1 (row 81 of
% the doubled image) is a boundary inside the mask; the boundary of region2
% lies in region1 or outside the mask, so it is excluded.
expected = zeros(182, 218); expected(81, 39:180) = 1;

%% One region inside the full mask has no boundary in the mask
out = region_bndry2D( {mask}, mask );
assert( all( out(:) == 0 ) )

%% Two regions give the boundary between them (values)
out = region_bndry2D( {region1, region2}, mask );
assert( isequal( out(:,:,1), expected ) )

%% Output is a 2D image
assert( isequal( size(out), [182 218] ) )
