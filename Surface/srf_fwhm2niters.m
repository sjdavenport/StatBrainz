function niters = srf_fwhm2niters( FWHM, srf, fudge_factor )
% NEWFUN
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%  srf
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% srf = loadsrf('fs5', 'sphere')
% niters = srf_fwhm2niters( 8, srf )
%
% path4bert ='C:\Users\12SDa\davenpor\Data\Surface\freesurfer_files\bert\surf\';
% bert_srf = fs2surf([path4bert, 'lh.sphere.reg'], [path4bert,'rh.sphere.reg'])
% niters = srf_fwhm2niters( 8, bert_srf )
%--------------------------------------------------------------------------
% Copyright (C) - 2023 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------
if nargin < 3
    % fudge_factor = 1.478^2; 
    fudge_factor = 1.478*(69/40); % Included in order to match the freesurfer smoothing
    % the factor of 1.478 matches what freesurfer says it does, the factor
    % of 69/40 is needed so that the smoothing really does match!
end

%%  Add/check optional values
%--------------------------------------------------------------------------
face_area = srf_face_area(srf);
surface_area = sum(face_area);
surface_area_per_vertex = surface_area/srf.nvertices;

%%  Main Function Loop
%--------------------------------------------------------------------------
numerator = 1.14*4*pi*FWHM^2;
denominator = 8*log(2)*7*surface_area_per_vertex;
niters = floor(fudge_factor*numerator/denominator + 0.5);

end

