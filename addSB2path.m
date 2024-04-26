function addSB2path
% ADDSB2PATH adds all the contents of the StatBrainz package to the matlab
% path.
%--------------------------------------------------------------------------
% ARGUMENTS
% None
%--------------------------------------------------------------------------
% OUTPUT
% None
%--------------------------------------------------------------------------
% Implementation
% Navigate to the directory where the StatBrainz package is stored and
% run this command: addSB2path.
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

a = pwd;
if ~strcmp(a(end-9:end), 'StatBrainz')
    warning('Make sure that you run addSB2path from the main directory of StatBrainz in order to load the package, if you have renamed the folder containing StatBrainz please ignore this message.')
end
%%  Main Function Loop
%--------------------------------------------------------------------------
addpath(genpath('./'))

end

