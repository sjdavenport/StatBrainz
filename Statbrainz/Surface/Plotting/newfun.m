function [ out ] = surf4( in )
% SURF4 Plots surface data in a 2x2 grid (both hemispheres, front and back).
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  in   input argument (unused in current implementation)
%--------------------------------------------------------------------------
% OUTPUT
%  out  output argument (unused in current implementation)
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
plot_compact(2,2)
for doback = [0,1]
    for hemis= {'lh', 'rh'}
        h = hemis{1};
        nexttile;
        srfplot( srf.(h), surface_data.(h), doback )
    end
end

end

