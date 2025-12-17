function tree = xml_parser(input)
% XML_PARSER Parse XML document and return structured tree
%   TREE = XML_PARSER(INPUT) parses an XML string or file and returns
%   a structure array representing the XML tree.
%
%   INPUT can be either:
%     - A string containing XML content (detected by presence of '<')
%     - A filename containing XML content
%
%   TREE is a structure array with fields:
%     - type: 'element' or 'chardata'
%     - value: element name or text content
%     - attributes: structure array with 'key' and 'value' fields
%     - children: array of UIDs of child nodes
%     - uid: unique identifier for this node
%     - parent: UID of parent node (empty for root)

    % Validate input
    if nargin ~= 1 || ~ischar(input)
        error('Input must be a string');
    end
    
    % Get XML data
    xml = get_data(input);
    
    % Initialize output structure
    tree = struct('type', {}, 'value', {}, 'attributes', {}, ...
                  'children', {}, 'uid', {}, 'parent', {});
    
    % Parse the XML
    tree = parse_xml(xml);
end

function xml = get_data(input)
% GET_DATA Load XML from string or file
    
    if isempty(input)
        error('Empty XML document');
    end
    
    % Detect if input is a filename (no '<' character)
    is_filename = ~contains(input, '<');
    
    if is_filename
        % Try to read as file
        if ~isfile(input)
            error('Cannot read XML document: file not found');
        end
        
        fid = fopen(input, 'r');
        if fid == -1
            error('Cannot read XML document');
        end
        
        xml = fread(fid, '*char')';
        fclose(fid);
        
        if isempty(xml)
            error('Empty XML document');
        end
    else
        xml = input;
    end
end

function tree = parse_xml(xml)
% PARSE_XML Main XML parsing function using simple state machine
    
    % Initialize tree
    tree = struct('type', {}, 'value', {}, 'attributes', {}, ...
                  'children', {}, 'uid', {}, 'parent', {});
    
    % Parser state
    uid_counter = 0;
    current_node = 0;  % UID of current element (0 = root level)
    
    % Stack for nested elements
    node_stack = [];
    
    % Parse position
    pos = 1;
    len = length(xml);
    
    while pos <= len
        % Skip whitespace at root level
        if current_node == 0
            while pos <= len && isspace(xml(pos))
                pos = pos + 1;
            end
            if pos > len
                break;
            end
        end
        
        % Check for tag start
        if xml(pos) == '<'
            % Determine tag type
            if pos + 1 <= len && xml(pos + 1) == '/'
                % Closing tag
                [tag_name, pos] = parse_closing_tag(xml, pos);
                
                % Pop from stack
                if ~isempty(node_stack)
                    current_node = node_stack(end);
                    node_stack(end) = [];
                else
                    current_node = 0;
                end
                
            elseif pos + 1 <= len && xml(pos + 1) == '?'
                % Processing instruction - skip it
                pos = find_char(xml, '?>', pos) + 2;
                
            elseif pos + 3 <= len && strcmp(xml(pos:pos+3), '<!--')
                % Comment - skip it
                pos = find_char(xml, '-->', pos) + 3;
                
            else
                % Opening tag
                [tag_name, attrs, is_self_closing, pos] = parse_opening_tag(xml, pos);
                
                % Create new element node
                uid_counter = uid_counter + 1;
                node_idx = uid_counter;
                
                tree(node_idx).type = 'element';
                tree(node_idx).value = tag_name;
                tree(node_idx).attributes = attrs;
                tree(node_idx).children = [];
                tree(node_idx).uid = uid_counter;
                
                if current_node > 0
                    tree(node_idx).parent = current_node;
                    tree(current_node).children(end+1) = uid_counter;
                else
                    tree(node_idx).parent = [];
                end
                
                if ~is_self_closing
                    % Push current node to stack
                    node_stack(end+1) = current_node;
                    current_node = uid_counter;
                end
            end
            
        else
            % Character data
            text_start = pos;
            text_end = pos;
            
            % Find end of character data (next '<')
            while text_end <= len && xml(text_end) ~= '<'
                text_end = text_end + 1;
            end
            text_end = text_end - 1;
            
            if text_end >= text_start
                char_data = xml(text_start:text_end);
                
                % Decode XML entities
                char_data = decode_entities(char_data);
                
                % Only create node if not just whitespace
                if current_node > 0 || ~all(isspace(char_data))
                    % Trim whitespace if inside element
                    if current_node > 0
                        char_data = strtrim(char_data);
                    end
                    
                    if ~isempty(char_data)
                        % Create character data node
                        uid_counter = uid_counter + 1;
                        node_idx = uid_counter;
                        
                        tree(node_idx).type = 'chardata';
                        tree(node_idx).value = char_data;
                        tree(node_idx).attributes = struct('key', {}, 'value', {});
                        tree(node_idx).children = [];
                        tree(node_idx).uid = uid_counter;
                        
                        if current_node > 0
                            tree(node_idx).parent = current_node;
                            tree(current_node).children(end+1) = uid_counter;
                        else
                            tree(node_idx).parent = [];
                        end
                    end
                end
            end
            
            pos = text_end + 1;
        end
    end
end

function [tag_name, attrs, is_self_closing, pos] = parse_opening_tag(xml, pos)
% PARSE_OPENING_TAG Parse an opening XML tag
    
    % Skip '<'
    pos = pos + 1;
    
    % Parse tag name
    name_start = pos;
    while pos <= length(xml) && ~isspace(xml(pos)) && xml(pos) ~= '>' && xml(pos) ~= '/'
        pos = pos + 1;
    end
    tag_name = xml(name_start:pos-1);
    
    % Skip whitespace
    while pos <= length(xml) && isspace(xml(pos))
        pos = pos + 1;
    end
    
    % Parse attributes
    attrs = struct('key', {}, 'value', {});
    
    while pos <= length(xml) && xml(pos) ~= '>' && xml(pos) ~= '/'
        % Parse attribute name
        attr_name_start = pos;
        while pos <= length(xml) && ~isspace(xml(pos)) && xml(pos) ~= '='
            pos = pos + 1;
        end
        attr_name = xml(attr_name_start:pos-1);
        
        % Skip whitespace and '='
        while pos <= length(xml) && (isspace(xml(pos)) || xml(pos) == '=')
            pos = pos + 1;
        end
        
        % Parse attribute value
        if pos <= length(xml) && (xml(pos) == '"' || xml(pos) == '''')
            quote = xml(pos);
            pos = pos + 1;
            attr_value_start = pos;
            while pos <= length(xml) && xml(pos) ~= quote
                pos = pos + 1;
            end
            attr_value = xml(attr_value_start:pos-1);
            pos = pos + 1; % Skip closing quote
            
            % Decode entities in attribute value
            attr_value = decode_entities(attr_value);
            
            % Add attribute
            idx = length(attrs) + 1;
            attrs(idx).key = attr_name;
            attrs(idx).value = attr_value;
        end
        
        % Skip whitespace
        while pos <= length(xml) && isspace(xml(pos))
            pos = pos + 1;
        end
    end
    
    % Check for self-closing tag
    is_self_closing = false;
    if pos <= length(xml) && xml(pos) == '/'
        is_self_closing = true;
        pos = pos + 1;
    end
    
    % Skip '>'
    if pos <= length(xml) && xml(pos) == '>'
        pos = pos + 1;
    end
end

function [tag_name, pos] = parse_closing_tag(xml, pos)
% PARSE_CLOSING_TAG Parse a closing XML tag
    
    % Skip '</'
    pos = pos + 2;
    
    % Parse tag name
    name_start = pos;
    while pos <= length(xml) && xml(pos) ~= '>'
        pos = pos + 1;
    end
    tag_name = strtrim(xml(name_start:pos-1));
    
    % Skip '>'
    pos = pos + 1;
end

function pos = find_char(xml, pattern, start_pos)
% FIND_CHAR Find position of pattern in string
    idx = strfind(xml(start_pos:end), pattern);
    if isempty(idx)
        pos = length(xml) + 1;
    else
        pos = start_pos + idx(1) - 1;
    end
end

function str = decode_entities(str)
% DECODE_ENTITIES Decode common XML entities
    str = strrep(str, '&lt;', '<');
    str = strrep(str, '&gt;', '>');
    str = strrep(str, '&amp;', '&');
    str = strrep(str, '&quot;', '"');
    str = strrep(str, '&apos;', '''');
    
    % Handle numeric character references (&#NNN; and &#xHHH;)
    % Decimal references
    pattern = '&#(\d+);';
    matches = regexp(str, pattern, 'tokens');
    for i = 1:length(matches)
        num = str2double(matches{i}{1});
        if num <= 127  % ASCII range
            str = regexprep(str, ['&#' matches{i}{1} ';'], char(num), 'once');
        end
    end
    
    % Hexadecimal references
    pattern = '&#x([0-9A-Fa-f]+);';
    matches = regexp(str, pattern, 'tokens');
    for i = 1:length(matches)
        num = hex2dec(matches{i}{1});
        if num <= 127  % ASCII range
            str = regexprep(str, ['&#x' matches{i}{1} ';'], char(num), 'once');
        end
    end
end