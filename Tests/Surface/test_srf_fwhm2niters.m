%% test_srf_fwhm2niters
% Tests of the srf_fwhm2niters function
%--------------------------------------------------------------------------
% Octahedron: 6 vertices, 8 faces, each vertex has 4 neighbours
% (vertex 1 is next to 3, 4, 5, 6 but not to 2)
oct.vertices = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
oct.faces = [1 3 5; 3 2 5; 2 4 5; 4 1 5; 3 1 6; 2 3 6; 4 2 6; 1 4 6];
oct.nvertices = 6;
oct.nfaces = 8;
% surface area per vertex of the octahedron: 8*(sqrt(3)/2)/6
area_pv = 8*(sqrt(3)/2)/6;
ff = 1.478*(69/40);

%% Known value on the octahedron
FWHM = 2;
expected = floor(ff*1.14*4*pi*FWHM^2/(8*log(2)*7*area_pv) + 0.5);
assert(expected == 3)   % by hand: floor(3.26 + 0.5)
assert(srf_fwhm2niters(FWHM, oct) == expected)

%% FWHM = 0 gives 0 iterations
assert(srf_fwhm2niters(0, oct) == 0)

%% The fudge factor
assert(srf_fwhm2niters(FWHM, oct, 1) == floor(1.14*4*pi*FWHM^2/(8*log(2)*7*area_pv) + 0.5))
assert(srf_fwhm2niters(FWHM, oct, 0) == 0)

%% fs5 sphere
srf = loadsrf('fs5', 'sphere');
fa = srf_face_area(srf.lh);
apv = sum(fa)/srf.lh.nvertices;
niters = srf_fwhm2niters(8, srf.lh);
assert(niters == floor(ff*1.14*4*pi*64/(8*log(2)*7*apv) + 0.5))

%% niters increases with the FWHM
n = zeros(1, 5);
for F = 1:5
    n(F) = srf_fwhm2niters(4*F, srf.lh);
end
assert(all(diff(n) >= 0))
assert(n(end) > n(1))

disp('test_srf_fwhm2niters: all tests passed')
