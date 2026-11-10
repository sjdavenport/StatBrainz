function [ smoothed_data, ss ] = fast_conv( data, FWHM, D, truncation, dx, adjust_kernel )
% fast_conv( data, sep_kern, D, truncation, dx, adjust_kernel ) provides a fast
% implementation for smoothing data using a separable kernel (e.g. an
% isotropic Gaussian kernel).
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data        a Dim by nsubj array of data
%  FWHM        a numerical value or a vector of length D giving the full
%              width at half maximum with which to smooth the data
% Optional
%  D           the dimension of the input data, if not specified then the
%              data is smoothed assuming that there is only one realisation
%  truncation  either a numeric, a 1 x D vector or a 2 x D array containing
%              the value for the truncation of the kernel in each dimension.
%              If it is a vector the truncation is assumed to be symmetric
%              around the origin, i.e., in the dth dimension the vector the
%              kernel is evaluated on is -truncation(d):dx(d):truncation(d).
%              If it is a numeric the kernel in each dimension is evaluated
%              on the vector -truncation:dx:truncation.
%  dx          either a numeric or a vector which defines the stepsize for
%              the evaluation grid of the kernel, see also truncation
%              description. Default is 1.
%  adjust_kernel  1 by D numeric vector computing the smoothing kernel at
%                 an offset, i.e. K( x + adjust_kernel ) instead of K( x ).
%                 Default is all zeros, i.e. no offset.
%--------------------------------------------------------------------------
% OUTPUT
% smoothed_data     the smoothed data
% ss                the sum of squares of the kernel (useful for ensuring
%                   variance 1 isotropic fields
%--------------------------------------------------------------------------
% DEVELOPER TODOS
% Need to allow calculation of    ss (the sum of squares of the kernel for use
% in noisegen.m
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

if FWHM == 0
    smoothed_data = data;
    ss = 1;
    return
end

%% Check mandatory input and get important constants
%--------------------------------------------------------------------------

% Find the dimension, of the data if not provided. Here it is assumed that
% nsubj = 1.
s_data = size( data );

% If D is not provided the data is smoothed assuming that nsubj = 1
if ~exist( 'D', 'var' )
    s_data = size( data );
    D = length( s_data );
    if D == 2
        if s_data(1) == 1 
            D = 1;
        elseif s_data(2) == 1
            D = 1;
            data = data';
        end
    end
end

if length(FWHM) == 1
    FWHM = repmat(FWHM, 1, D);
end

if ~exist('dx', 'var')
    dx = 1;
end

if ~exist( 'adjust_kernel', 'var' ) || isnan( sum( adjust_kernel(:) ) )
    % set default value
    adjust_kernel = zeros( 1, D );
end

if ~exist('truncation', 'var')
    truncation = ceil(FWHM2sigma(FWHM)*4);
end

% Set horizontal to vertical switch
if D == 1 && s_data(1) == 1
    horz2vert = 1;
else
    horz2vert = 0;
end

% Reject if D is to large.
if D > 3
    error( 'fast_conv not coded for dimension > 3' );
end

%% Check/add optional input
%--------------------------------------------------------------------------

%%% Check/transform truncation input
if numel( truncation(:) ) == 1  
    % Make truncation a 2 x D array.
    truncation = truncation * ones( [ 2 D ] );
    
elseif numel( truncation(:) ) == D
    % Make truncation a 2 x D array.
    if size( truncation, 1 ) == 1
        truncation = [ truncation; truncation ];
    else
        truncation = [ truncation, truncation ]';
    end
    
elseif all( size( truncation ) ~= [ 2 D ] )
    error( strcat( "If you want to specify truncation in",...
                   " every dimension then truncation must be 2 x D." ) )
end

%%% Check/transform dx input
if ~exist( 'dx', 'var' )
    % Set dx default.
    dx = ones( [ 1 D ] );
    
elseif numel( dx(:) ) == 1
    % Make dx a vector if numeric.
    dx = dx * ones( [ 1 D ] );
    
end

%%% Check adjust_kernel input
if ~exist( 'adjust_kernel', 'var' ) || isnan( sum( adjust_kernel(:) ) )
    % set default value
    adjust_kernel = zeros( 1, D );
    
elseif length( adjust_kernel ) ~= D
    error( strcat( 'The kernel adjustment must be of the ',...
                   'same dimension as the data, ensure that length(FWHM) = D!' ) )
end

%% Main function
%--------------------------------------------------------------------------

%%% If there are multiple subjects run fast_conv on each of them
if ( D < length( s_data ) && D > 1 ) ...
                                  || ( D == 1 && all( s_data > [ 1, 1 ] ) )

    % Preallocate the smoothed_data field
    smoothed_data = zeros( s_data );
    % Get the number of subjects
    index  = repmat( {':'}, 1, D );
    
    % Loop over subjects
    for J = 1:s_data( end )
        [tmp, ss] = fast_conv( squeeze( data( index{:}, J ) ),...
                                            FWHM, D, truncation, dx,...
                                            adjust_kernel );
        smoothed_data( index{:}, J ) = tmp;
    end
    
    return
end

%%% fast_conv for a single subject
% Preallocate a cell array for the truncation vectors
truncation_vecs = cell( [ 1 D ] );

for d = 1:D
    % Specify the values at which to evaluate the dth kernels at
    truncation_vecs{d} = ( -truncation( 1, d ):dx(d):truncation( 2, d ) )...
                         + adjust_kernel( d );
                     
end


% Calculate the kernel at the values in truncation vector
kernel_in_direction = cell( [ 1 D ] );
for d = 1:D
    % Get the kernel in the dth direction evaluate on truncation
    kernel_in_direction{d} = Gker( truncation_vecs{d}, FWHM(d) );
end


%%% Main loop, running convolution with a separable kernel in each direction
if D == 1
    if horz2vert
        data = data';
    end
    
    smoothed_data = conv( data, kernel_in_direction{1}', 'same' );
    
    if horz2vert
        smoothed_data = smoothed_data';
    end
    
    % Calculates the sum of the squares of the kernel
    ss = sum( kernel_in_direction{1}.^2 ) * dx;
    
elseif D == 2
    
    % The kernel in the x direction (x corresponds to the rows of the matrix)
    xside = kernel_in_direction{1}';
    % The kernel in the y direction (y corresponds to the rows of the matrix)
    yside = kernel_in_direction{2};
    
    % Smooth in the x direction
    smoothed_data = convn( data, xside, 'same' );
    % Smooth in the y direction
    smoothed_data = convn( smoothed_data, yside, 'same' );
                      
    % This is the sum of the squares of the kernel in the truncation box,
    % since the kernel is by assumption separable.
     ss = sum(sum( (kernel_in_direction{1}' * kernel_in_direction{2}).^2 )) * dx(1)*dx(2);
    
elseif D == 3
    
    % The kernel in the x direction
    xside = kernel_in_direction{1}';
    % The kernel in the y direction
    yside = kernel_in_direction{2};
    % The kernel in the z direction
    zside = zeros( 1, 1, length( kernel_in_direction{3} ) );
    zside( 1, 1, : ) = kernel_in_direction{3};
    
    % Smooth in the x direction
    smoothed_data = convn( data, xside, 'same' );
    % Smooth in the y direction
    smoothed_data = convn( smoothed_data, yside, 'same' );
    % Smooth in the z direction
    smoothed_data = convn( smoothed_data, zside, 'same' );
    
    % This is the sum of the squares of the kernel in the truncation box,
    % since the kernel is by assumption separable.
    [X,Y,Z] = meshgrid( kernel_in_direction{1}', kernel_in_direction{2}', ...
                        kernel_in_direction{3}' );
    ss = ( X .* Y .* Z ).^2;
    ss = sum(ss(:)) * dx(1)*dx(2)*dx(3);
    
else
    error('fast_conv not coded for dimension > 3')
end

end
