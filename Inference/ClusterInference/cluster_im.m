function [ surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = ...
                             cluster_im( dim, index_locations, threshold )
% CLUSTER_IM Computes surviving clusters based on index locations and a threshold.
%
%   [surviving_cluster_im, surviving_clusters, surviving_clusters_vec] = ...
%       CLUSTER_IM(dim, index_locations, threshold) computes surviving clusters
%       in a binary image based on index locations and a specified threshold.
%
% ARGUMENTS:
%   - dim: Dimensions of the binary image.
%   - index_locations: Cell array of linear index locations for potential clusters.
%   - threshold: Minimum number of elements required for a cluster to survive.
%
% OUTPUT:
%   - surviving_cluster_im: Binary image representing surviving clusters.
%   - surviving_clusters: Cell array containing surviving clusters as subscript indices.
%   - surviving_clusters_vec: Cell array containing surviving clusters as linear indices.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
surviving_cluster_im = zeros(dim);
surviving_clusters_vec = {};
nsurvivors = 0;
for I = 1:length(index_locations)
  if length(index_locations{I}) > threshold
      nsurvivors = nsurvivors + 1;
      surviving_cluster_im(index_locations{I}) = 1;
      surviving_clusters_vec{nsurvivors} = index_locations{I};
  end
end
surviving_clusters = convindall(surviving_clusters_vec, dim);
% if length(dim) == 2
%     for I = 1:length(surviving_clusters)
%         surviving_clusters{I} = surviving_clusters{I}(:,1:2);
%     end
% end

end

