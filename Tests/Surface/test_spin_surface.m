%% test_spin_surface
% Tests of the spin_surface function
%--------------------------------------------------------------------------
rng(1)
sphere = loadsrf('fs3', 'sphere');
nv = sphere.lh.nvertices;
clear data
data.lh = randn(nv, 1);
data.rh = randn(nv, 1);
nperm = 5;

%% Output sizes and the original data in the first column
[left, right] = spin_surface(data, sphere, nperm, 1, 0);
assert(isequal(size(left), [nv, nperm]))
assert(isequal(size(right), [nv, nperm]))
assert(isequal(left(:,1), data.lh))
assert(isequal(right(:,1), data.rh))

%% Each rotation only uses values from the data
assert(all(ismember(left(:), data.lh)))
assert(all(ismember(right(:), data.rh)))
assert(~isequal(left(:,2), data.lh))

%% Without the original there are nperm - 1 rotations
[left0, right0] = spin_surface(data, sphere, nperm, 0, 0);
assert(isequal(size(left0), [nv, nperm - 1]))
assert(isequal(size(right0), [nv, nperm - 1]))

%% Same seed gives the same rotations
rng(5)
[leftA, rightA] = spin_surface(data, sphere, 3, 1, 0);
rng(5)
[leftB, rightB] = spin_surface(data, sphere, 3, 1, 0);
assert(isequal(leftA, leftB) && isequal(rightA, rightB))

%% Match a direct rotation of each hemisphere (Alexander-Bloch 2018)
rng(7)
[left, right] = spin_surface(data, sphere, 2, 1, 0);
rng(7)
A = normrnd(0, 1, 3, 3);
[TL, temp] = qr(A);
TL = TL * diag(sign(diag(temp)));
if det(TL) < 0
    TL(:,1) = -TL(:,1);
end
R = eye(3); R(1,1) = -1;
TR = R * TL * R;
VL = double(sphere.lh.vertices);
VR = double(sphere.rh.vertices);
rotL = VL * TL;
rotR = VR * TR;
idxL = zeros(nv, 1);
idxR = zeros(nv, 1);
for I = 1:nv
    [~, idxL(I)] = min(sum((rotL - VL(I,:)).^2, 2));
    [~, idxR(I)] = min(sum((rotR - VR(I,:)).^2, 2));
end
assert(isequal(left(:,2), data.lh(idxL)))
assert(isequal(right(:,2), data.rh(idxR)))

disp('test_spin_surface: all tests passed')
