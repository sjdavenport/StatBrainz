%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the findstrings function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find the entries that contain a substring
names = {'Left Amygdala', 'Right Amygdala', 'Left Hippocampus'};
[indices, matches] = findstrings(lower(names), 'amygdala')

%% No entries match
[indices, matches] = findstrings(lower(names), 'thalamus')

%% Search the region names of the Harvard-Oxford cortical atlas
xml_file = [statbrainz_maindir, 'Atlases/HarvardOxford/HarvardOxford-Cortical.xml'];
names = getBrainRegionNames(xml_file);
[indices, matches] = findstrings(lower(names), 'frontal')
