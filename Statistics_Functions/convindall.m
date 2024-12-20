function converted_indices = convindall( indices2convert, dim )
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
% convindall({[358390, 358389], 358380})
% disp(ans{1})
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~iscell(indices2convert)
   % Default value
   indices2convert = {indices2convert};
end

if ~exist('dim', 'var')
    dim = [91,109,91];
end

D = length(dim);

%%  Main Function Loop
%--------------------------------------------------------------------------

converted_indices = cell(1, length(indices2convert));
for I = 1:length(indices2convert)
    changed = zeros(length(indices2convert{I}), D);
    for J = 1:length(indices2convert{I})
        changed(J,:) = convind(indices2convert{I}(J), dim);
    end
    converted_indices{I} = changed;
end

end

