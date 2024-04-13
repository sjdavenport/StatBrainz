function [ threshold, vec_of_maxima, permuted_tstat_store ] = ... 
    perm_tfce( data, mask, H, E, connectivity, dh, h0, alpha, nperm, show_loader, store_perms )
% PERM_TFCE Calculates threshold, maxima vector, and permuted t-statistics for TFCE.
%
%   [threshold, vec_of_maxima, permuted_tstat_store] = ...
%       PERM_TFCE(data, mask, H, E, connectivity, dh, alpha, nperm, show_loader, store_perms)
%   calculates the threshold, vector of maxima, and permuted t-statistics for 
%   Threshold-Free Cluster Enhancement (TFCE) based on input data and parameters.
%--------------------------------------------------------------------------
% ARGUMENTS:
%   - data: Input data matrix.
%   - mask: Binary mask specifying the region of interest.
%   - H: Height exponent (default is 2).
%   - E: Extent exponent (default is 0.5).
%   - connectivity: Connectivity used to compute connected components.
%   - dh: Size of steps for cluster formation.
%   - alpha: Significance level (default is 0.05).
%   - nperm: Number of permutations for randomization (default is 1000).
%   - show_loader: Flag to display progress loader (default is 1).
%   - store_perms: Flag to store permuted t-statistics (default is 0).
%--------------------------------------------------------------------------
% OUTPUT:
%   - threshold: Threshold value based on the specified alpha level.
%   - vec_of_maxima: Vector of maxima obtained from TFCE calculations.
%   - permuted_tstat_store: Matrix storing permuted t-statistics (if enabled).
%--------------------------------------------------------------------------
% EXAMPLES
% dim = [50,50]; nsubj = 50; FWHM = 0;
% Sig = 0.25*peakgen(1, 10, 8, dim);
% data = wfield(dim, nsubj).field + Sig;
% threshold = perm_tfce(data, ones(dim))
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
% s_data = size(data);
dim = size(mask);
D = length(dim);
data_vectorized = vec_data(data, mask);

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'connectivity', 'var' )
   % Default value
   if D == 2
       connectivity = 8;
   elseif D == 3
       connectivity = 26;
   end
end

if ~exist( 'h0', 'var' )
   % Default value
   h0 = 0;
end

if ~exist( 'H', 'var' )
   % Default value
   H = 2;
end

if ~exist( 'E', 'var' )
   % Default value
   E = 0.5;
end

if ~exist( 'dh', 'var' )
   % Default value
   dh = 0.1;
end

if ~exist( 'nperm', 'var' )
   % Default value
   nperm = 1000;
end

if ~exist( 'show_loader', 'var' )
   % Default value
   show_loader = 1;
end

if ~exist( 'alpha', 'var' )
   % Default value
   alpha = 0.05;
end

if ~exist('store_perms', 'var')
    store_perms = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
nsubj = size(data_vectorized,2);

mask = logical(mask);

tstat = unwrap(nan2zero(mvtstat(data_vectorized)), mask);
tstat_tfce =  tfce(tstat.*mask,H,E,connectivity,dh,h0);
    
vec_of_maxima = zeros(1,nperm);
vec_of_maxima(1) = max(tstat_tfce(:));

% Compute bernoulli random variables for the sign flipping
random_berns = 2*(binornd(1,0.5, nsubj, nperm )-1/2);

if store_perms == 1
    permuted_tstat_store = zeros([sum(mask(:)), nperm]);
    permuted_tstat_store(:,1) = tstat(mask);
else
    permuted_tstat_store = NaN;
end

for I = 2:nperm
    if show_loader == 1
        loader(I-1, nperm-1, 'tfce perm progress:');
    end
    
    random_berns_for_iter = random_berns(:, I);
    random_sample_negative = find(random_berns_for_iter < 0);

    data_perm = data_vectorized;
    data_perm(:,random_sample_negative) = -data_vectorized(:,random_sample_negative);
    
    tstat_perm = unwrap(nan2zero(mvtstat(data_perm)), mask);
    tstat_tfce_perm =  tfce(tstat_perm.*mask,H,E,connectivity,dh,h0);
    
    if store_perms == 1
        permuted_tstat_store(:,I) = tstat_tfce_perm(mask);
    end
    
    vec_of_maxima(I) = max(tstat_tfce_perm(mask));
end

threshold = prctile(vec_of_maxima, 100*(1-alpha) );

end

