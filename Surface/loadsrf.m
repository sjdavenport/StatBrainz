function srf = loadsrf( surface_id, surface_type )
% LOADSRF Loads surface data based on specified surface ID and type.
%
%   srf = loadsrf(surface_id, surface_type) loads surface data using the
%   specified surface ID and type.
%--------------------------------------------------------------------------
% ARGUMENTS
%  surface_id: one of 'fs3', 'fs4', 'fs5', 'fs6', 'fs7'
%  surface_type: one of 'white', 'pial', 'sphere', 'inflated'
%--------------------------------------------------------------------------
% OUTPUT
%   srf             - Loaded surface data structure.
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

if strcmp(surface_id, 'bert')
    srf_dir = 'C:\Users\12SDa\davenpor\Data\Surface\freesurfer_files\bert\surf\';
    srf = fs2surf([srf_dir, 'lh.', surface_type], [srf_dir, 'rh.', surface_type]);
    return
end

if strcmp(surface_id, 'hcp')
    srf_dir = 'C:\Users\12SDa\davenpor\davenpor\Toolboxes\StatBrainz\BrainImages\Gifti_files\';
    srf = gifti2surf([srf_dir, 'S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii'], [srf_dir, 'S1200.R.inflated_MSMAll.32k_fs_LR.surf.gii']);
    return
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

