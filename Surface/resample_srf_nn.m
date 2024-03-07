function nnindices = resample_srf_nn( srfin, srfout )
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

