function [INLA_model_obj, field_estimates, hyperpar_posteriors] = fit_bayesglm(BOLD, design, nuisance, spatial, ...
    scale_BOLD, Bayes, hyperpriors, ar_order, ar_smooth, aic, n_threads, return_INLA, verbose, ...
    meanTol, varTol)

    % Set default values
    if nargin < 15, meanTol = 1e-6; end
    if nargin < 14, varTol = 1e-6; end
    if nargin < 13, return_INLA = 'trimmed'; end
    if nargin < 12, verbose = 1; end
    if nargin < 11, n_threads = 4; end
    if nargin < 10, aic = false; end
    if nargin < 9, ar_smooth = 5; end
    if nargin < 8, ar_order = 6; end
    if nargin < 7, hyperpriors = 'default'; end
    if nargin < 6, Bayes = true; end
    if nargin < 5, scale_BOLD = 'mean'; end

    EM = false;
    emTol = 1e-3;

    % Check hyperpriors
    if ~ismember(hyperpriors, {'informative', 'default'})
        error('`hyperpriors` must be "informative" or "default"');
    end

    % Initialize return values
    INLA_model_obj = [];
    hyperpar_posteriors = [];
    field_estimates = [];
    RSS = [];
    hyperpar_posteriors = [];
    mu_theta = [];
    y_all = [];
    XA_all_list = [];
    theta_estimates = [];
    theta_estimates2 = [];
    Sig_inv = [];
    mesh = [];
    mesh_orig = [];

    % Argument checks
    do.Bayesian = Bayes;
    
    % Modeled after `BayesGLM`
    nS = length(BOLD);
    nT = cellfun(@(x) size(x, 1), design); % number of fMRI time points
    nK = size(design{1}, 2); % number of columns in design matrix
    field_names = design{1}.Properties.VariableNames; % names of task regressors
    do.perLocDesign = (ndims(design{1}) == 3);

    session_names = keys(design);

    % Check spatial struct
    if ~isstruct(spatial)
        error('spatial must be a struct');
    end
    spatial_type = spatial.spatial_type;
    
    if strcmp(spatial_type, 'surf')
        assert(length(fieldnames(spatial)) == 3);
        assert(all(ismember(fieldnames(spatial), {'spatial_type', 'surf', 'mask'})));
    elseif strcmp(spatial_type, 'voxel')
        assert(length(fieldnames(spatial)) == 8);
        assert(all(ismember(fieldnames(spatial), {'spatial_type', 'labels', 'trans_mat', 'trans_units', 'nbhd_order', 'buffer', 'buffer_mask', 'data_loc'})));
    else
        error('Unknown spatial.spatial_type.');
    end
    nV = get_nV(spatial); % total number of locations

    if strcmp(spatial_type, 'surf') && (nV.T ~= nV.D)
        if verbose > 0
            fprintf('\t%d locations on the mesh do not have data.\n', (nV.T - nV.D));
        end
    end

    % QC mask
    mask_qc = make_mask(BOLD, meanTol, varTol, verbose > 0);
    if ~any(mask_qc.mask)
        error('No locations meeting `meanTol` and `varTol`.');
    end
    if any(~mask_qc.mask)
        if strcmp(spatial_type, 'surf')
            spatial.mask(spatial.mask) = mask_qc.mask;
        elseif strcmp(spatial_type, 'voxel')
            spatial.labels(spatial.labels ~= 0 & ~mask_qc.mask) = 0; % remove bad locations
        else
            error('Unknown spatial type.');
        end
        BOLD = cellfun(@(q) q(:, mask_qc.mask, 'UniformOutput', false), BOLD, 'UniformOutput', false); % remove bad locations
    end

    % Initialize and construct informative priors for SPDE hyperparameters
    logkappa_vec = [];
    logtau_vec = [];
    
    if do.Bayesian
        d = strcmp(spatial_type, 'surf') * 2 + strcmp(spatial_type, 'voxel') * 3; 
        nu = 2 - d / 2; % nu = alpha - d/2, alpha = 2

        if strcmp(spatial_type, 'surf')
            max_dist = max(spatial.surf.vertices, [], 'omitnan') - min(spatial.surf.vertices, [], 'omitnan');
            range2 = max(max_dist) / 2; 
            tri_dist = arrayfun(@(x) mean(pdist(spatial.surf.vertices(spatial.surf.faces(x, :), :))), (1:size(spatial.surf.faces, 1))'); % MIN distance within the mesh
            min_dist = min(tri_dist); 
            range1 = min_dist * 2; 
            range0 = range1 * 5;            
        else
            res = abs(diag(spatial.trans_mat(1:3, 1:3)));
            range2 = [];
            for r = unique(spatial.labels(spatial.labels ~= 0))'
                mask_r = (spatial.labels == r);
                x_r = diff(range(find(any(mask_r, 2))) * res(1);
                y_r = diff(range(find(any(mask_r, 1))) * res(2);
                z_r = diff(range(find(any(mask_r, 3))) * res(3);
                range2 = [range2; max([x_r, y_r, z_r])]; % largest 1D distance in any direction
            end
            range2 = max(range2) * 2; % doubled
            range1 = min(res) * 2; 
            range0 = range1 * 5;
        end

        range_vec = [range1; range2; range0];

        if strcmp(hyperpriors, 'informative')
            logkappa_vec = log(sqrt(8 * nu) ./ range_vec); % r = sqrt(8*nu)/kappa
        end
        logkappa0 = log(sqrt(8 * nu) / range0);

        var2logtau = @(var, d, kappa) log(sqrt(gamma(nu) ./ (var * (4 * pi)^(d / 2) * kappa^(2 * nu))));

        var0 = 0.1; % expected SD ~= 0.33, Var ~= 0.1
        var_vec = [0.01, 1, var0]; 
        if strcmp(hyperpriors, 'informative')
            logtau_vec = var2logtau(var_vec, d, exp(logkappa0));
        end
        logtau0 = var2logtau(var0, d, exp(logkappa0)); % starting value

        % Display prior information
        if verbose > 0 && strcmp(hyperpriors, 'informative')
            fprintf('\tPutting an informative prior on kappa so that the spatial range is between %.2f and %.2f mm.\n', range1, range2);
            fprintf('\t\tLog kappa prior range (95%% density): %.2f to %.2f\n', logkappa_vec(2), logkappa_vec(1));
            fprintf('\tPutting an informative prior on tau so variance of the spatial field is between %.2f and %.2f.\n', var_vec(1), var_vec(2));
            fprintf('\t\tLog tau prior range (95%% density): %.2f to %.2f\n', logtau_vec(2), logtau_vec(1));
        end
    end

    % Get SPDE and mask based on it
    if strcmp(spatial_type, 'surf')
        [spde, spatial] = SPDE_from_surf(spatial, logkappa_vec, logtau_vec);
    else
        [spde, spatial] = SPDE_from_voxel(spatial, logkappa_vec, logtau_vec);
    end

    if strcmp(spatial_type, 'surf')
        BOLD = cellfun(@(q) q(:, spatial.mask_new_diff, 'UniformOutput', false), BOLD, 'UniformOutput', false);
    end

    % Adjust design for per-location modeling
    nV = get_nV(spatial);
    if verbose > 0
        fprintf('\tNumber of data locations: %d\n', nV.D);
        if strcmp(spatial_type, 'voxel')
            fprintf('\tNumber of data + boundary locations: %d\n', nV.DB);
        end
    end

    % Do nuisance regression of BOLD and design, and BOLD scaling
    valid_cols = cell2mat(cellfun(@(q) all(~isnan(q)), design, 'UniformOutput', false));
    
    nK2 = zeros(nS, 1);
    for s = 1:nS
        if do.perLocDesign
            nK2(s) = size(design{s}, 3); % adjusted for per-location modeling
            design{s} = reshape(design{s}, size(design{s}, 1), size(design{s}, 2) * nK2(s)); % reshape if necessary
        else
            nK2(s) = size(design{s}, 2);
        end
        BOLD{s} = BOLD{s}(:, valid_cols(s)); % adjust BOLD data
    end

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

    % Fit the Bayesian GLM using INLA
    if do.Bayesian
        for s = 1:nS
            % Run INLA here; placeholder for INLA command
            % Make sure to pass necessary parameters
            % e.g. INLA_model_obj = inla(...);
        end
    end

    % Return fitted INLA model object, estimates, etc.
    % Ensure to assign output appropriately
end

function mask = make_mask(BOLD, meanTol, varTol, verbose)
    % Implementation of quality control mask
    % Placeholder for actual logic
    mask.mask = true(size(BOLD{1}, 2), 1); % assuming all good for placeholder
end

function nV = get_nV(spatial)
    % Determine the number of valid locations based on spatial structure
    % Placeholder for actual logic
    nV.D = size(spatial.labels, 1); % assuming labels define locations
    nV.DB = nV.D + 10; % assuming some buffer for placeholder
end

function [spde, spatial] = SPDE_from_surf(spatial, logkappa_vec, logtau_vec)
    % Implementation of SPDE model creation for surface spatial data
    % Placeholder for actual logic
    spde = struct('kappa', logkappa_vec, 'tau', logtau_vec); % placeholder
end

function [spde, spatial] = SPDE_from_voxel(spatial, logkappa_vec, logtau_vec)
    % Implementation of SPDE model creation for voxel spatial data
    % Placeholder for actual logic
    spde = struct('kappa', logkappa_vec, 'tau', logtau_vec); % placeholder
end
