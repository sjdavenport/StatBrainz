% Tests for srf_scb2cope

srf = loadsrf('fs4', 'white');
nv = srf.lh.nvertices;
rng(34)
lower_band = randn(nv, 1);
upper_band = lower_band + 1;
muhat = lower_band + 0.5;
c = 0.2;

%% One hemisphere: the sets are the bands and the mean compared with c
[lower_set, upper_set, contour, yellow_set] = srf_scb2cope(srf.lh, lower_band, upper_band, muhat, c);
assert(isequal(lower_set, upper_band > c))
assert(isequal(upper_set, lower_band > c))
assert(isequal(yellow_set, muhat > c))
assert(all(lower_set >= yellow_set) && all(yellow_set >= upper_set))

%% The contour is the inner contour of the yellow set
assert(isequal(contour, srf_contour(srf.lh, muhat > c) > 0))
assert(all(yellow_set(contour)))
assert(isequal(size(contour), [nv, 1]))

%% Both hemispheres
lb.lh = lower_band; lb.rh = lower_band(end:-1:1);
ub.lh = lb.lh + 1; ub.rh = lb.rh + 1;
mu.lh = lb.lh + 0.5; mu.rh = lb.rh + 0.5;
[lower_set, upper_set, contour, yellow_set] = srf_scb2cope(srf, lb, ub, mu, c);
assert(isequal(lower_set.rh, ub.rh > c) && isequal(upper_set.rh, lb.rh > c))
assert(isequal(yellow_set.lh, mu.lh > c))
assert(isequal(contour.lh, srf_contour(srf.lh, mu.lh > c) > 0))
assert(isequal(contour.rh, srf_contour(srf.rh, mu.rh > c) > 0))
