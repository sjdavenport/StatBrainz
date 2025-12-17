import nibabel as nib
from scipy.io import savemat
from pathlib import Path

# Path to GIFTI file
gifti_path = Path(XXX)

# Load GIFTI surface
gii = nib.load(gifti_path)

# Extract vertices and faces
vertices = gii.darrays[0].data
faces = gii.darrays[1].data + 1  # MATLAB is 1-based

# Output .mat path (same directory)
mat_path = gifti_path.with_suffix('.mat')

# Save to .mat
savemat(mat_path, {
    'vertices': vertices,
    'faces': faces
})

print(f"Saved {mat_path}")
