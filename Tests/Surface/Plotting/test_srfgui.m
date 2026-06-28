%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the srfgui function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: example inputs are placeholders — verify against intended usage.
srf = loadsrf('fs5', 'white');
noise = srf_noise( srf, 10, 1 );
% srfgui(srf.lh, noise.lh)

% Echo a summary of the result so the test produces visible output.
fprintf('srf_noise returned struct with fields: %s\n', strjoin(fieldnames(noise), ', '));
fprintf('lh noise size [%s], rh noise size [%s]\n', ...
    num2str(size(noise.lh)), num2str(size(noise.rh)));
