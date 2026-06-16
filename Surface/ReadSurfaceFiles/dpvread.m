function [ out ] = dpvread( filename, nvertices )
% DPVREAD Reads a data-per-vertex text file into a matrix.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  filename    path to the data-per-vertex file (5 columns per vertex)
%  nvertices   number of vertices to read
%--------------------------------------------------------------------------
% OUTPUT
%  out  nvertices x 5 matrix of the per-vertex data
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
fid = fopen(filename,'r');
out = fscanf(fid,'%f',5*nvertices);
fclose(fid);
out = reshape(out,[5 nvertices])';
end

