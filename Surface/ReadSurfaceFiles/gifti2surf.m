function [ srf ] = gifti2surf( path4gifti, path4giftiright )
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
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

clear srf
if nargin == 2
    srf.lh = gifti2surf(path4gifti);
    srf.rh = gifti2surf(path4giftiright);
    return
end

%%  Main Function Loop
%--------------------------------------------------------------------------
g = gifti(path4gifti);
srf.faces = g.faces;
srf.vertices = g.vertices;
srf.nfaces = length(g.faces);
srf.nvertices = length(g.vertices);

end

