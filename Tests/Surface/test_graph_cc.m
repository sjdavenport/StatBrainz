%% test_graph_cc
% Tests of the graph_cc function
%--------------------------------------------------------------------------
% Adjacency matrix of a path graph 1 - 2 - 3 - 4 - 5 - 6
n = 6;
A = sparse(1:n-1, 2:n, 1, n, n);
A = A + A';

%% Two clusters of different sizes
data = [1 1 0 1 1 1]';
[nclus, occ, sizes, locs] = graph_cc(data, 0.5, A);
assert(nclus == 2)
assert(isequal(sizes(:)', [2 3]))
assert(isequal(occ(:)', [1 1]))
assert(isequal(locs{1}(:)', [1 2]))
assert(isequal(locs{2}(:)', [4 5 6]))

%% Two clusters of the same size
data = [1 1 0 1 1 0]';
[nclus, occ, sizes, locs] = graph_cc(data, 0.5, A);
assert(nclus == 2)
assert(isequal(sizes(:)', 2))
assert(isequal(occ(:)', 2))
assert(isequal(locs{2}(:)', [4 5]))

%% Values equal to the threshold do not survive
data = [1 1 0.5 1 0 0]';
[nclus, ~, ~, locs] = graph_cc(data, 0.5, A);
assert(nclus == 2)
assert(isequal(locs{1}(:)', [1 2]))
assert(isequal(locs{2}(:)', 4))

%% No vertex survives
[nclus, occ, sizes, locs] = graph_cc(zeros(n,1), 0.5, A);
assert(nclus == 0)
assert(isempty(occ) && isempty(sizes) && isempty(locs))

%% Thresholded noise on a surface
rng(1)
srf = loadsrf('fs3', 'white');
data = srf_noise(srf.lh, 10);
thresh = 0;
Asrf = adjacency_matrix(srf.lh);
[nclus, occ, sizes, locs] = graph_cc(data, thresh, Asrf);
assert(nclus == length(locs))
allidx = [locs{:}];
assert(numel(unique(allidx)) == numel(allidx))       % clusters are disjoint
assert(isequal(sort(allidx(:)), find(data > thresh))) % and cover the survivors
% no edges between different clusters
labels = zeros(srf.lh.nvertices, 1);
for I = 1:nclus
    labels(locs{I}) = I;
end
[i, j] = find(Asrf);
both = labels(i) > 0 & labels(j) > 0;
assert(all(labels(i(both)) == labels(j(both))))
% the occurences of the sizes add up to the clusters larger than 1
nbig = sum(cellfun(@numel, locs) > 1);
assert(sum(occ) == nbig)
assert(sum(occ(:).*sizes(:)) == sum(cellfun(@numel, locs(cellfun(@numel, locs) > 1))))

disp('test_graph_cc: all tests passed')
