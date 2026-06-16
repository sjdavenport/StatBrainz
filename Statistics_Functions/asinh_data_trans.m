function transformed_data = asinh_data_trans( data, param)
% ASINH_DATA_TRANS( data, param ) standardizes data by its standard
% deviation and then applies the inverse hyperbolic sinh transformation.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data    a numeric array of data to transform.
% Optional
%  param   the scaling parameter for the transformation. Default is 1.
%--------------------------------------------------------------------------
% OUTPUT
%  transformed_data    the transformed data, same size as data.
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

