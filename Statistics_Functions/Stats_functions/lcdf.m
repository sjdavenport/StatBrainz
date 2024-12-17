function cdf = lcdf(x, mu, b)
    % laplace_cdf computes the CDF of the Laplace distribution
    % Inputs:
    %   x  - The value(s) where the CDF is evaluated (scalar or vector)
    %   mu - The location parameter (mean)
    %   b  - The scale parameter (diversity), must be positive
    % Output:
    %   cdf - The value(s) of the CDF at x
    
    % Validate input
    if b <= 0
        error('Scale parameter b must be positive');
    end
    
    % Compute CDF based on the value of x
    cdf = zeros(size(x)); % Initialize output
    for i = 1:numel(x)
        if x(i) <= mu
            cdf(i) = 0.5 * exp((x(i) - mu) / b);
        else
            cdf(i) = 1 - 0.5 * exp(-(x(i) - mu) / b);
        end
    end
end
