% Tests for fdrthresh

%% Upper tail p-values: the threshold is the t-value of the largest rejected p-value
df = 19;
tvals = [5, 4, 3.5, 0.2, -1];
pvals = 1 - tcdf(tvals, df);
rej = fdrBH(pvals);
maxp = max(pvals(rej));
thresh = fdrthresh(pvals, rej, df);
% |thresh| is the t-value that gives maxp
assert(abs(abs(thresh) - tinv(1 - maxp, df)) < 1e-8)
% the threshold must be positive: t-values above it are rejected
assert(abs(thresh - tinv(1 - maxp, df)) < 1e-8)
assert(all(tvals(rej) >= thresh - 1e-8))

%% Logical index with a single rejection
pvals = [0.001, 0.5, 0.9];
thresh = fdrthresh(pvals, logical([1, 0, 0]), 10);
assert(abs(abs(thresh) - tinv(0.999, 10)) < 1e-8)

%% No rejections gives an empty threshold
thresh = fdrthresh([0.5, 0.9], false(1, 2), 10);
assert(isempty(thresh))
