%% test_getBrainRegionNames
% Tests of the getBrainRegionNames function.
%--------------------------------------------------------------------------
HOdir = [statbrainz_maindir, 'Atlases/HarvardOxford/'];

%% Harvard-Oxford cortical atlas
names = getBrainRegionNames([HOdir, 'HarvardOxford-Cortical.xml']);
assert(iscell(names) && length(names) == 48)
assert(strcmp(names{1}, 'Frontal Pole'))

%% Harvard-Oxford sub-cortical atlas
names = getBrainRegionNames([HOdir, 'HarvardOxford-Subcortical.xml']);
assert(length(names) == 21)
assert(strcmp(names{10}, 'Left Amygdala'))
assert(strcmp(names{21}, 'Right Accumbens'))

%% One name for each label line in the file
xml_file = [statbrainz_maindir, 'Atlases/Talairach/Talairach.xml'];
names = getBrainRegionNames(xml_file);
txt = fileread(xml_file);
assert(length(names) == length(strfind(txt, '</label>')))
assert(all(cellfun(@ischar, names)))
