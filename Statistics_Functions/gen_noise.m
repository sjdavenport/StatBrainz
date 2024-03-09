function smooth_noise = gen_noise( mask, FWHM, nsubj, mean_img, std_img )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
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

%%  Main Function Loop
%--------------------------------------------------------------------------
noise = randn([size(mask), nsubj]);
[smooth_noise, ss] = fconv(noise, FWHM, length(size(mask)));
smooth_noise = smooth_noise./sqrt(ss);
smooth_noise = smooth_noise.*mask.*std_img + mean_img;

end

