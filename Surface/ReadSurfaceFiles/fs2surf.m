function srf = fs2surf( path4fs, path4fsright)
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

clear srf
if nargin == 2
    srf.lh = fs2surf( path4fs);
    srf.rh = fs2surf( path4fsright);
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

