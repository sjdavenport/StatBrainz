%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the getBrainRegionNames function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xml_file = [statbrainz_maindir, 'Atlases/HarvardOxford/HarvardOxford-Cortical.xml'];
names = getBrainRegionNames(xml_file);
for name = names
    disp(name)
end
getBrainRegionNames(xml_file);
