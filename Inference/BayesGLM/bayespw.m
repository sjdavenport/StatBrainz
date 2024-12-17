function results = GLM_est_resid_var_pw(BOLD, design, spatial, session_names, ...
    field_names, design_type, valid_cols, nT, ar_order, ar_smooth, aic, ...
    n_threads, do_pw)

    nS = length(session_names);
    nV_D = size(spatial, 2);  % Assuming spatial has dimensions [nX, nV_D]
    
    var_resid = zeros(nV_D, nS);
    AR_coefs_avg = [];
    max_AIC = [];
    
    if do_pw
        AR_coefs = zeros(nV_D, ar_order, nS);
        if aic
            AR_AIC = zeros(nV_D, nS);
        else
            AR_AIC = [];
        end
    end
    
    % Estimate parameters for each session.
    for ss = 1:nS
        vcols_ss = valid_cols(ss, :);
        
        if strcmp(design_type, 'regular')
            resid_ss = nuisance_regression(BOLD{ss}, design{ss}(:, vcols_ss));
        elseif strcmp(design_type, 'per_location')
            resid_ss = zeros(size(BOLD{ss}));
            for dd = 1:nV_D
                resid_ss(:, dd) = nuisance_regression(BOLD{ss}(:, dd), ...
                    design{ss}(:, vcols_ss, dd));
            end
        else
            error('Invalid design type');
        end
        
        if do_pw
            pw_est_ss = pw_estimate(resid_ss, ar_order, aic);
            var_resid(:, ss) = pw_est_ss.sigma_sq;
            AR_coefs(:, :, ss) = pw_est_ss.phi;
            if aic
                AR_AIC(:, ss) = pw_est_ss.aic;
            end
        else
            var_resid(:, ss) = var(resid_ss); % Variance estimation
        end
    end

    % Average across sessions.
    var_avg = mean(var_resid, 2);
    if ~do_pw
        var_avg = var_avg / mean(var_avg, 'omitnan');
    end
    if do_pw
        AR_coefs_avg = squeeze(mean(AR_coefs, 3));
        if aic
            max_AIC = max(AR_AIC, [], 2);
        end
    end

    % Smooth prewhitening parameters.
    if do_pw && ar_smooth > 0
        [AR_coefs_avg, var_avg] = pw_smooth(spatial, AR_coefs_avg, var_avg, ar_smooth);
    end

    sqrtInv_all = arrayfun(@(q) make_sqrtInv_all(q, nV_D, do_pw, n_threads, ...
        ar_order, AR_coefs_avg, var_avg), nT, 'UniformOutput', false);

    results = struct('var_resid', var_resid, 'sqrtInv_all', {sqrtInv_all}, ...
                     'AR_coefs_avg', AR_coefs_avg, 'var_avg', var_avg, ...
                     'max_AIC', max_AIC);
end

function sqrtInv_all = make_sqrtInv_all(nT, nV, do_pw, n_threads, ...
    ar_order, AR_coefs_avg, var_avg)

    if do_pw
        if isempty(n_threads) || n_threads < 2
            % Case 1A: Prewhitening; not parallel.
            template_pw = spdiags(ones(nT, 1) * [1; zeros(ar_order, 1)], 0:ar_order, nT, nT);
            template_pw_list = cell(nV, 1);
            for vv = 1:nV
                template_pw_list{vv} = getSqrtInvCpp(AR_coefs_avg(vv, :), nT, var_avg(vv));
            end
        else
            % Case 1B: Prewhitening; parallel.
            if ~exist('parpool', 'file')
                error('Prewhitening in parallel requires the Parallel Computing Toolbox. Please install it.');
            end
            
            parpool(n_threads); % Start a parallel pool
            
            parResults = cell(nV, 1);
            parfor vv = 1:nV
                parResults{vv} = getSqrtInvCpp(AR_coefs_avg(vv, :), nT, var_avg(vv));
            end
            
            template_pw_list = parResults;
            delete(gcp('nocreate')); % Close parallel pool
        end

        % Create block diagonal matrix from list
        sqrtInv_all = blkdiag(template_pw_list{:});
        
    else
        % Case 2: Prewhitening not performed.
        diag_values = repmat(1 ./ sqrt(var_avg), nT, 1);
        sqrtInv_all = spdiags(diag_values, 0, nT * nV, nT * nV);
    end
end

function sqrtInv = getSqrtInvCpp(AR_coefs, nTime, avg_var)
    % C++ or custom MATLAB function to calculate square root inverse
    % This is a placeholder; replace with the actual implementation
    sqrtInv = eye(nTime); % Replace with actual computation
end

function resid = nuisance_regression(BOLD, design)
    % Placeholder for nuisance regression function
    % This should implement the actual regression logic
    resid = BOLD - design * (design \ BOLD);
end

function pw_est = pw_estimate(resid_ss, ar_order, aic)
    % Placeholder for prewhitening estimation logic
    % Compute sigma_sq and phi here based on residuals
    pw_est.sigma_sq = var(resid_ss); % Replace with actual logic
    pw_est.phi = zeros(ar_order, 1); % Replace with actual AR coefficients
    pw_est.aic = []; % Add AIC if applicable
end

function [AR_coefs_avg, var_avg] = pw_smooth(spatial, AR_coefs_avg, var_avg, ar_smooth)
    % Placeholder for smoothing function
    % Implement your smoothing logic here
end
