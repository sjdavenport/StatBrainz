function [ hist_edges, smooth_pdf ] = histpdf( data, FWHM )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

if nargin < 2
    FWHM = 0;
end

if nargin < 3
    do_plot = 1
end

h1 = histogram(data);
bw = h1.BinWidth;
hist_edges = h1.BinEdges(1:end-1) + bw/2;
hist_values = h1.Values;
pdf = hist_values/sum(hist_values)/bw;
if FWHM > 0
    smooth_pdf = fast_conv( pdf, FWHM, 1 );
else
    smooth_pdf = pdf;
end
close all
end

