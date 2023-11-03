function lower_bound = clustertp_lowerbound(CL, cluster_threshold, D)
    rk = rkval(cluster_threshold, D);
    
    % Calculate the range in x, y, and z
    range_x = range(CL.x) + 3;
    range_y = range(CL.y) + 3;

    % Convert the variables to double
    CL.x = double(CL.x);
    CL.y = double(CL.y);
    CL.z = double(CL.z);
    range_x = double(range_x);
    range_y = double(range_y);

    % Calculate CL with element-wise addition and multiplication
    CL = CL.x + range_x* CL.y + range_x* range_y* CL.z;
    
    % Define the neighbors in x, y, and z directions
    neighbors_x = [0, 1, 0, 1, 0, 1, 0, 1];
    neighbors_y = [0, 0, 1, 1, 0, 0, 1, 1];
    neighbors_z = [0, 0, 0, 0, 1, 1, 1, 1];
    neighbors = neighbors_x + range_x * neighbors_y + range_x * range_y * neighbors_z;
    
    % Define the CLplus function
    function result = CLplus(CL)
        if isempty(CL)
            result = CL;
        else
            result = unique(CL + neighbors);
        end
        if size(result,1) == 1
            result = result';
        end
    end

    % Define the CLmin function
    function result = CLmin(CL)
        CLplus_result = CLplus(CL);
        CLrest = setdiff(CLplus_result, CL);
        result = setdiff(CL, unique(CLrest - neighbors));
    end

    % Define the CLprune function
    function result = CLprune(CL, i)
        for j = 1:i
            CL = CLmin(CL);
        end
        for j = 1:i
            CL = CLplus(CL);
        end
        result = CL;
    end

    % Calculate max_i and initialize sV
    max_i = floor(length(CL)^(1/3));
%     sV = length(CL) > rk;
    sV = length(CL) > cluster_threshold;
    
    % Perform pruning and calculate sV
    for i = 0:max_i
        pruned = CLprune(CL, i);
        pruned_plus = CLplus(pruned);
        pruned_rest = setdiff(pruned_plus, pruned);
        sV = max(sV, rk * length(pruned_plus) - length(pruned_rest));
    end
    % Return the result
    lower_bound = ceil(sV);
end
