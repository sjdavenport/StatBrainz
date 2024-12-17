function data = gmrnd(num_samples, weights, means, std_devs)
    % generate_gaussian_mixture generates random samples from a Gaussian mixture model
    % Inputs:
    %   num_samples - Number of samples to generate
    %   weights     - A vector of mixture weights (must sum to 1)
    %   means       - A vector of means for the Gaussian components
    %   std_devs    - A vector of standard deviations for the Gaussian components
    % Output:
    %   data        - A vector of generated samples
    %
    % data = gmrnd(10000, [0.5, 0.5], [0,0], [1,7])
    % histogram(data)
    
    % Validate inputs
    if abs(sum(weights) - 1) > 1e-6
        error('Mixture weights must sum to 1.');
    end
    if length(weights) ~= length(means) || length(weights) ~= length(std_devs)
        error('Weights, means, and standard deviations must have the same length.');
    end
    
    % Number of components
    num_components = length(weights);
    
    % Preallocate the data array
    data = zeros(num_samples, 1);
    
    % Generate component assignments based on weights
    component_indices = randsample(1:num_components, num_samples, true, weights);
    
    % Generate data from the assigned components
    for i = 1:num_components
        % Number of samples for the current component
        num_samples_i = sum(component_indices == i);
        
        % Generate samples for this component
        data(component_indices == i) = normrnd(means(i), std_devs(i), [num_samples_i, 1]);
    end
end
