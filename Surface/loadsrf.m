function srf = loadsrf( surface_id, surface_type )
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
if ~exist( 'surface_id', 'var' )
   % Default value
   surface_id = 'fs5';
end

if ~exist( 'surface_type', 'var' )
   % Default value
   surface_type = 'white';
end

%%  Main Function Loop
%--------------------------------------------------------------------------
% Identify where the StatBrainz main directory is located
sb_dir = statbrainz_maindir;
srf_dir = [sb_dir, 'BrainImages/Surface/'];

accepted_surface_types = {'white', 'pial', 'sphere', 'inflated'};
accepted_surface_ids = {'fs3', 'fs4', 'fs5', 'fs6', 'fs7'};

if ~any(any(ismember(accepted_surface_types, surface_type)))
    error('The supplied surface_type is not available')
end
if ~any(any(ismember(accepted_surface_ids, surface_id)))
    error('The supplied surface_id is not available')
end

if strcmp(surface_id(1:2), 'fs') && length(surface_id) == 3
    surface_id = ['fsaverage', surface_id(3)];
end

temp = load([srf_dir, surface_id, '/', surface_type, '.mat']);
srf = temp.srf;
% srf = fs2surf([srf_dir, surface_id, '.lh.', surface_type], [srf_dir, surface_id, '.rh.', surface_type]);

end

