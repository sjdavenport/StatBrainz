function g = read_gifti( path4gifti )
% READ_GIFTI Reads a GIFTI (.gii) file without the external gifti package.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  path4gifti   path to the GIFTI file to read
%--------------------------------------------------------------------------
% OUTPUT
%  g   struct mirroring the fields accessed on a gifti() object:
%       .vertices   Nx3 double of point coordinates (NIFTI_INTENT_POINTSET)
%       .faces      Mx3 double of 1-based triangle indices
%                   (NIFTI_INTENT_TRIANGLE)
%       .cdata      per-vertex data for shape/label/timeseries files
%       .mat        4x4 coordinate transform (identity if none present)
%--------------------------------------------------------------------------
% NOTES
%  Supports ASCII, Base64Binary and GZipBase64Binary encodings and the
%  common NIFTI datatypes (UINT8/INT8/INT16/UINT16/INT32/UINT32/FLOAT32/
%  FLOAT64). External data files (ExternalFileBinary) are not supported.
%--------------------------------------------------------------------------
% EXAMPLES
%  g = read_gifti('lh.white.surf.gii');
%  trisurf(g.faces, g.vertices(:,1), g.vertices(:,2), g.vertices(:,3));
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input
%--------------------------------------------------------------------------
if ~exist( path4gifti, 'file' )
    error('read_gifti:fileNotFound', 'File not found: %s', path4gifti);
end

%%  Read and parse the XML
%--------------------------------------------------------------------------
dom = xmlread( path4gifti );
arrays = dom.getElementsByTagName('DataArray');

g = struct();
cdata = [];

for k = 0:arrays.getLength - 1
    da   = arrays.item(k);
    vals = read_data_array( da );

    intent = char( da.getAttribute('Intent') );
    switch intent
        case 'NIFTI_INTENT_POINTSET'
            g.vertices = vals;
            g.mat = read_transform( da );
        case 'NIFTI_INTENT_TRIANGLE'
            g.faces = vals + 1;   % GIFTI is 0-based, MATLAB is 1-based
        otherwise
            % shape / label / timeseries / normal etc. -> stack as cdata
            cdata = [cdata, vals]; %#ok<AGROW>
    end
end

if ~isempty(cdata)
    g.cdata = cdata;
end
if ~isfield(g, 'mat')
    g.mat = eye(4);
end

end

%==========================================================================
function vals = read_data_array( da )
% Decode a single <DataArray> element into a matrix respecting its
% datatype, encoding, dimensions and indexing order.

encoding = char( da.getAttribute('Encoding') );
dtype    = char( da.getAttribute('DataType') );
order    = char( da.getAttribute('ArrayIndexingOrder') );
endian   = char( da.getAttribute('Endian') );

dim0 = str2double( char(da.getAttribute('Dim0')) );
dim1 = str2double( char(da.getAttribute('Dim1')) );
if isnan(dim1) || dim1 == 0
    dim1 = 1;
end

[mclass, nbytes] = nifti_type( dtype );

% Grab the text inside the <Data> child
dataNodes = da.getElementsByTagName('Data');
if dataNodes.getLength < 1
    error('read_gifti:noData', 'DataArray has no <Data> element.');
end
raw = char( dataNodes.item(0).getTextContent );
raw = strtrim( raw );

switch encoding
    case 'ASCII'
        vals = sscanf( raw, '%f' );
        vals = cast_ascii( vals, mclass );
    case 'Base64Binary'
        bytes = base64decode( raw );
        vals  = typecast_bytes( bytes, mclass, endian );
    case 'GZipBase64Binary'
        bytes = gunzip_bytes( base64decode( raw ) );
        vals  = typecast_bytes( bytes, mclass, endian );
    otherwise
        error('read_gifti:encoding', ...
            'Unsupported encoding: %s (ExternalFileBinary not supported).', ...
            encoding);
end

vals = double( vals(:) );

% Reshape honouring the stored indexing order
if dim1 > 1
    if strcmp( order, 'RowMajorOrder' )
        vals = reshape( vals, [dim1, dim0] )';
    else % ColumnMajorOrder
        vals = reshape( vals, [dim0, dim1] );
    end
end

end

%==========================================================================
function M = read_transform( da )
% Read the 4x4 coordinate transform if present, else identity.

M = eye(4);
xforms = da.getElementsByTagName('MatrixData');
if xforms.getLength >= 1
    v = sscanf( char(xforms.item(0).getTextContent), '%f' );
    if numel(v) == 16
        M = reshape( v, [4, 4] )';   % stored row-major
    end
end

end

%==========================================================================
function [mclass, nbytes] = nifti_type( dtype )
switch dtype
    case 'NIFTI_TYPE_UINT8',   mclass = 'uint8';   nbytes = 1;
    case 'NIFTI_TYPE_INT8',    mclass = 'int8';    nbytes = 1;
    case 'NIFTI_TYPE_INT16',   mclass = 'int16';   nbytes = 2;
    case 'NIFTI_TYPE_UINT16',  mclass = 'uint16';  nbytes = 2;
    case 'NIFTI_TYPE_INT32',   mclass = 'int32';   nbytes = 4;
    case 'NIFTI_TYPE_UINT32',  mclass = 'uint32';  nbytes = 4;
    case 'NIFTI_TYPE_FLOAT32', mclass = 'single';  nbytes = 4;
    case 'NIFTI_TYPE_FLOAT64', mclass = 'double';  nbytes = 8;
    otherwise
        error('read_gifti:datatype', 'Unsupported DataType: %s', dtype);
end
end

%==========================================================================
function vals = cast_ascii( vals, mclass )
if ~strcmp(mclass, 'double') && ~strcmp(mclass, 'single')
    vals = round( vals );
end
vals = cast( vals, mclass );
end

%==========================================================================
function vals = typecast_bytes( bytes, mclass, endian )
bytes = uint8( bytes(:) );
if strcmpi( endian, 'BigEndian' )
    n = type_nbytes( mclass );
    if n > 1
        bytes = swap_bytes( bytes, n );
    end
end
vals = typecast( bytes, mclass );
end

%==========================================================================
function n = type_nbytes( mclass )
switch mclass
    case {'int8','uint8'},   n = 1;
    case {'int16','uint16'}, n = 2;
    case {'int32','uint32','single'}, n = 4;
    case 'double',           n = 8;
end
end

%==========================================================================
function bytes = swap_bytes( bytes, n )
bytes = reshape( bytes, n, [] );
bytes = flipud( bytes );
bytes = bytes(:);
end

%==========================================================================
function bytes = base64decode( str )
% Decode a base64 string to a uint8 column vector using Java.
str = str( ~isspace(str) );
dec = java.util.Base64.getDecoder().decode( uint8(str) );
bytes = typecast( dec, 'uint8' );
bytes = bytes(:);
end

%==========================================================================
function out = gunzip_bytes( bytes )
% Inflate an in-memory uint8 vector using Java streams. The GIFTI
% "GZipBase64Binary" encoding is in fact zlib-deflate (0x78 header), so an
% InflaterInputStream is used; a real gzip stream (0x1F 0x8B) is handled
% by the nowrap fallback below.
import java.io.*
import java.util.zip.InflaterInputStream
import java.util.zip.Inflater
import java.util.zip.GZIPInputStream

if numel(bytes) >= 2 && bytes(1) == 31 && bytes(2) == 139
    bis = ByteArrayInputStream( typecast(uint8(bytes(:)), 'int8') );
    iis = GZIPInputStream( bis );
else
    bis = ByteArrayInputStream( typecast(uint8(bytes(:)), 'int8') );
    iis = InflaterInputStream( bis, Inflater() );
end
bos = ByteArrayOutputStream();

buf = zeros(1, 65536, 'int8');
nread = iis.read( buf );
while nread > 0
    bos.write( buf, 0, nread );
    nread = iis.read( buf );
end
iis.close();

out = typecast( bos.toByteArray, 'uint8' );
out = out(:);
end
