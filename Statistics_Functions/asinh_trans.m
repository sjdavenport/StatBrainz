function transformed_data = asinh_trans( data, param )
% ASINH_TRANS( lat_data ) transforms data with the inverse hyperbolic sinh
% transformation.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  lat_data    a field of data on a lattice. For best performance this
%              field should be made up of at least 10 subjects. 
% Optional
%  stdsmo      a smoothing parameter for the standard deviation. Default is
%              not to smooth, i.e. to set stdsmo = 0.
%  usetrans    different transformation options (to be specified!)
%--------------------------------------------------------------------------
% OUTPUT
%  lat_data    the Gaussianized field of data
%  standardized_field  (X_n - muhat)/sigmahat for 1 <= n <=leq N
%  standard_data  X_n/sigmahat for 1 <= n <= N
%--------------------------------------------------------------------------
% EXAMPLES
% data = randn([20,20,50]);
% transformed_data = asinh_data_trans( data )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------

% Transform the data
transformed_data = asinh(data*param)/param;

end

