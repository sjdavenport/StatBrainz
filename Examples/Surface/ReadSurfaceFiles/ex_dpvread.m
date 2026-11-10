%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script gives examples of the dpvread function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Write a small data-per-vertex file and read it back
% Each line of a .dpv file has 5 columns: vertex index, x, y, z and a value
nvertices = 4;
dpv = [(0:nvertices-1)', randn(nvertices, 3), (1:nvertices)'];
filename = [tempdir, 'ex_dpvread.dpv'];
fid = fopen(filename, 'w');
fprintf(fid, '%d %f %f %f %f\n', dpv');
fclose(fid);
out = dpvread( filename, nvertices )

%% Get the data value at each vertex
values = out(:,5)

%% Only read the first 2 vertices
out2 = dpvread( filename, 2 )
delete(filename)
