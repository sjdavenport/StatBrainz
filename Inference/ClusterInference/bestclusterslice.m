function [maxsumlocs, totalinslice] = bestclusterslice( slice_no, surviving_cluster_im )
%   [maxsumlocs, totalinslice] = BESTCLUSTERSLICE(slice_no, surviving_cluster_im) computes
%   the maximum sum locations and total values within a specified slice (given by slice_no)
%   in the surviving_cluster_im.
%
% ARGUMENTS:
%   - slice_no: The slice number for which the computation is performed.
%   - surviving_cluster_im: Either a 3D binary array representing the surviving cluster or
%                           a cell array of such 3D binary arrays.
%
% OUTPUT:
%   - maxsumlocs: Indices of the maximum sum locations within the slice.
%   - totalinslice: Total values for each position in the specified slice.
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
if iscell(surviving_cluster_im)
    maxsumlocs = cell(1, length(surviving_cluster_im));
    totalinslice = cell(1, length(surviving_cluster_im));
    for J = 1:length(surviving_cluster_im)
        im = zeros(91,109,91);
        im(surviving_cluster_im{J}) = 1;
        [maxsumlocs{J}, totalinslice{J}] = bestclusterslice( slice_no, im );
    end
    return
end

dim = [91,109,91];
s_dim = dim(slice_no);
slice = {':', ':', ':'};
totalinslice = zeros(1,s_dim);
for I = 1:s_dim
    slice{slice_no} = I;
    slice_image = surviving_cluster_im(slice{:});
    totalinslice(I) = sum(sum(slice_image));
end
    
maxsumlocs = find(totalinslice == max(totalinslice));
   
end

