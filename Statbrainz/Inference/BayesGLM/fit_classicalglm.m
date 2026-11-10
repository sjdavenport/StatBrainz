    % Fit classical GLM first
    % Store output for the BOLD data
    theta_estimates = cell(nS, 1);
    y_all = cell(nS, 1);
    for s = 1:nS
        y_all{s} = BOLD{s}(:);
        theta_estimates{s} = zeros(size(BOLD{s}, 2), nK2(s)); % initialize estimate matrix
    end

    for s = 1:nS
        % Fit GLM
        glm = fitglm(design{s}, y_all{s}, 'linear', 'Distribution', 'normal');
        theta_estimates{s} = glm.Coefficients.Estimate;
    end