function out = box_dilate( BW, radius )
% BOX_DILATE morphologically dilates a binary array with a solid (box)
% structuring element, without the Image Processing Toolbox.
%--------------------------------------------------------------------------
% A voxel of the output is true if any voxel within radius steps of it (in
% each dimension independently, i.e. a (2*radius+1) box) is true in the
% input. This matches imdilate( BW, ones( (2*radius+1)*ones(1,D) ) ).
% The box structuring element is separable, so the dilation is applied one
% dimension at a time via a sliding OR.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  BW      a logical array of any dimension
%  radius  the half-width of the box structuring element (a non-negative
%          integer). radius 1 gives a 3x3(x3) box, etc.
%--------------------------------------------------------------------------
% OUTPUT
%  out     the dilated logical array, the same size as BW
%--------------------------------------------------------------------------
% EXAMPLES
% mask = zeros(5); mask(3,3) = 1;
% box_dilate( mask, 1 )
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

out = BW ~= 0;

if radius <= 0
    return
end

D = ndims( out );
for d = 1:D
    n = size( out, d );
    if n == 1
        continue   % nothing to dilate along a singleton dimension
    end
    shifted = out;
    % OR together copies of the array shifted by -radius..radius along dim d
    for k = 1:radius
        shifted = shifted | shift_dim( out, k, d ) | shift_dim( out, -k, d );
    end
    out = shifted;
end

end

%==========================================================================
function y = shift_dim( x, k, d )
% Shift array x by k positions along dimension d, padding the vacated region
% with false (so voxels shifted in from outside the array are background).

sz = size( x );
n  = sz(d);
y  = false( sz );

idx_src = repmat( {':'}, 1, ndims(x) );
idx_dst = idx_src;

if k > 0
    if k >= n, return, end
    idx_src{d} = 1:(n-k);
    idx_dst{d} = (1+k):n;
else
    k = -k;
    if k >= n, return, end
    idx_src{d} = (1+k):n;
    idx_dst{d} = 1:(n-k);
end

y( idx_dst{:} ) = x( idx_src{:} );

end
