function [ threshold, vec_of_max_cluster_sizes, permuted_tstat_store ] = ... 
        perm_cluster( data, mask, CDT, connectivity, alpha, nperm, show_loader, store_perms )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data: 
%  CDT: the cluster defining threshold. Default is 2.3.
%--------------------------------------------------------------------------
% OUTPUT
% 
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

if ~exist( 'CDT', 'var' )
   % Default value
   CDT = norminv(0.99);
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
[~, ~, sizes] = numOfConComps(tstat.*mask, CDT, connectivity);
max_cluster_size = max(sizes);

vec_of_max_cluster_sizes = zeros(1,nperm);
if isempty(max_cluster_size)
    warning('No superthreshold t-stat voxels found')
    threshold = NaN;
    return
end
vec_of_max_cluster_sizes(1) = max_cluster_size;

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
        loader(I-1, nperm-1, 'perm progress:');
    end
    
    random_berns_for_iter = random_berns(:, I);
    random_sample_negative = find(random_berns_for_iter < 0);

    data_perm = data_vectorized;
    data_perm(:,random_sample_negative) = -data_vectorized(:,random_sample_negative);
    
    tstat_perm = unwrap(nan2zero(mvtstat(data_perm)), mask);
    [~, ~, sizes] = numOfConComps(tstat_perm.*mask, CDT, connectivity);
    max_cluster_size_perm = max(sizes);
    
    if store_perms == 1
        permuted_tstat_store(:,I) = tstat_perm(mask);
    end
    
    if isempty(max_cluster_size_perm)
        vec_of_max_cluster_sizes(I) = 0;
    else
        vec_of_max_cluster_sizes(I) = max_cluster_size_perm;
    end
end

threshold = prctile(vec_of_max_cluster_sizes, 100*(1-alpha) );

end

