function transformed_data = asinh_trans( data, param )
% ASINH_TRANS( data, param ) transforms data with the inverse hyperbolic
% sinh transformation: asinh(data*param)/param.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data    a numeric array of data to transform.
%  param   the scaling parameter for the transformation.
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

%%  Main Function Loop
%--------------------------------------------------------------------------

% Transform the data
transformed_data = asinh(data*param)/param;

end

