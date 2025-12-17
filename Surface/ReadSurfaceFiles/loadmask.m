function [ mask ] = loadmask( srf, maskname )
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
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
sbdir = '/Users/sdavenport/Documents/Code/MATLAB/MyPackages/StatBrainz/';

srf = strrep(srf, 'fs', 'fsaverage');

annotfilelh = [srf, '/lh.aparc.annot'];
annotfilerh = [srf, '/rh.aparc.annot'];

clear mask
mask.lh = fsannot2mask( annotfilelh, maskname );
mask.rh = fsannot2mask( annotfilerh, maskname );

end

