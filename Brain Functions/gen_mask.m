function mask = gen_mask( data, use_MNI, make3D )
% GEN_MASK generates the intersection of all of the subject masks with
% themselves and the MNImask.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data      an nsubj by nvox matrix where each row is a subject's mask
%            vectorized (non-zero entries are in-mask)
% Optional
%  use_MNI   0/1 whether to intersect with the MNI brain mask. Default is 1
%  make3D    0/1 whether to reshape the output mask to [91,109,91]. Default is 1
%--------------------------------------------------------------------------
% OUTPUT
% mask      a binary mask equal to the intersection of all subject masks
%           (and the MNI brain mask if use_MNI=1); either a vector or a
%           91x109x91 array depending on make3D
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.
if nargin < 2
    use_MNI = 1;
end
if nargin < 3
    make3D = 1;
end
global stdsize

if use_MNI
    mask = imgload('MNImask');
    mask = mask(:);
else
    mask = ones(prod(stdsize));
end
[nsubj, ~] = size(data);

for subj = 1:nsubj
    mask = mask.*data(subj, :)';
end

if make3D
   mask = reshape(mask, [91,109,91]); 
end

end

