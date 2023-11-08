function [vertices, faces, volume_info, create_stamp] = read_fs_geometry(filepath, read_metadata)
% This code is a modified version of the read_geometry function from the 
% NiBabel python package which was licensed under the MIT License.
% Copyright (c) 2009-2019 Matthew Brett <matthew.brett@gmail.com>
% Copyright (C) 2010-2013 Stephan Gerhard <git@unidesign.ch>
% Copyright (C) 2006-2014 Michael Hanke <michael.hanke@gmail.com>
% Copyright (C) 2011 Christian Haselgrove <christian.haselgrove@umassmed.edu>
% Copyright (C) 2010-2011 Jarrod Millman <jarrod.millman@gmail.com>
% Copyright (C) 2011-2019 Yaroslav Halchenko <debian@onerussian.com>
% Copyright (C) 2015-2019 Chris Markiewicz <effigies@gmail.com>
% Copyright (C) - 2023 - Samuel Davenport <12sdavenport@gmail.com>
% See the NOTICE file in the root directory for details on the MIT license
% that this file is under.

    % Read a triangular format Freesurfer surface mesh.

    % Default values for optional arguments
    if nargin < 2
        read_metadata = false;
    end

    volume_info = containers.Map; % Create an empty map for volume_info

    TRIANGLE_MAGIC = 16777214;
    QUAD_MAGIC = 16777215;
    NEW_QUAD_MAGIC = 16777213;
    
    fid = fopen(filepath, 'rb');
    magic = fread3(fid);
    
    if isequal(magic, [QUAD_MAGIC; NEW_QUAD_MAGIC; 0]) % Quad file
        error('The quad version doesn''t work yet')
        nvert = fread(fid, 1, 'int32');
        nquad = fread(fid, 1, 'int32');
        if magic(1) == QUAD_MAGIC
            fmt = '>int16';
            div = 100;
        else
            fmt = '>float32';
            div = 1;
        end
        vertices = fread(fid, nvert * 3, fmt);
        vertices = double(vertices) / div;
        vertices = reshape(vertices, nvert, 3);
        quads = fread(fid, nquad * 4, 'int32');
        quads = reshape(quads, nquad, 4);

        % Face splitting follows
        faces = zeros(2 * nquad, 3);
        nface = 1;
        for i = 1:nquad
            if mod(quads(i, 1), 2) == 0
                faces(nface, :) = [quads(i, 1), quads(i, 2), quads(i, 4)];
                faces(nface + 1, :) = [quads(i, 3), quads(i, 4), quads(i, 2)];
            else
                faces(nface, :) = [quads(i, 1), quads(i, 2), quads(i, 3)];
                faces(nface + 1, :) = [quads(i, 1), quads(i, 3), quads(i, 4)];
            end
            nface = nface + 2;
        end

    elseif isequal(magic, TRIANGLE_MAGIC) % Triangle file
        create_stamp = fgetl(fid);
        fgetl(fid); % Skip a line
        vnum = fread(fid, 1, 'int32', 'ieee-be');
        fnum = fread(fid, 1, 'int32', 'ieee-be');
        vertices = fread(fid, vnum * 3, 'single', 'ieee-be');
        vertices = reshape(vertices, [3, vnum])';
        faces = fread(fid, fnum * 3, 'int32', 'ieee-be');
        faces = reshape(faces', [3, fnum])' + 1; %The plus 1 accounts for the fact that matlab is 1 and not zero indexed
        
        if read_metadata
            volume_info = read_volume_info(fid);
        end
    else
        error('File does not appear to be a Freesurfer surface');
    end

    % Convert to double precision
    vertices = double(vertices);

    % Return values based on optional arguments
    if read_metadata && isempty(volume_info)
        warning('No volume information contained in the file');
    end
end

function volume_info = read_volume_info(fid)
    volume_info = containers.Map;
    while ~feof(fid)
        line = fgetl(fid);
        if isempty(line)
            break; % Stop when an empty line is encountered
        end
        parts = strsplit(line, ' ', 'CollapseDelimiters', false);
        key = parts{1};
        value = str2num(parts{2}); % Convert to numeric value
        if ~isempty(value)
            volume_info(key) = value;
        else
            volume_info(key) = parts{2};
        end
    end
end

function n = fread3(fid)
    % Read a 3-byte int from an open binary file object.

    bytes = fread(fid, 3, 'uint8');
    b1 = bytes(1);
    b2 = bytes(2);
    b3 = bytes(3);
    
    n = bitshift(b1, 16) + bitshift(b2, 8) + b3;
end