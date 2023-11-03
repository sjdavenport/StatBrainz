function converted_indices = convindall( indices2convert )
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

%%  Main Function Loop
%--------------------------------------------------------------------------

converted_indices = cell(1, length(indices2convert));
for I = 1:length(indices2convert)
    changed = zeros(length(indices2convert{I}), 3);
    for J = 1:length(indices2convert{I})
        changed(J,:) = convind(indices2convert{I}(J));
    end
    converted_indices{I} = changed;
end

end

