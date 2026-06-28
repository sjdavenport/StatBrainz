%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the loadsrf function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srf = loadsrf('fs5', 'white');

% Echo a summary of the result so the test produces visible output.
fprintf('loadsrf returned struct with fields: %s\n', strjoin(fieldnames(srf), ', '));
disp(srf)
