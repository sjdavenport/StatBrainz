function mask = gen_mask( data, use_MNI, make3D )
% GEN_MASK generates the intersection of all of the subject masks with
% themselves and the MNImask.
%--------------------------------------------------------------------------
% ARGUMENTS
% 
%--------------------------------------------------------------------------
% OUTPUT
% 
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

