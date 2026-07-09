%% test_ipt_free_functions
% Validates the toolbox-free Image Processing replacements against the
% original Image Processing Toolbox functions. Run this with the toolbox
% available to confirm the replacements are equivalent; the replacements
% themselves do not need the toolbox.
%
%   conncomp_bw   vs  bwconncomp
%   box_dilate    vs  imdilate( ., ones(...) )
%   fill_holes    vs  imfill( ., 'holes' )
%   upsample3_nn  vs  imresize3( ., scale )   (nearest, mask data)
%--------------------------------------------------------------------------
rng(0)
labels = {'FAIL', 'PASS'};
tol_report = @(name, ok) fprintf('%-40s %s\n', name, labels{logical(ok)+1});

%% conncomp_bw vs bwconncomp -- 2D
for conn = [4 8]
    for t = 1:20
        BW = rand(15,18) > 0.55;
        A = bwconncomp(BW, conn);
        B = conncomp_bw(BW, conn);
        ok = A.NumObjects == B.NumObjects && ...
             isequal(sort(cellfun(@numel,A.PixelIdxList)), ...
                     sort(cellfun(@numel,B.PixelIdxList))) && ...
             isequal(sort(cell2mat(A.PixelIdxList(:))), ...
                     sort(cell2mat(B.PixelIdxList(:))));
        tol_report(sprintf('conncomp_bw 2D conn=%d trial %d', conn, t), ok);
        assert(ok)
    end
end

%% conncomp_bw vs bwconncomp -- 3D
for conn = [6 18 26]
    for t = 1:10
        BW = rand(8,9,7) > 0.5;
        A = bwconncomp(BW, conn);
        B = conncomp_bw(BW, conn);
        ok = A.NumObjects == B.NumObjects && ...
             isequal(sort(cellfun(@numel,A.PixelIdxList)), ...
                     sort(cellfun(@numel,B.PixelIdxList)));
        tol_report(sprintf('conncomp_bw 3D conn=%d trial %d', conn, t), ok);
        assert(ok)
    end
end

%% box_dilate vs imdilate (dilation and erosion, 2D and 3D)
for D = [2 3]
    for r = 1:3
        if D == 2, BW = rand(20,22) > 0.7; else, BW = rand(10,11,9) > 0.7; end
        se = ones( (2*r+1) * ones(1,D) );
        % dilation
        ok = isequal( logical(imdilate(BW, se)), box_dilate(BW, r) );
        tol_report(sprintf('box_dilate D=%d r=%d dilate', D, r), ok); assert(ok)
        % erosion via De Morgan, as dilate_mask uses it
        ok = isequal( logical(~imdilate(~BW, se)), ~box_dilate(~BW, r) );
        tol_report(sprintf('box_dilate D=%d r=%d erode', D, r), ok); assert(ok)
    end
end

%% fill_holes vs imfill(.,'holes') -- 2D
for t = 1:30
    BW = rand(25,30) > 0.4;
    ok = isequal( logical(imfill(BW,'holes')), fill_holes(BW) );
    tol_report(sprintf('fill_holes trial %d', t), ok); assert(ok)
end

%% upsample3_nn vs imresize3 nearest -- size and content on mask data
for t = 1:10
    vol = double( rand(9,11,7) > 0.5 );
    A = imresize3(vol, 2, 'nearest');
    B = upsample3_nn(vol, 2);
    ok = isequal(size(A), size(B)) && isequal(A, B);
    tol_report(sprintf('upsample3_nn trial %d', t), ok); assert(ok)
end

fprintf('\nAll IPT-free replacement tests passed.\n');
