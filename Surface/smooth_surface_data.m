function surf_data_smooth = smooth_surface_data(srf, surf_data, iterations, distance_weights, vertex_weights, return_vertex_weights, center_surround_knob, match)

    % Calculate center and surround weights
    center_weight = 1 / (1 + 2^(-center_surround_knob));
    surround_weight = 1 - center_weight;

    % Check if there's nothing to do
    if surround_weight == 0
        surf_data_smooth = surf_data;
        return;
    end

    % Calculate adjacency adj_matrix
    values = 'invlen';
    if ~distance_weights
        values = 'ones';
    end
    adj_matrix = adjacency_matrix(srf, values);

    % Normalize vertex weights if provided
    if ~isempty(vertex_weights)
        w = vertex_weights;
        w = w / sum(w);
    else
        w = ones(size(adj_matrix, 1), 1);
    end

    % Normalize adj_matrix columns
    colsums = sum(adj_matrix, 2);
    adj_matrix = bsxfun(@times, adj_matrix, surround_weight ./ colsums);
    adj_matrix(logical(eye(size(adj_matrix)))) = adj_matrix(logical(eye(size(adj_matrix)))) + center_weight;

    % Run iterations of smoothing
    n = length(surf_data);
    data = surf_data;
    for ii = 1:iterations
        data = adj_matrix * data;
    end

    % Reshape data
    data = reshape(data, size(surf_data));

    % Rescale if needed
    if strcmp(match, 'sum')
        sum0 = nansum(surf_data, 1);
        sum1 = nansum(data, 1);
        data = data .* (sum0 ./ sum1);
    elseif strcmp(match, 'mean')
        mu0 = nansum(surf_data, 1);
        mu1 = nansum(data, 1);
        data = data + (mu0 - mu1);
    elseif any(strcmp(match, {'var', 'std', 'variance', 'stddev', 'sd'}))
        std0 = nanstd(surf_data, 1);
        std1 = nanstd(data, 1);
        mu1 = nanmean(data, 1);
        data = (data - mu1) .* (std0 ./ std1) + mu1;
    elseif any(strcmp(match, {'dist', 'meanvar', 'meanstd', 'meansd'}))
        std0 = nanstd(surf_data, 1);
        std1 = nanstd(data, 1);
        mu0 = nanmean(surf_data, 1);
        mu1 = nanmean(data, 1);
        data = (data - mu1) .* (std0 ./ std1) + mu0;
    elseif ~isempty(match)
        error(['Invalid match argument: ', match]);
    end

    % Return result
    if return_vertex_weights
        w = w / sum(w);
        surf_data_smooth = {data, w};
    else
        surf_data_smooth = data;
    end
end
