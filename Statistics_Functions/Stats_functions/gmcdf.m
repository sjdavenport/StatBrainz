function cdf = gmcdf(x, weights, means, std_devs)
    % mixture_gaussian_cdf computes the CDF of a Gaussian mixture model
    % Inputs:
    %   x        - The value(s) where the CDF is evaluated (scalar or vector)
    %   weights  - A vector of mixture weights (must sum to 1)
    %   means    - A vector of means for the Gaussian components
    %   std_devs - A vector of standard deviations for the Gaussian components
    % Output:
    %   cdf      - The value(s) of the CDF at x
    
    % Validate inputs
    if abs(sum(weights) - 1) > 1e-6
        error('Mixture weights must sum to 1.');
    end
    if length(weights) ~= length(means) || length(weights) ~= length(std_devs)
        error('Weights, means, and standard deviations must have the same length.');
    end
    
    % Initialize CDF
    cdf = zeros(size(x));
    
    % Compute the mixture CDF
    for i = 1:length(weights)
        % Add the weighted CDF of the i-th Gaussian
        cdf = cdf + weights(i) * normcdf(x, means(i), std_devs(i));
    end
end
