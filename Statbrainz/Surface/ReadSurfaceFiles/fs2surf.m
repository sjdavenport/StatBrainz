function srf = fs2surf( path4fs, path4fsright)
% FS2SURF Converts a FreeSurfer geometry file to a surface structure.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  path4fs        path to the left (or single) hemisphere FreeSurfer file
% Optional
%  path4fsright   path to the right hemisphere FreeSurfer file; if
%                 provided, returns a bilateral struct with .lh and .rh
%--------------------------------------------------------------------------
% OUTPUT
%  srf  surface structure with .faces, .vertices, .nfaces, .nvertices
%       fields; bilateral struct with .lh/.rh if path4fsright is supplied
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

clear srf
if nargin == 2
    srf.lh = fs2surf( path4fs);
    srf.lh.hemi = 'lh';
    srf.rh = fs2surf( path4fsright);
    srf.rh.hemi = 'rh';
    return
end

%%  Main Function Loop
%--------------------------------------------------------------------------
[vertices, faces] = read_fs_geometry(path4fs);
srf.faces = faces;
srf.vertices = vertices;
srf.nfaces = length(faces);
srf.nvertices = length(vertices);

end

