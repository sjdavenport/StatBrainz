function out = sbasis( d, D )
% SBASIS( d, D ) returns the dth D-dimensional standard basis vector.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  d     the index of the basis vector to return
%  D     the dimension
% Optional
% None
%--------------------------------------------------------------------------
% OUTPUT
%  out   a D by 1 vector which is 1 at entry d and 0 elsewhere
%--------------------------------------------------------------------------
% Copyright (C) - 2019 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
out = zeros(D,1);
out(d) = 1;
end
