function X = Xgen( n, m, rho, method )
%XGEN Generate a matrix of size n-by-m according to specified method.
%   X = XGEN(n, m, rho, method) generates a matrix X of size n-by-m according
%   to the specified method.
%--------------------------------------------------------------------------
%   ARGUMENTS:
%   - n: Number of rows of the matrix.
%   - m: Number of columns of the matrix.
%   - rho: Autoregressive parameter for 'ar1' method. For 'equi' methods,
%          it specifies the correlation coefficient and for Gaussian the
%          FWHM of the smoothing kernel.
%   - method: Method of generation. Available options are:
%             - 'ar1': Generates an AR(1) process matrix.
%             - 'equi': Generates a matrix with equicorrelated noise.
%             - 'Gaussian': Generates a matrix with Gaussian noise.
%--------------------------------------------------------------------------
%   OUTPUT:
%   - X: n by m generated matrix according to the specified method.
%--------------------------------------------------------------------------
% EXAMPLES
% X = Xgen( 1000, 1000, 0.7, 'ar1' );
% mean(std(X,0,1))
%
% X = Xgen( 1000, 1000, 0.7, 'ar1', '012');
% mean(std(X,0,1))
%
% X = Xgen( 1000, 1000, [0.7,0.7], 'armix' );
% mean(std(X,0,1))
%
% X = Xgen( 1000, 1000, 0.7, 'equi' );
% mean(std(X,0,1))
%
% X = Xgen( 1000, 1000, 0.7, 'Gaussian' );
% mean(std(X,0,1))
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Main Function Loop
%--------------------------------------------------------------------------
if rho == 0
    X = randn(n,m);
    return
end

if strcmp(method, 'Gaussian')
    noise = randn([n,m]);
    [X, ss] = fconv(noise, rho, 1);
    X = X/sqrt(ss); % Standardize X
elseif strcmp(method, 'ar1')
    X = zeros(n,m);
    X(:,1) = randn(n,1);
    for I = 2:m
        %Generate noise to add
        epsilon = randn(n,1);
        %Calculate the updated column of the X matrix
        X(:,I) = rho*X(:,I-1) + epsilon;
    end
    %Standardize X
    % X = X/sqrt(1/(1-rho^2));
    X = X*sqrt(1-rho^2);
elseif strcmp(method, 'ar1mix')
    X1 = zeros(n,m/2);
    X1(:,1) = randn(n,1);
    for I = 2:(m/2)
        %Generate noise to add
        epsilon = randn(n,1);
        %Calculate the updated column of the X matrix
        X1(:,I) = rho(1)*X1(:,I-1) + epsilon;
    end
    %Standardize X
    X1 = X1/sqrt(1/(1-rho(1)^2));

    X2 = zeros(n,m/2);
    X2(:,1) = randn(n,1);
    for I = 2:(m/2)
        %Generate noise to add
        epsilon = randn(n,1);
        %Calculate the updated column of the X matrix
        X2(:,I) = rho(2)*X2(:,I-1) + epsilon;
    end
    %Standardize X
    X2 = X2/sqrt(1/(1-rho(2)^2));
    X = [X1, X2];
elseif strcmp(method, 'equi')
    X = zeros(n,m);
    w = randn(1,n);
    for I = 1:n
        X(I,:) = sqrt(rho)*w(I) + randn(1, m)*sqrt(1-rho);
    end
elseif strcmp(method, '012')
    % Generate 0, 1, 2, data (demeaned and standardized).
    pbin = 0.5;

    p1 = pbin + rho * (1 - pbin);
    p0 = (1 - p1) * pbin / (1 - pbin);

    X1 = zeros(n, m);
    X2 = zeros(n, m);

    % Initialize the first column of X1
    X1(:, 1) = binornd(1, pbin, n, 1);
    for j = 2:m
        pvec = (p1 - p0) * X1(:, j - 1) + p0;
        X1(:, j) = binornd(1, pvec);
    end

    % Initialize the first column of X2
    X2(:, 1) = binornd(1, pbin, n, 1);
    for j = 2:m
        pvec = (p1 - p0) * X2(:, j - 1) + p0;
        X2(:, j) = binornd(1, pvec);
    end

    X = (X1 + X2 - 2 * pbin) / sqrt(2 * pbin * (1 - pbin));
elseif strcmp(method, '012equi')
    Z1 = Xgen( n, m, rho, 'equi');
    Z2 = Xgen( n, m, rho, 'equi');
    X = (Z1 > 0) + ( Z2>0 );
end

end
%
% Generate noise to add
% epsilon = randn(n,1);
% Calculate the updated column of the X matrix
% X(:,I) = rho*X(:,I-1) + epsilon;
% Standardize X
% X = X/sqrt((1-rho^2));

%     for I = 1:n
%         % Generate white noise
%         epsilon = randn(1, m);
%         % Generate AR(1) process
%         X(I,:) = filter(1, [1, -rho], epsilon);
%         % Standardize X
%         X = X/sqrt((1-rho^2));
% end

% if strcmp(fieldtype, '012')
%     % X = Xgen( n, m, rho, method);
%     % X = X./std(X,0,1);
%     % lower_indices = (X < norminv(1/4));
%     % upper_indices = (X > norminv(3/4));
%     % middle_indicies = logical((1-lower_indices).*(1-upper_indices));
%     % X(lower_indices) = 0;
%     % X(middle_indicies) = 1;
%     % X(upper_indices) = 2;
%     % for I = 1:m
%     %     lower_indices = (X(:,I) < norminv(1/4));
%     %     upper_indices = (X(:,I) > norminv(3/4));
%     %     middle_indicies = logical((1-lower_indices).*(1-upper_indices));
%     %     X(lower_indices,I) = 0;
%     %     X(middle_indicies,I) = 1;
%     %     X(upper_indices,I) = 2;
%     % end
%     % X1 = Xgen( n, m, rho, method);
%     % X2 = Xgen( n, m, rho, method);
%     % X = (X1 > 0) + (X2 > 0);
%     % X = X./sqrt(1/2); % Ensure that X is standardized
%     return
% end