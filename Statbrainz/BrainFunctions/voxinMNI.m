function out = voxinMNI( loc )
% VOXINMNI tests whether a given voxel is in the MNI brain.
%--------------------------------------------------------------------------
% ARGUMENTS
% loc   the index of the voxel.
%--------------------------------------------------------------------------
% OUTPUT
% out   gives 1 if in the mask and 0 if not.
%--------------------------------------------------------------------------
% Copyright (C) - 2025 - Samuel Davenport
%--------------------------------------------------------------------------

if length(loc) > 1
    loc = convind(loc);
end
MNI = imgload('MNImask');
out = MNI(loc);

end

