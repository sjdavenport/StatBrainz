function resampled_data = resample_srf( surface_data, srfin, srfout, intertype )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
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
clear data
if isfield(surface_data, 'lh')
    resampled_data.lh = resample_srf( surface_data.lh, srfin.lh, srfout.lh, intertype );
    lrh = 1;
end
if isfield(surface_data, 'lh')
    resampled_data.rh = resample_srf( surface_data.rh, srfin.rh, srfout.rh, intertype );
    lrh = 1;
end

if lrh == 0
    if strcmp(intertype, 'nn') || strcmp(intertype, 'nearestneighbour')
        nn_indices = dsearchn(srfin.vertices,srfout.vertices);
        resampled_data = surface_data(nn_indices);
    end
end

end

