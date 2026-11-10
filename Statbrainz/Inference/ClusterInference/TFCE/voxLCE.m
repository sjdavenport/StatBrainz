function [ voxel_significant_im ] = voxLCE( tstat, tfce_threshold, H, h0 )
% VOXLCE computes a voxel-level significance image by converting the TFCE
% threshold into the equivalent threshold on the original t-statistic.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  tstat           a 2D or 3D array of the original t-statistic values
%                  (NOT the TFCE-transformed image)
%  tfce_threshold  the TFCE threshold (e.g. from perm_tfce)
% Optional
%  H   height exponent used in the TFCE computation (default is 2)
%  h0  cluster forming threshold used in the TFCE computation (default is 0)
%--------------------------------------------------------------------------
% OUTPUT
% voxel_significant_im   a binary image of the same size as tstat
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
if ~exist( 'H', 'var' )
   % Default value
   H = 2;
end

if ~exist( 'h0', 'var' )
   % Default value
   h0 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
voxLCE_threshold = (tfce_threshold*(H+1) + h0^(H+1))^(1/(H+1));
voxel_significant_im = tstat > voxLCE_threshold;

end

