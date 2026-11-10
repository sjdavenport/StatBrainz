function pivotal_stats = get_pivotal_stats(p0, inverse_template, K)
% Get pivotal statistic
%--------------------------------------------------------------------------
% ARGUMENTS
% p0: a B x p matrix consisting of the  null p-values obtained from
%     B permutations/bootstraps for p hypotheses.
% inverse_template: a string indicating which template to use
% K:  int
%     For JER control over 1:K, i.e. joint control of all k-FWER, k<= K.
%     Automatically set to p if its input value is < 0.
%--------------------------------------------------------------------------
% OUTPUT
% array-like of shape (B,)
%     A numpy array of of size [B]  containing the pivotal statitics, whose
%     j-th entry corresponds to \psi(g_j.X) with notation of the AoS 2020
%     paper cited below (section 4.5) [1].
%
% References
% ----------
%
%  [1] Blanchard, G., Neuvial, P., & Roquain, E. (2020). Post hoc
%     confidence bounds on false positives using reference families.
%     Annals of Statistics, 48(3), 1281-1303.
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
% Copyright (C) - 2021 - Pierre Neuvial
%--------------------------------------------------------------------------

% Sort permuted p-values
p0 = sort(p0, 2);

% Step 3: apply template function
% For each feature p, compare sorted permuted p-values to template
[B, p] = size(p0);
tk_inv_all = arrayfun(@(i) inverse_template(p0(:, i), i + 1, p), 1:p, 'UniformOutput', false);
tk_inv_all = cell2mat(tk_inv_all);

if K < 0
    K = size(tk_inv_all, 2); % tkInv_all.shape[1] is equal to p
end

% Step 4: report min for each row
pivotal_stats = min(tk_inv_all(:, 1:K), [], 2);
end
