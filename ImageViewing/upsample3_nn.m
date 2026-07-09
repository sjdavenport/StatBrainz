function out = upsample3_nn( vol, scale )
% UPSAMPLE3_NN resizes a 3D array by a scale factor using nearest neighbour
% interpolation, without the Image Processing Toolbox (a replacement for
% imresize3( vol, scale ) for mask / label data).
%--------------------------------------------------------------------------
% The output size is round( scale .* size(vol) ), matching imresize3. Each
% output voxel takes the value of the nearest input voxel, so the result
% stays a valid mask / label array (no interpolated intermediate values).
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  vol     a 3D array
%  scale   a scalar scale factor, or a 1x3 vector of per-dimension factors
%--------------------------------------------------------------------------
% OUTPUT
%  out     the resized array
%--------------------------------------------------------------------------
% EXAMPLES
% vol = zeros(4,4,4); vol(2,2,2) = 1;
% size( upsample3_nn( vol, 2 ) )
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

insize = size( vol );
if numel( insize ) < 3
    insize(end+1:3) = 1;
end

if isscalar( scale )
    scale = scale * [1 1 1];
end

outsize = round( scale .* insize );

% For each output index, find the nearest source index. This uses the same
% pixel-centre convention as imresize's nearest method: map an output centre
% back to input coordinates and round.
i = nearest_index( outsize(1), insize(1) );
j = nearest_index( outsize(2), insize(2) );
k = nearest_index( outsize(3), insize(3) );

out = vol( i, j, k );

end

%==========================================================================
function src = nearest_index( nout, nin )
% Nearest source indices (1-based) for nout output samples drawn from nin
% input samples, using centre-aligned sampling.

scale = nout / nin;
u = (1:nout);
src = ceil( u / scale );                  % match imresize3 nearest mapping
src = min( max( src, 1 ), nin );          % clamp to valid range

end
