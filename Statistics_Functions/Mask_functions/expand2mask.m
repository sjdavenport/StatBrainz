function [ out ] = expand2MNI( im, mask, padding )
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
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'padding', 'var' )
   % Default value
   padding = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
bounds = mask_bounds(mask,padding);
D = length(size(im));
if length(bounds) == 3 && D == 2
    bounds = bounds(1:2);
end

out = zeros([91,109]);
out(bounds{:}) = im;

end

