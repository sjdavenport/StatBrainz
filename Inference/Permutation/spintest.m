function [threshold, rho_store] = spintest( X, Y, srf_sphere, nperm, alpha, show_loader )
% SPINTEST Perform spin test to compute threshold and correlation values.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory arguments:
%   X: A structure such that X.lh and X.rh are vectors of length nvertices
%       consisting of the data from the first map
%   Y: A structure such that X.lh and X.rh are vectors of length nvertices
%       consisting of the data from the second map
%   srf_sphere:  a surface structure such that sphere.lh.vertices and sphere.lh.faces
%            are the vertices and faces of the sphere for the left
%            hemisphere and similarly for the right hemispheres
%
% Optional arguments:
%   nperm: Number of permutations, default is 1000.
%   alpha: Significance level, default is 0.05
%   show_loader: Flag to display loader (default is false).
%--------------------------------------------------------------------------
% OUTPUT
%   threshold: Threshold value computed from the spin test.
%   rho_store: Correlation values stored during the spin test.
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
if ~exist( 'show_loader', 'var' )
   % Default value
   show_loader = 1;
end

if ~exist( 'alpha', 'var' )
   % Default value
   alpha = 0.05;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
% Generate spins of the first image
[ left_rotations,  right_rotations] = ...
             spin_surface( X, srf_sphere, nperm, 1, show_loader );
         
% Compute the correlations between the spun surfaces and the data
rho_store = zeros(1, nperm);
% for I = 1:nperm
%     rho_store(I) = corr([left_rotations(:,I);right_rotations(:,I)],[Y.lh;Y.rh], 'rows','complete');
% end
allY = [Y.lh;Y.rh];
orignanlocs = isnan(allY);

store = zeros(1, nperm);
for I = 1:nperm
    allperm = [left_rotations(:,I);right_rotations(:,I)];
    permnanlocs = isnan(allperm);
    jointnanlocs = (orignanlocs + permnanlocs) > 0;
    rho_store(I) = corr(allperm(~jointnanlocs),allY(~jointnanlocs),'rows','complete');
    store(I) = sum(permnanlocs);
end

threshold = prctile(rho_store, 100*(1-alpha) );

end

