function [ lower_set, upper_set ] = fdr_crs( data, thresh, alpha_quant )
% FDR_CRS( data, thresh, alpha_quant )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data    an array of size [dim, nsubj] giving the observed data where dim
%          is the size of the domain and nsubj is the number of subjects
%  thresh  the threshold at which to generate the cope set
% Optional
%  alpha_quant  a number between 0 and 1 giving the alpha quantile the
%               default is 0.05
%--------------------------------------------------------------------------
% OUTPUT
%  lower_set:    a 0/1 array of size dim where 1 indicates the locations of
%                the lower cope set
%  upper_set:    a 0/1 array of size dim where 1 indicates the locations of
%                the upper cope set
%--------------------------------------------------------------------------
% EXAMPLES
% dim = [100, 100]; D = length(dim);
% mu = repmat(linspace(1, 3), dim(2), 1);
% nsubj = 30; FWHM = 5; c = 2;
% lat_data = randn([dim, nsubj]);
% noise = fast_conv(lat_data, FWHM, 2)*5;
% data = noise + mu;
% 
% [lower_fdr, upper_fdr] = fdr_crs( data, c );
% cope_display( lower_fdr, upper_fdr, mean(data,3), c ); fullscreen
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'alpha_quant', 'var' )
   % Default value
   alpha_quant = 0.05;
end

if ~isequal(size(thresh),[1,1])
   error('Thresh must be a single number') 
end

%%  Main Function Loop
%--------------------------------------------------------------------------
[data_tstat, ~, data_std] = mvtstat(data - thresh);
s_data = size(data);
nsubj = s_data(end);
pvals = 1-tcdf(data_tstat, nsubj - 1);
pvals2use = pvals(data_std > eps);
pvals2use = pvals2use(:);

allpvals = [pvals2use, 1-pvals2use];

% Note that we can use 2 times alpha as the quantile because we know the
% value of m_0 in this case!
pval_rejection_ind = fdrBH( allpvals, 2*alpha_quant );
maxp = max(allpvals(pval_rejection_ind));

upper_set = logical(pvals <= maxp+eps);
lower_set = logical(1 - ((1-pvals) <= maxp+eps));

end

