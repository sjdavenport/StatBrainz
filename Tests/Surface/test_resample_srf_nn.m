%% test_resample_srf_nn
% Tests of the resample_srf_nn function
%--------------------------------------------------------------------------
srf3 = loadsrf('fs3', 'sphere');
srf4 = loadsrf('fs4', 'sphere');

%% Same surface gives the identity
nn = resample_srf_nn(srf3.lh, srf3.lh);
assert(isequal(nn(:), (1:srf3.lh.nvertices)'))

%% fs3 vertices are the first 642 vertices of fs4
nn = resample_srf_nn(srf4.lh, srf3.lh);
assert(numel(nn) == srf3.lh.nvertices)
assert(isequal(nn(:), (1:642)'))

%% Match a brute force nearest neighbour search
nn = resample_srf_nn(srf3.lh, srf4.lh);
Vin = double(srf3.lh.vertices);
Vout = double(srf4.lh.vertices);
nn_bf = zeros(size(Vout, 1), 1);
for I = 1:size(Vout, 1)
    [~, nn_bf(I)] = min(sum((Vin - Vout(I,:)).^2, 2));
end
d_fun = sum((Vin(nn,:) - Vout).^2, 2);
d_bf = sum((Vin(nn_bf,:) - Vout).^2, 2);
assert(max(abs(d_fun - d_bf)) < 1e-8)
assert(min(nn) >= 1 && max(nn) <= srf3.lh.nvertices)

%% Both hemispheres
nn = resample_srf_nn(srf4, srf3);
assert(isfield(nn, 'lh') && isfield(nn, 'rh'))
assert(isequal(nn.lh(:), (1:642)'))
assert(isequal(nn.rh(:), (1:642)'))

%% A struct with only the left hemisphere
clear srfin srfout
srfin.lh = srf4.lh;
srfout.lh = srf3.lh;
nn = resample_srf_nn(srfin, srfout);
assert(isfield(nn, 'lh') && ~isfield(nn, 'rh'))
assert(isequal(nn.lh(:), (1:642)'))

disp('test_resample_srf_nn: all tests passed')
