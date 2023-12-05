function tp_bounds = ctp_scores( logdir )
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
cluster_names = filesindir(logdir);
tp_bounds = zeros(1, length(cluster_names));
for I = 1:length(cluster_names)
    tp_bounds(I) = ctp_extract_score([logdir,cluster_names{I},'/fgreedy.log']);
end

end

