function [ rej_locs, nrejections ] = spatialBH( data, FWHM )
% spatialBH implements the BH procedure on spatial data.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data      a Dim by nsubj array of the data
% Optional
%  FWHM     if numeric, the data is smoothed with this FWHM if not provided
%           or NaN then no smoothing is performed
%--------------------------------------------------------------------------
% OUTPUT
% rej_locs  a logical of size Dim with the locations of the rejections
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% TODO
% Extend to other statistics other than one-sample t
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
% Obtain the size of the data input
sD = size(data);

% Calculate the number of subjects
nsubj = sD(end);

% Calculate the number of dimensions
D = length(sD) - 1;

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'opt1', 'var' )
   % default option of opt1
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
% Smooth the data
if ~isnan(FWHM)
    data = fconv(data, FWHM, D);
end

tstateval = mvtstat(data);
pvals = 1 - tcdf(tstateval,nsubj-1);
[ rej_locs, nrejections ] = fdrBH( pvals );

end

