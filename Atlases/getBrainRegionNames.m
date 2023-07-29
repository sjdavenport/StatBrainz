function names = getBrainRegionNames(xml_file)
%GETBRAINREGIONNAMES Extracts the names of brain regions from an XML file
%
%   NAMES = GETBRAINREGIONNAMES(XML_FILE) extracts the names of brain
%   regions from the XML file specified by XML_FILE and returns them as a
%   cell array of strings.
%
%   Inputs:
%   - XML_FILE: a string specifying the name of the XML file
%
%   Outputs:
%   - NAMES: a cell array of strings, where each element contains the name
%     of a brain region
%
%   Example:
%       names = getBrainRegionNames('C:\Users\12SDa\davenpor\davenpor\Toolboxes\BrainStat\Atlases\HarvardOxford\HarvardOxford-Cortical.xml');
%       for name = names
%           disp(name)
%       end
%       getBrainRegionNames('C:\Users\12SDa\davenpor\davenpor\Toolboxes\BrainStat\Atlases\HarvardOxford\HarvardOxford-Cortical.xml');
%   See also PARSEXML, REGEXP

    % Read in the XML file as a cell array of strings
    lines = readlines(xml_file);

    % Initialize a cell array to hold the brain region names
    names = {};

    % Use a regular expression to extract the brain region names from the
    % 'label' elements
    for i = 1:length(lines)
        line = lines{i};
        matches = regexp(line, '<label.*>(.*)</label>', 'tokens');
        if ~isempty(matches)
            names{end+1} = matches{1}{1};
        end
    end
end
