function rho_store = spin_test( X, Y, spherepathloc, nperm, show_loader )
% NEWFUN
% Need to pre-multiply by the medial wall beforehand basically
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
% AUTHOR: Samuel Davenport
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
% Generate spins of the first image
[ left_rotations,  right_rotations] = ...
             spin_surface( X{1}, X{2}, spherepathloc, nperm, show_loader );
         
rho_store = zeros(1, nperm);
for I = 1:nperm
    rho_store(I) = corr([left_rotations(I,:),right_rotations(I,:)],[Y{1};Y{2}], 'rows','complete');
end

end

