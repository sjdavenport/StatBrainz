function data = load_gifti(filename)
    % 1. Read the file as raw bytes
    fid = fopen(filename, 'rb');
    if fid == -1, error('File not found.'); end
    raw_bytes = fread(fid, '*uint8')';
    fclose(fid);
    
    file_str = char(raw_bytes);
    
    % 2. Find all DataArrays
    da_pattern = '<DataArray\s+([^>]+)>(.*?)</DataArray>';
    [da_starts, da_ends] = regexp(file_str, da_pattern);
    
    data = struct();
    
    for i = 1:length(da_starts)
        da_block = file_str(da_starts(i):da_ends(i));
        
        % Extract Attributes
        intent = char(regexp(da_block, 'Intent="([^"]+)"', 'tokens', 'once'));
        datatype = char(regexp(da_block, 'DataType="([^"]+)"', 'tokens', 'once'));
        
        % Dimensions
        d0 = str2double(char(regexp(da_block, 'Dim0="(\d+)"', 'tokens', 'once')));
        d1 = str2double(char(regexp(da_block, 'Dim1="(\d+)"', 'tokens', 'once')));
        dims = [d0, d1]; dims(isnan(dims)) = [];
        
        % 3. Extract the Data blob surgically
        % Find the actual indices to avoid regex issues with large strings
        d_start_tag = strfind(da_block, '<Data>');
        d_end_tag = strfind(da_block, '</Data>');
        
        if isempty(d_start_tag) || isempty(d_end_tag), continue; end
        
        % Get the raw string inside <Data>
        raw_blob = da_block(d_start_tag(end)+6 : d_end_tag(end)-1);
        
        % 4. STRICT CLEANING: Remove everything except Base64 valid characters
        % This removes newlines, tabs, spaces, and XML entities like &#10;
        valid_b64 = (raw_blob >= 'A' & raw_blob <= 'Z') | ...
                    (raw_blob >= 'a' & raw_blob <= 'z') | ...
                    (raw_blob >= '0' & raw_blob <= '9') | ...
                    (raw_blob == '+') | (raw_blob == '/') | (raw_blob == '=');
        blob = raw_blob(valid_b64);
        
        % 5. Decode Base64
        decoder = java.util.Base64.getDecoder();
        try
            decoded_bytes = uint8(decoder.decode(uint8(blob)));
        catch
            warning('Base64 decode failed for index %d. Skipping.', i);
            continue;
        end
        
        % 6. Decompress with HCP-specific logic
        % HCP often uses a 4-byte header (Little Endian) indicating decompressed size
        % followed by the GZip stream.
        try
            % Attempt decompression skipping the 4-byte length header
            numeric_bytes = decompress_hcp(decoded_bytes);
        catch
            % Fallback: try from the very first byte
            numeric_bytes = decompress_hcp(decoded_bytes, 0);
        end
        
        % 7. Typecast and Shape
        if strcmpi(datatype, 'NIFTI_TYPE_FLOAT32')
            numeric_val = typecast(numeric_bytes, 'single');
        elseif strcmpi(datatype, 'NIFTI_TYPE_INT32')
            numeric_val = typecast(numeric_bytes, 'int32');
        else
            numeric_val = typecast(numeric_bytes, 'double');
        end
        
        if length(dims) == 2 && length(numeric_val) >= prod(dims)
            numeric_val = reshape(numeric_val(1:prod(dims)), dims(2), dims(1))';
        end
        
        % Map to struct
        fld = lower(strrep(intent, 'NIFTI_INTENT_', ''));
        if strcmp(intent, 'NIFTI_INTENT_POINTSET'), data.vertices = double(numeric_val);
        elseif strcmp(intent, 'NIFTI_INTENT_TRIANGLE'), data.faces = double(numeric_val) + 1;
        else, data.(fld) = numeric_val; end
    end
end

function out = decompress_hcp(bytes, offset)
    if nargin < 2, offset = 4; end % Default HCP skip
    import java.io.*
    import java.util.zip.*
    
    bais = ByteArrayInputStream(bytes(offset+1:end));
    % Use GZIPInputStream to handle the stream
    gzis = GZIPInputStream(bais);
    baos = ByteArrayOutputStream();
    
    buf = zeros(1, 32768, 'int8');
    while true
        len = gzis.read(buf, 0, 32768);
        if len <= 0, break; end
        baos.write(buf, 0, len);
    end
    out = typecast(baos.toByteArray(), 'uint8');
end