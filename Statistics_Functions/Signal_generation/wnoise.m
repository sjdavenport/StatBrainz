function noise = wnoise( masksize, fibersize, field_type, field_params )
% WNOISE( masksize, fibersize, field_type, field_params ) generates white
% noise and returns it directly as a numeric array (rather than wrapping it
% in a Fields object). It is a dependency-free replacement for wfield when
% only the raw noise array is required: the 'T' and 'P' field types use the
% in-repo trnd/pearsrnd, so no Statistics Toolbox is needed.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  masksize    a 1 x D vector giving the size of the field domain, e.g.
%              [50, 50] for a 2D field on a 50 x 50 grid.
% Optional
%  fibersize   a scalar (or vector) giving the size of the fiber, i.e. the
%              number of realisations / subjects. Default is 1.
%  field_type  a string giving the type of field. 'N': normal (Gaussian),
%              'T': t-field, 'L': Laplacian, 'S'/'s': skew, 'S2': symmetric
%              skew, 'U': uniform, 'P': Pearson. Default is 'N'.
%  field_params   if field_type is 'T' this is the degrees of freedom; if
%                 field_type is 'L' this is the scale of the Laplacian.
%--------------------------------------------------------------------------
% OUTPUT
% noise       a numeric array of size [masksize, fibersize] containing the
%             requested white noise.
%--------------------------------------------------------------------------
% EXAMPLES
% % Scalar Gaussian field on a 4 x 2 x 3 grid
% noise = wnoise( [4 2 3] );
%
% % 100 subjects of 2D Gaussian noise
% noise = wnoise( [50 50], 100 );
%
% % Degree 3 t-field
% noise = wnoise( [5 5], 10, 'T', 3 );
%
% % Scale 1 Laplacian field
% noise = wnoise( [5 5], 10, 'L', 1 );
%--------------------------------------------------------------------------
% Copyright (C) - 2026 - Samuel Davenport
%--------------------------------------------------------------------------

%% Check mandatory input
%--------------------------------------------------------------------------
if ~isnumeric( masksize ) || ~( isvector( masksize ) )
    error( 'masksize must be a 1xD or Dx1 numerical vector.' )
end
masksize = masksize(:)';   % ensure a row vector

%% Add/check optional input
%--------------------------------------------------------------------------
if ~exist( 'fibersize', 'var' )
    fibersize = 1;
end

if ~exist( 'field_type', 'var' )
    field_type = 'N';
end

fibersize = fibersize(:)';   % ensure a row vector

% Full output size: domain dimensions followed by the fiber dimensions
outsize = [ masksize, fibersize ];

%% Main function
%--------------------------------------------------------------------------
if strcmp(field_type, 'normal') || strcmp(field_type, 'N')
    noise = randn( outsize );
elseif strcmp(field_type, 't') || strcmp(field_type, 'T')
    noise = trnd( field_params, outsize );
elseif strcmp(field_type, 'l') || strcmp(field_type, 'L')
    % Laplacian via inverse-CDF sampling (avoids the external rlap):
    % X = -scale * sign(U) .* log(1 - 2|U|),  U ~ Uniform(-1/2, 1/2)
    u = rand( outsize ) - 1/2;
    noise = -field_params * sign(u) .* log( 1 - 2*abs(u) );
elseif strcmp(field_type, 'skew') || strcmp(field_type, 'S') || strcmp(field_type, 's')
    noise = ( randn( outsize ).^2 - 1 ) / sqrt(2);
elseif strcmp(field_type, 's2') || strcmp(field_type, 'S2')
    noise = ( randn( outsize ).^2 - 1 ) / sqrt(2) ...
          - ( randn( outsize ).^2 - 1 ) / sqrt(2);
elseif strcmp(field_type, 'uniform') || strcmp(field_type, 'U') || strcmp(field_type, 'u')
    noise = rand( outsize ) - 1/2;
elseif strcmp(field_type, 'p') || strcmp(field_type, 'pearson') || strcmp(field_type, 'P')
    noise = pearsrnd( 0, 1, 1, 4, masksize, fibersize );
else
    error( 'This field type has not been implemented' )
end

end
