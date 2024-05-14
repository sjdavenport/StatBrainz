function [tfce_im] = tfce(image,H,E,connectivity,dh,h0)
% tfce(image,H,E,connectivity,dh) performs TFCE
%--------------------------------------------------------------------------
% ARGUMENTS
%  image: a 2D or 3D matlab array
%  H: height exponent (default is 2)
%  E: extent exponent (default is 0.5)
%  connectivity: connectivity used to compute the connected components
%  dh: size of steps for cluster formation. Default is 0.1.
%  h0: the cluster forming threshold - Default is h0 = 3.1.
%--------------------------------------------------------------------------
% OUTPUT
%  tfce_im: an array with the same size as image giving the TFCE transformed
%           image
%--------------------------------------------------------------------------
% EXAMPLES
% dim = [50,50]; nsubj = 50; FWHM = 2;
% Sig = 0.1*peakgen(1, 10, 8, dim);
% data = wfield(dim, nsubj);
% data.field = data.field + Sig;
% tstat = convfield_t(data, FWHM);
% tstat_tfce = tfce(tstat.field,2,0.5,8,0.05)
% subplot(1,2,1)
% surf(tstat.field)
% subplot(1,2,2)
% surf(tstat_tfce)
%--------------------------------------------------------------------------
% Copyright (C) - 2016 - Mark Allen Thornton 
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------
D = length(size(image));
if ~exist( 'connectivity', 'var' )
   % Default value
   if D == 2
       connectivity = 8;
   elseif D == 3
       connectivity = 26;
   end
end

if ~exist( 'H', 'var' )
   % Default value
   H = 2;
end

if ~exist( 'h0', 'var' )
   % Default value
   h0 = 0;
end

if ~exist( 'E', 'var' )
   % Default value
   E = 0.5;
end

if ~exist( 'dh', 'var' )
   % Default value
   dh = 0.1;
end

% set cluster thresholds
threshs = h0:dh:max(image(:));
threshs = threshs(2:end);
nthreshs = length(threshs);

% find number of voxels
nvox = length(image(:));

% find connected components
vals = zeros(nvox,1);
cc = arrayfun(@(x) bwconncomp(bsxfun(@ge,image,x),connectivity), threshs);
for h = 1:nthreshs
    clustsize = zeros(nvox,1);
    ccc = cc(h);
    voxpercc = cellfun(@numel,ccc.PixelIdxList);
    for c = 1:ccc.NumObjects
        clustsize(ccc.PixelIdxList{c}) = voxpercc(c);
    end
    % calculate transform
    curvals = (clustsize.^E).*(threshs(h)^H);
    vals = vals + curvals;
end
tfce_im = NaN(size(image));
tfce_im(:) = vals.*dh;

end

