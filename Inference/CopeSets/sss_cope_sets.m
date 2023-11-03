function [lower_set, upper_set, std_multipler] = sss_cope_sets(data, mask, ... 
                                                    thresh, nBoot, quant2use)
% SSS_COPE_SETS(data, mask, thresh, nBoot, quant2use) creates confidence
% sets for the locations where the mean lies above the threshold thresh.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data    an array giving the observed data which is of size [dim, nsubj] 
%          where dim is the size of the domain and nsubj is the number of
%          subjects
%  mask    a 0/1 image with size dim representing the mask
%  thresh  the threshold at which to generate the cope set
% Optional
%  nBoot   the number of bootstraps to use, default is 
%  quant2use   a number between 0 and 1 representing the quantile at 
%              which to ensure the confidence bands hold. Default is 0.95.
%--------------------------------------------------------------------------
% OUTPUT
%  lower_set:    a 0/1 array of size dim where 1 indicates the locations of
%                the lower cope set
%  upper_set:    a 0/1 array of size dim where 1 indicates the locations of
%                the upper cope set
%  diff_val:     the number that needs to be added/substracted to thresh in
%                order to obtain the level sets
%--------------------------------------------------------------------------
% EXAMPLES
% dim = [100, 100]; D = length(dim);
% mu = repmat(linspace(1, 3), dim(2), 1);
% nsubj = 60;
% FWHM = 3;
% mask = ones(dim);
% c = 2;
% 
% % noise = noisegen( dim, nsubj, FWHM );
% lat_data = wfield( dim, nsubj, 'L', 1);
% f = convfield(lat_data, FWHM);
% noise = f.field;
% data = noise + mu;
% 
% [lower_set, upper_set] = sss_cope_sets(data, mask, c, 1000);
% cope_display(lower_set, upper_set)
%--------------------------------------------------------------------------
% AUTHORs: Alex Bowring and Samuel Davenport
%--------------------------------------------------------------------------
if ~exist('nBoot')
    nBoot = 1000;
end
if ~exist('quant2use')
    quant2use = 0.95;
end
quant2use = quant2use*100;

[x,y,z] = ndgrid(-1:1);
se = strel('arbitrary',sqrt(x.^2 + y.^2 + z.^2) <=1);

thr   = thresh;  % In raw change units, mu

dim = size(mask);
D = length(dim);
nsubj = size(data, D+1);

supG = zeros([nBoot 1]);
tau = 1/sqrt(nsubj);

observed_mean = mean(data,D+1);
observed_std = std(data,0,D+1);

observed_AC = observed_mean >= thr;

% Making the interpolated boundary edges
% Horizontal edges
observed_horz = observed_AC(:,2:end,:) | observed_AC(:,1:end-1,:);
% Compute the left shifted horizontal edges
observed_lshift               = observed_AC; % initialize
observed_lshift(:,1:end-1,:)  = observed_horz;
observed_lshift               = observed_lshift & ~observed_AC;
%%% Compute the right shifted horizontal edges
observed_rshift               = observed_AC; % initialize
observed_rshift(:,2:end,:)    = observed_horz;
observed_rshift               = observed_rshift & ~observed_AC;
% Vertical edges
observed_vert = observed_AC(1:end-1,:,:) | observed_AC(2:end,:,:);
%%% Compute the up shifted horizontal edges
observed_ushift               = observed_AC;
observed_ushift(1:end-1,:,:)  = observed_vert;
observed_ushift               = observed_ushift & ~observed_AC;
%%% Compute the down shifted vertical edges
observed_dshift               = observed_AC;
observed_dshift(2:end,:,:)    = observed_vert;
observed_dshift               = observed_dshift & ~observed_AC;
% Depth edges
observed_depth                = observed_AC(:,:,1:end-1) | observed_AC(:,:,2:end);
%%% Compute the back shifted depth edges
observed_bshift               = observed_AC;
observed_bshift(:,:,1:end-1)  = observed_depth;
observed_bshift               = observed_bshift & ~observed_AC;
%%% Compute the front shifted depth edges
observed_fshift              = observed_AC;
observed_fshift(:,:,2:end)   = observed_depth;
observed_fshift              = observed_fshift & ~observed_AC;

% Computing the weights for the weighted linear boundary
observed_lshift_w1 = abs(observed_mean(observed_lshift(:,[dim(2) 1:dim(2)-1],:)) - thr)./abs(observed_mean(observed_lshift) - observed_mean(observed_lshift(:,[dim(2) 1:dim(2)-1],:)));
observed_lshift_w2 = abs(observed_mean(observed_lshift) - thr)./abs(observed_mean(observed_lshift) - observed_mean(observed_lshift(:,[dim(2) 1:dim(2)-1],:)));

observed_rshift_w1 = abs(observed_mean(observed_rshift(:,[2:dim(2) 1],:)) - thr)./abs(observed_mean(observed_rshift) - observed_mean(observed_rshift(:,[2:dim(2) 1],:)));
observed_rshift_w2 = abs(observed_mean(observed_rshift) - thr)./abs(observed_mean(observed_rshift) - observed_mean(observed_rshift(:,[2:dim(2) 1],:)));

observed_ushift_w1 = abs(observed_mean(observed_ushift([dim(1) 1:dim(1)-1],:,:)) - thr)./abs(observed_mean(observed_ushift) - observed_mean(observed_ushift([dim(1) 1:dim(1)-1],:,:)));
observed_ushift_w2 = abs(observed_mean(observed_ushift) - thr)./abs(observed_mean(observed_ushift) - observed_mean(observed_ushift([dim(1) 1:dim(1)-1],:,:)));

observed_dshift_w1 = abs(observed_mean(observed_dshift([2:dim(1) 1],:,:)) - thr)./abs(observed_mean(observed_dshift) - observed_mean(observed_dshift([2:dim(1) 1],:,:)));
observed_dshift_w2 = abs(observed_mean(observed_dshift) - thr)./abs(observed_mean(observed_dshift) - observed_mean(observed_dshift([2:dim(1) 1],:,:)));

if D == 3
    observed_bshift_w1 = abs(observed_mean(observed_bshift(:,:,[dim(3) 1:dim(3)-1])) - thr)./abs(observed_mean(observed_bshift) - observed_mean(observed_bshift(:,:,[dim(3) 1:dim(3)-1])));
    observed_bshift_w2 = abs(observed_mean(observed_bshift) - thr)./abs(observed_mean(observed_bshift) - observed_mean(observed_bshift(:,:,[dim(3) 1:dim(3)-1])));
    
    observed_fshift_w1 = abs(observed_mean(observed_fshift(:,:,[2:dim(3) 1])) - thr)./abs(observed_mean(observed_fshift) - observed_mean(observed_fshift(:,:,[2:dim(3) 1])));
    observed_fshift_w2 = abs(observed_mean(observed_fshift) - thr)./abs(observed_mean(observed_fshift) - observed_mean(observed_fshift(:,:,[2:dim(3) 1])));
end

% Residuals - just mean centering
resid = bsxfun(@minus, reshape(data, [prod(dim) nsubj]), reshape(observed_mean,[prod(dim) 1]));
resid = spdiags(1./reshape(observed_std, [prod(dim) 1]), 0,prod(dim),prod(dim))*resid;

% Finding the values of the residuals on the interpolated boundary
if D == 3
    observed_resid_boundary_values = zeros([size(observed_lshift_w1,1)+size(observed_rshift_w1,1)+size(observed_ushift_w1,1)+size(observed_dshift_w1,1)+size(observed_bshift_w1,1)+size(observed_fshift_w1,1) nsubj]);
else
    observed_resid_boundary_values = zeros([size(observed_lshift_w1,1)+size(observed_rshift_w1,1)+size(observed_ushift_w1,1)+size(observed_dshift_w1,1) nsubj]);
end
for i=1:nsubj
    subject_resid_field = reshape(resid(:,i), [dim 1]);
    subject_resid_field(~mask) = NaN;
    
    % observed_lshift is the inner boundary
    observed_lshift_boundary_values = observed_lshift_w1.*subject_resid_field(observed_lshift) + observed_lshift_w2.*subject_resid_field(observed_lshift(:,[dim(2) 1:dim(2)-1],:));
    observed_rshift_boundary_values = observed_rshift_w1.*subject_resid_field(observed_rshift) + observed_rshift_w2.*subject_resid_field(observed_rshift(:,[2:dim(2) 1],:));
    observed_ushift_boundary_values = observed_ushift_w1.*subject_resid_field(observed_ushift) + observed_ushift_w2.*subject_resid_field(observed_ushift([dim(1) 1:dim(1)-1],:,:));
    observed_dshift_boundary_values = observed_dshift_w1.*subject_resid_field(observed_dshift) + observed_dshift_w2.*subject_resid_field(observed_dshift([2:dim(1) 1],:,:));
    
    if D == 3
        observed_bshift_boundary_values = observed_bshift_w1.*subject_resid_field(observed_bshift) + observed_bshift_w2.*subject_resid_field(observed_bshift(:,:,[dim(3) 1:dim(3)-1]));
        observed_fshift_boundary_values = observed_fshift_w1.*subject_resid_field(observed_fshift) + observed_fshift_w2.*subject_resid_field(observed_fshift(:,:,[2:dim(3) 1]));
        observed_resid_boundary_values(:,i) = [observed_lshift_boundary_values; observed_rshift_boundary_values; observed_ushift_boundary_values; observed_dshift_boundary_values; observed_bshift_boundary_values; observed_fshift_boundary_values];
    else
        observed_resid_boundary_values(:,i) = [observed_lshift_boundary_values; observed_rshift_boundary_values; observed_ushift_boundary_values; observed_dshift_boundary_values];
    end
end

if isempty(observed_resid_boundary_values)
    lower_set = NaN;
    upper_set = NaN;
    std_multipler = NaN;
    warning('No boundary found')
    return
end

observed_resid_boundary_values(any(isnan(observed_resid_boundary_values), 2), :) = [];

% Implementing the Multiplier Boostrap to obtain confidence intervals
for k=1:nBoot
    % Applying the bootstrap using Rademacher variables (signflips)
    signflips = randi(2,[nsubj,1])*2-3;
    
    % Estimated boundary
    observed_boundary_bootstrap       = observed_resid_boundary_values*spdiags(signflips, 0, nsubj, nsubj);
    observed_boundary_resid_field     = sum(observed_boundary_bootstrap, 2)/sqrt(nsubj);
    % Re-standardizing by bootstrap standard deviation
    observed_boot_std                 = std(observed_boundary_bootstrap, 0, 2);
    observed_boundary_resid_field     = observed_boundary_resid_field./observed_boot_std;
    
    supG(k) = max(abs(observed_boundary_resid_field));
    
end

supGaquant = prctile(supG,quant2use);

std_multipler = supGaquant*tau;
diff_val = std_multipler*observed_std;
lower_set  = observed_mean >= thr - diff_val;
upper_set  = observed_mean >= thr + diff_val;

lower_set  = lower_set.*mask;
upper_set = upper_set.*mask;
end