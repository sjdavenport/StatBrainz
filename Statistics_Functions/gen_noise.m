function smooth_noise = gen_noise( mask, FWHM, nsubj, mean_img, std_img )
% smooth_noise = GEN_NOISE(mask, FWHM, nsubj, mean_img, std_img) generates
% smoothed noise using a given mask, full width at half maximum (FWHM),
% number of subjects (nsubj), mean image (mean_img), and standard deviation
% image (std_img).
%--------------------------------------------------------------------------
% ARGUMENTS
%   Mandatory
%       mask          - Binary mask specifying the region for noise generation.
%       FWHM          - Full width at half maximum for smoothing the noise.
%   Optional
%       nsubj         - Number of subjects (default: 1).
%       mean_img      - Mean image used for scaling the generated noise
%                      (default: zeros(size(mask))).
%       std_img       - Standard deviation image used for scaling the
%                      generated noise (default: ones(size(mask))).
%--------------------------------------------------------------------------
% OUTPUT
%   smooth_noise     - Generated smoothed noise.
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'nsubj', 'var' )
   % Default value
   nsubj = 1;
end

if ~exist( 'mean_img', 'var' )
   % Default value
   mean_img = zeros(size(mask));
end

if ~exist( 'std_img', 'var' )
   % Default value
   std_img = ones(size(mask));
end

%%  Main Function Loop
%--------------------------------------------------------------------------
noise = randn([size(mask), nsubj]);
[smooth_noise, ss] = fconv(noise, FWHM, length(size(mask)));
smooth_noise = smooth_noise./sqrt(ss);
smooth_noise = smooth_noise.*mask.*std_img + mean_img;

end

