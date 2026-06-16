function fdp = fdp_calc( rejection_loc_mask, signal_loc_mask)
% FDP_CALC calculates the FDP given a set of rejection locaitons and true
% locations.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  rejection_loc_mask  a binary array marking the rejected locations
%  signal_loc_mask     a binary array marking the true signal locations
%--------------------------------------------------------------------------
% OUTPUT
% fdp   the false discovery proportion: proportion of rejections that are
%       false positives (0 if there are no rejections)
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
if size(rejection_loc_mask) ~= size(signal_loc_mask)
    error('Mask size mismatch')
end

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
no_signal_areas = 1 - signal_loc_mask;
false_discoveries = rejection_loc_mask.*no_signal_areas;
n_false_discoveries = sum(false_discoveries(:));

n_rejections = sum(rejection_loc_mask(:));

fdp = n_false_discoveries/max(n_rejections,1);
% fdp = n_false_discoveries/n_rejections;

end

