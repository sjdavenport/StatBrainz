function [ voxel_significant_im ] = voxLCE( tfce_tstat, tfce_threshold, H, h0 )
% VOXLCE computes a voxel-level significance image from a TFCE statistic
% image by deriving the equivalent voxel-level threshold.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  tfce_tstat      a 2D or 3D array of TFCE statistic values
%  tfce_threshold  the TFCE threshold (e.g. from perm_tfce)
% Optional
%  H   height exponent used in the TFCE computation (default is 2)
%  h0  cluster forming threshold used in the TFCE computation (default is 0)
%--------------------------------------------------------------------------
% OUTPUT
% voxel_significant_im   a binary image of the same size as tfce_tstat
%                        with 1 where the voxel is significant
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
voxLCE_threshold = (tfce_threshold*(H+1) + h0^(H+1))^(1/(H+1));
voxel_significant_im = tfce_tstat > voxLCE_threshold;

end

