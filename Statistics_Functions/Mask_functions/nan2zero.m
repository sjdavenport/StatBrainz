function vec = nan2zero( vec, val )
% NAN2ZERO( vec, val ) replaces all NaN entries in vec with val.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  vec   a numeric array.
% Optional
%  val   the replacement value. Default is 0.
%--------------------------------------------------------------------------
% OUTPUT
%  vec   the array with NaN entries replaced by val.

%--------------------------------------------------------------------------
% EXAMPLES
% nan2zero([1,5.1,0, nan, 0.0001])
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

if ~exist('val', 'var')
    val = 0;
end

vec(isnan(vec)) = val;

end

