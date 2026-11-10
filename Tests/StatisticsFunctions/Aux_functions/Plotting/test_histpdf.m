%% test_histpdf
% Tests of the histpdf function.
%--------------------------------------------------------------------------
set(0, 'DefaultFigureVisible', 'off')

%% The pdf integrates to 1 and the edges are equally spaced bin centres
rng(1)
data = randn(1, 2000);
[hist_edges, pdf] = histpdf(data);
assert(isequal(size(hist_edges), size(pdf)))
bw = diff(hist_edges);
assert(max(abs(bw - bw(1))) < 1e-10)
assert(abs(sum(pdf)*bw(1) - 1) < 1e-10)
assert(all(pdf >= 0))
assert(hist_edges(1) > min(data) - bw(1) && hist_edges(end) < max(data) + bw(1))

%% Agrees with the standard normal density near 0
rng(2)
data = randn(1, 50000);
[hist_edges, pdf] = histpdf(data);
[~, loc] = min(abs(hist_edges));
assert(abs(pdf(loc) - 1/sqrt(2*pi)) < 0.03)

%% Default FWHM is 0 (no smoothing)
[e1, p1] = histpdf(data);
[e2, p2] = histpdf(data, 0);
assert(isequal(e1, e2) && isequal(p1, p2))

%% Smoothing keeps the size and gives a smoother pdf
[e3, p3] = histpdf(data, 3);
assert(isequal(e3, e1) && isequal(size(p3), size(p1)))
assert(sum(abs(diff(p3, 2))) < sum(abs(diff(p1, 2))))
