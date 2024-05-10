function nnindices = resample_srf_nn( srfin, srfout )
%   nnindices = resample_srf_nn(srfin, srfout) computes nearest neighbor
%   indices for resampling surface data from the input surface 'srfin' to
%   the output surface 'srfout' using nearest neighbor interpolation.
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       srfin         - Input surface structure.
%       srfout        - Output surface structure.
%--------------------------------------------------------------------------
% OUTPUT
%   nnindices - A vector giving the nearest neighbor indices for resampling.
%--------------------------------------------------------------------------
% EXAMPLES
% See test_resample_srf.nn.
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------

lrh = 0;
if isfield(srfin, 'lh')
    nnindices.lh = resample_srf_nn( srfin.lh, srfout.lh);
    lrh = 1;
end
if isfield(srfin, 'lh')
    nnindices.rh = resample_srf_nn( srfin.rh, srfout.rh );
    lrh = 1;
end

if lrh == 0
    nnindices = dsearchn(srfin.vertices,srfout.vertices);
end

end

