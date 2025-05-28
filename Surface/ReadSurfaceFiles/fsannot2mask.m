function [mask, region_names] = fsannot2mask( annotfile, region )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% % EXAMPLES
% annotfile = '/Users/sdavenport/Documents/Code/MATLAB/MyPackages/StatBrainz/BrainImages/Surface/fsaverage4/lh.aparc.annot';
% [mask, region_names] = fsannot2mask( annotfile, 'medial_wall' );
% srf = loadsrf('fs4', 'white')
% srfplot(srf.lh, mask, 1)
% mask = fsannot2mask( annotfile, 'bankssts' );
% srf = loadsrf('fs4', 'white')
% srfplot(srf.lh, mask, 0)
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
[~,vertex_labels,region_codes] = read_annotation(annotfile);
region_names = region_codes.struct_names;
encoded_ids = region_codes.table(:,5);

if strcmp(region, 'medial_wall')
    region = 'unknown';
end

region_idx = 0;
for I = 1:length(region_names)
    if strcmp(region_names{I}, region)
        region_idx = I;
        % break
    end
end

if region_idx == 0 
    error('region not found\n')
end

mask = (vertex_labels == encoded_ids(region_idx));

end

