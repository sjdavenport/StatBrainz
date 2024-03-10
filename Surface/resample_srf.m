function resampled_data = resample_srf( surface_data, srfin, srfout, intertype )
% RESAMPLE_SRF Resamples surface data from one surface to another.
%
%   resampled_data = resample_srf(surface_data, srfin, srfout, intertype)
%   resamples surface data from the input surface 'srfin' to the output
%   surface 'srfout' using the specified interpolation type 'intertype'.
%
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       surface_data  - Input surface data to be resampled.
%       srfin         - Input surface structure.
%       srfout        - Output surface structure.
%       intertype     - Interpolation type (default: 'nn' or 'nearestneighbour').
%   Optional
%--------------------------------------------------------------------------
% OUTPUT
%   resampled_data   - Resampled surface data on the output surface.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'intertype', 'var' )
   % Default value
   intertype = 'nn';
end

%%  Main Function Loop
%--------------------------------------------------------------------------

lrh = 0;
nnindices = resample_srf_nn(srfin, srfout);
clear resampled_data
if isfield(surface_data, 'lh')
    resampled_data.lh = surface_data.lh(nnindices.lh);
    lrh = 1;
end
if isfield(surface_data, 'lh')
    resampled_data.rh = surface_data.lh(nnindices.rh);
    lrh = 1;
end

if lrh == 0
    if strcmp(intertype, 'nn') || strcmp(intertype, 'nearestneighbour')
        nn_indices = dsearchn(srfin.vertices,srfout.vertices);
        resampled_data = surface_data(nn_indices);
    end
end

end

