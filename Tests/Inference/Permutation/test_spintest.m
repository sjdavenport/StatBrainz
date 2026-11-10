% Tests for spintest (needs knnsearch, corr and prctile)

srf_sphere = loadsrf('fs4', 'sphere');
srf = loadsrf('fs4', 'white');
rng(8)
X = srf_noise(srf, 4);
Y.lh = randn(srf.lh.nvertices, 1);
Y.rh = randn(srf.rh.nvertices, 1);
nperm = 20;

%% Output sizes and the threshold
[threshold, rho_store] = spintest(X, Y, srf_sphere, nperm, 0.05, 0);
assert(isequal(size(rho_store), [1, nperm]))
assert(isscalar(threshold))
assert(abs(threshold - prctile(rho_store, 95)) < 1e-12)
assert(all(abs(rho_store) <= 1))

%% The first entry is the correlation of the unspun maps
rho_orig = corr([X.lh; X.rh], [Y.lh; Y.rh]);
assert(abs(rho_store(1) - rho_orig) < 1e-10)

%% Default alpha is 0.05
rng(9); [t1, r1] = spintest(X, Y, srf_sphere, nperm, 0.05, 0);
rng(9); [t2, r2] = spintest(X, Y, srf_sphere, nperm);
assert(isequal(r1, r2))
assert(t1 == t2)

%% A map with itself has correlation 1 before spinning
[~, rho_store] = spintest(X, X, srf_sphere, nperm, 0.05, 0);
assert(abs(rho_store(1) - 1) < 1e-10)
assert(all(rho_store(2:end) < 1))
