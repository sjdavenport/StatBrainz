function [ number_of_clusters, occurences, cluster_sizes, index_locations ]  = ...
                                graph_cc( data, thresh, adj_matrix )
%   [number_of_clusters, occurences, cluster_sizes, index_locations] = ...
%       graph_cc(data, thresh, adj_matrix) computes connected components
%       in a graph represented by the adjacency matrix 'adj_matrix', using
%       a threshold 'thresh' on the data.
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       data          - Data for thresholding and clustering.
%       thresh        - Threshold for data to define connected components.
%       adj_matrix    - nvertices x nvertices adjacency matrix representing the graph.
%--------------------------------------------------------------------------
% OUTPUT
%   number_of_clusters - Number of connected clusters in the graph.
%   occurences         - Occurrences of each cluster size.
%   cluster_sizes      - Unique sizes of the connected clusters.
%   index_locations    - Cell array containing the indices of each cluster.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
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
% adj_matrix = adjacency_matrix(srf);
notsurvived = data <= thresh;

nvertices = size(adj_matrix,1);
indices = 1:nvertices;
indices_notsurvived = indices(notsurvived);

adj_matrix(indices_notsurvived,:) = 0;
adj_matrix(:,indices_notsurvived) = 0;

g = graph(adj_matrix);
[bins, binsizes] = conncomp(g);

% Get rid of the non-survived values
bins(indices_notsurvived) = 0;

cluster_indices = unique(bins);
cluster_indices = cluster_indices(cluster_indices > 0);

number_of_clusters = length(cluster_indices);

index_locations = cell(1, number_of_clusters);

cluster_sizes = unique(binsizes);
cluster_sizes = cluster_sizes(cluster_sizes > 1);

occurences = zeros(1, length(cluster_sizes));
for I = 1:number_of_clusters
    index_locations{I} = find(bins == cluster_indices(I));
    K = find(cluster_sizes == length(index_locations{I}));
    occurences(K) = occurences(K) + 1;
    % index_locations{I} = indices(bins == (I + 1));
end

end

