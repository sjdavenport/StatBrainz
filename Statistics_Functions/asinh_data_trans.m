function transformed_data = asinh_data_trans( data, param)
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

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist('stdsmo', 'var')
    stdsmo = 0;
end

if ~exist('param', 'var')
    param = 1;
end

%%  Main Function Loop
%--------------------------------------------------------------------------

% Standardize
% std_dev = std(lat_data.field, 0, lat_data.D + 1);
std_dev = std(data);

% Standardize without demeaning
standard_data = data./std_dev; 

% Transform the data
transformed_data = asinh(standard_data*param)/param;

end

