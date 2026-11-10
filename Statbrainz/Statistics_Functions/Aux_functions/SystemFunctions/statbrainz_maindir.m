function maindir = statbrainz_maindir
% STATBRAINZ_MAINDIR returns the main directory of the StatBrainz
% repository. This requires that StatBrainz and all of its contents have
% been added to the matlab path.
%--------------------------------------------------------------------------
% ARGUMENTS
% None
%--------------------------------------------------------------------------
% OUTPUT
% maindir   a string giving the main directory
%--------------------------------------------------------------------------
% EXAMPLES
% maindir = statbrainz_maindir
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
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
maindir = which('statbrainz_maindir.m');

if isempty(maindir)
    error('StatBrainz has not been added to the matlab path, please navigate to the StatBrainz directory and run the common addSB2path')
end

for I = 1:4
    maindir = fileparts(maindir);
end

if ~strcmp(maindir(end), '/') && ~strcmp(maindir(end), '\')
if any(strfind(maindir, '/'))
    maindir = [maindir, '/'];
elseif any(strfind(maindir, '\'))
    maindir = [maindir, '\'];
end

end

