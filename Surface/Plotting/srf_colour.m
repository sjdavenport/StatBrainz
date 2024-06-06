function color_map = srf_colour( srf, region_masks, colours, background_gradient )
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
% srf = loadsrf('fs5', 'white')
% noise = srf_noise( srf, 10, 1)
% color_map = srf_colour( srf.lh, {noise.lh > 0}, {[1,0,0]} );
% srfplot(srf.lh, color_map)
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'background_gradient', 'var' )
   % Default value
   background_gradient = 0.7;
end

%%  Main Function Loop
%--------------------------------------------------------------------------

if isfield(srf, 'lh') && isfield(srf, 'rh')
    region_masks_lh = cell(1, length(region_masks));
    region_masks_rh = cell(1, length(region_masks));
    for J = 1:length(region_masks)
        region_masks_lh{J} = region_masks{J}.lh;
        region_masks_rh{J} = region_masks{J}.rh;
    end
    color_map.lh = srf_colour( srf.lh, region_masks_lh, colours );
    color_map.rh = srf_colour( srf.rh, region_masks_rh, colours );
else
    % color_map = ones(length(region_masks{1}), 3)*0.7;
    color_map = ones(length(region_masks{1}), 3)*background_gradient;
    for I = 1:length(region_masks)
        color_map(region_masks{I}, 1) = colours{I}(1);
        color_map(region_masks{I}, 2) = colours{I}(2);
        color_map(region_masks{I}, 3) = colours{I}(3);
    end
end

end

