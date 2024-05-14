function [ region_masks, region_names ] = atlas_masks( atlas )
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
% Copyright (C) - 2024 - Samuel Davenport
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
sbdir = statbrainz_maindir;
if strcmp(atlas, 'HOc')
    atlas_loc = [sbdir,'Atlases/HarvardOxford/'];
    a = load([atlas_loc, 'atlas_region_masks.mat']);
    region_names = a.names;
    region_masks = a.region_masks;
end

end

