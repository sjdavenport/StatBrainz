function cope_display( lower, upper, muhat, thresh, truth, colorswitch, docontours, true_contourlinewidth, contourlinewidth )
% cope_display( lower, upper, muhat, thresh, truth ) displays cope sets
%--------------------------------------------------------------------------
% ARGUMENTS
% lower: an array of size dim giving the lower set
% upper: an array of size dim giving the upper set
% muhat: an array of size dim giving the estatimated mean of the data
% thresh: the threshold at which to cut
% truth: an array of size dim giving the true means
%--------------------------------------------------------------------------
% EXAMPLES
% dim = [100,100]; D = length(dim); nsubj = 25; FWHM = 4; c = 1;
% mu = peakgen(2, 30, 10, dim); mask = ones(dim);
% noise = noisegen( dim, nsubj, FWHM );
% data = noise + mu; data_mean = mean(data,3);
% % Plot FDR cope sets
% [lower_fdr, upper_fdr] = fdr_cope_sets( data, c );
% cope_display( lower_fdr, upper_fdr, data_mean, c, mu )
% 
% % Plot SSS cope sets (with contours)
% [lower_sss, upper_sss, ~] = sss_cope_sets(data, mask, c);
% cope_display( lower_sss, upper_sss, data_mean, c, mu, 0, 1 )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
dim = size(lower);
if ~isequal(size(upper), dim)
    error('The dimensions of the upper and lower inputs must be the same')
end

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'colorswitch', 'var' )
   % Default value
   colorswitch = 0;
end

if ~exist( 'docontours', 'var' )
   % Default value
   docontours = 0;
end

if ~exist( 'truth', 'var' )
   % Default value
   truth = NaN;
end

if ~exist( 'contourlinewidth', 'var' )
   % Default value
   contourlinewidth = 3;
end

if ~exist( 'true_contourlinewidth', 'var' )
   % Default value
   true_contourlinewidth = 3;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
index = repmat( {':'}, 1, length(dim));
redset = zeros([dim,3]);
blueset = zeros([dim,3]);

redset(index{:}, 1) = upper;
blueset(index{:}, 3) = lower;

imagesc(blueset);
% axis square
hold on

if colorswitch
   background = colorRegion(1-lower, 'grey');
   im1 = imagesc(background);
   set(im1,'AlphaData',1-lower);
   hold on
end

if nargin >= 3
    excursion = muhat > thresh;
    yellowset = colorRegion(excursion, 'yellow');
    im2 = imagesc(yellowset);
    set(im2,'AlphaData',excursion);
end

im3 = imagesc(redset);
set(im3,'AlphaData',upper);

if docontours == 1
   plot_contour( excursion+0, 0.5, 3, contourlinewidth, 'yellow' ) 
   if any(lower(:))
       plot_contour( lower+0, 0.5, 3, contourlinewidth, 'blue' )  % +0 to convert from logical to numeric
   end
   if any(upper(:))
       plot_contour( upper+0, 0.5, 3, contourlinewidth, 'red' ) 
   end
end

if ~isnan(truth)
    plot_contour( truth, thresh, 3, true_contourlinewidth )
%     true_boundary = bndry_voxels( truth, "full" );
%     if colorswitch
%         whiteset = colorRegion(ones(dim), 'black');
%     else
%         whiteset = colorRegion(ones(dim), 'white');
%     end
%     im4 = imagesc(whiteset);
%     set(im4,'AlphaData',true_boundary);
end
axis off
% set(gcf, 'position', [0,0,1500,1500])

end

%     yellowset = zeros([dim,3]);
%     excursion = muhat > thresh;
%     yellowset(index{:}, 1) = excursion;
%     yellowset(index{:}, 2) = excursion;
