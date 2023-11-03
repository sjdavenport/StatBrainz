%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%    This script tests the clustertdp_lowerbound function
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %% 3D Examples
%% Simple 3D example
loadcluster92 = load('./cluster92.mat'); 
CL = [loadcluster92.cluslocs.x, loadcluster92.cluslocs.y, loadcluster92.cluslocs.z ];
clustertdp_lowerbound(loadcluster92.cluslocs, 61, 3)

%% %% 1D Examples
%% Simple 1D example

%% %% 2D Examples
%% Simple 2D example
