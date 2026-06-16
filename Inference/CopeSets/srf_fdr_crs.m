function [ lower_band, upper_band ] = srf_fdr_crs( data, mask, thresh, alpha_quant )
% SRF_FDR_CRS( data, mask, thresh, alpha_quant )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data    a struct with fields lh and rh, each an array of size
%          [nvertices, nsubj] giving the observed surface data
%  mask    a struct with fields lh and rh, each a logical array of size
%          nvertices indicating the region of interest
%  thresh  the threshold at which to generate the cope set
% Optional
%  alpha_quant  a number between 0 and 1 giving the alpha quantile;
%               default is 0.05
%--------------------------------------------------------------------------
% OUTPUT
%  lower_band    a struct with fields lh and rh giving the lower cope set
%                over vertices (0/1 arrays)
%  upper_band    a struct with fields lh and rh giving the upper cope set
%                over vertices (0/1 arrays)
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
clear masked_data
masked_data.lh = data.lh(mask.lh,:);
masked_data.rh = data.rh(mask.rh,:);

lower_band.lh = zeros(size(mask.lh));
lower_band.rh = zeros(size(mask.rh));

upper_band.lh = zeros(size(mask.lh));
upper_band.rh = zeros(size(mask.rh));

[ lower_out, upper_out ] = fdr_crs( [masked_data.lh; masked_data.rh], thresh, alpha_quant );

lower_band.lh(mask.lh) = lower_out(1:sum(mask.lh));
lower_band.rh(mask.rh) = lower_out((sum(mask.lh)+1):end);

upper_band.lh(mask.lh) = upper_out(1:sum(mask.lh));
upper_band.rh(mask.rh) = upper_out((sum(mask.lh)+1):end);

end

