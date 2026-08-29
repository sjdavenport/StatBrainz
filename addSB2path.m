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

%%  Main Function Loop
%--------------------------------------------------------------------------
addpath(genpath(fileparts(mfilename('fullpath'))))

end

