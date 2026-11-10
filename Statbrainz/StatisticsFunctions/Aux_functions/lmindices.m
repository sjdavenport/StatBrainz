function [ lmarrayindices, lmind, peakvals ] = lmindices( Y, top, mask, CC )
% LMINDICES( Y, top, mask, CC ) finds the top local maxima of an image,
% given a connectivity criterion CC, that lie within a specified mask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  Y               a 1, 2 or 3 dimensional array of real values
% Optional
%  top             the number of top local maxima to report. Take
%                  top = 'all' to report all of the maxima. Default is 1.
%  mask            a 0/1 mask of the same size as Y. Maxima on the
%                  boundary of the mask are not counted. Default is
%                  ones(size(Y)).
%  CC              the connectivity criterion. Default is 8 in 1D and 2D
%                  and 26 in 3D.
%--------------------------------------------------------------------------
% OUTPUT
%  lmarrayindices  a D by npeaks array of the peak locations
%  lmind           an npeaks by 1 array of the linear indices of the peaks
%  peakvals        an npeaks by 1 array of the values of Y at the peaks
%--------------------------------------------------------------------------
% Copyright (C) - 2020 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist('top', 'var')
    top = 1;
elseif strcmp(top, 'all')
    top = numel(Y);
elseif ~isnumeric(top)
    error("top must be a number or 'all'")
end
Y = squeeze(Y);
Ydim = size(Y);
D = length(Ydim); %Note in the D = 1 case we still take D = 2 and use a 
%connectivity criterion of 8 as this is equivalent to a connectivity criterion of 2!

if ~exist('mask', 'var')
    mask = ones(Ydim);
end
if ~isequal(size(mask), size(Y))
    error('The mask must be the same size as Y')
end

if ~exist('CC', 'var')
    if D == 2
        CC = 8;
    elseif D == 3
        CC = 26;
    else
        error('NotworkedoutD>3yet')
    end
end

r = 0.1;
[a,b,c] = ndgrid(r*(1:size(Y,1)), r*(1:size(Y,2)), r*(1:size(Y,3)));
ramp = min(Y(:)) - (a+b+c);
Y(logical(1-mask)) = ramp(logical(1-mask));

indices = find(imregionalmax(Y, CC).*mask); 
%ensures that the boundary of the mask are not calculated as local maxima 

[~, sorted_lm_indices] = sort(Y(indices), 'descend');
top = min(top, length(sorted_lm_indices));
lmind = indices(sorted_lm_indices(1:top)); %choose the top indices and return with top first second second etcetera

if D == 2
    [lmarrayindicesx,lmarrayindicesy]  = ind2sub(Ydim, lmind);
    lmarrayindices = [lmarrayindicesx, lmarrayindicesy]';
elseif D == 3
    [lmarrayindicesx,lmarrayindicesy, lmarrayindicesz]  = ind2sub(Ydim, lmind);
    lmarrayindices = [lmarrayindicesx, lmarrayindicesy, lmarrayindicesz]';
end

if D == 2
    if Ydim(1) == 1
        lmarrayindices = lmarrayindicesy;
    elseif Ydim(2) == 1
        lmarrayindices = lmarrayindicesx;
    end
end

% Obtain the values at the peaks
peakvals = Y(lmind);

% Return a column vector if the dimension is 1
% if D == 1
%     lmarrayindices = lmarrayindices';
%     lmind = lmind';
%     peakvals = peakvals';
% end

end
