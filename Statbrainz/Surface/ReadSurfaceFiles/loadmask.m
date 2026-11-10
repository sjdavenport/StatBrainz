function [ mask ] = loadmask( srf, maskname )
% LOADMASK Loads a bilateral region mask from FreeSurfer annotation files.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  srf       surface identifier string (e.g. 'fs4', 'fs5'); 'fs' prefix is
%            expanded to 'fsaverage' and used to locate .annot files
%  maskname  region name to extract (passed to fsannot2mask)
%--------------------------------------------------------------------------
% OUTPUT
%  mask  struct with .lh and .rh logical mask vectors for the region
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

