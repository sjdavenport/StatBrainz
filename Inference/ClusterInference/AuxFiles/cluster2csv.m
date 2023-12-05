function cluster2csv(inputcluster, filename, savedir)
% CLUSTER2CSV(inputcluster, filename)
%--------------------------------------------------------------------------
% Converts a cluster represented by a matrix into a CSV file.
%
% ARGUMENTS
%   inputcluster: Matrix representing the cluster. Columns represent
%                 different dimensions.
%   filename:     Name of the CSV file (without extension) to be created.
%
% OUTPUT
%   None
%
% EXAMPLES
%   cluster = randi(10, 2); % Example 2D cluster
%   cluster2csv(cluster, 'output_cluster_2d');
%
%   cluster = randi(10, 3); % Example 3D cluster
%   cluster2csv(cluster, 'output_cluster_3d');
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------
if ~exist('savedir', 'var')
    savedir = './';
end

if size(inputcluster, 2) == 1
    data = array2table(inputcluster, 'VariableNames', {'x'});
elseif  size(inputcluster, 2) == 2
    data = array2table(inputcluster, 'VariableNames', {'x', 'y'});
elseif size(inputcluster, 2) == 3
    data = array2table(inputcluster, 'VariableNames', {'x', 'y', 'z'});
end
% Write the table to a CSV file
writetable(data, [savedir, filename, '.csv']);
end