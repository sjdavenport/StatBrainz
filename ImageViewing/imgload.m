function img = imgload( filename, use_nif )
% IMGLOAD( filename, use_nif ) allows you to load in a .nii or a .nii.gz
% image
%--------------------------------------------------------------------------
% ARGUMENTS
% filename  is the name of the file to load.
%--------------------------------------------------------------------------
% OUTPUT
% img       an array of the numbers in the image
%--------------------------------------------------------------------------
% EXAMPLES
% imgload('MNImask')
%--------------------------------------------------------------------------
% SEE ALSO
% spm_read_vols, spm_vol
global CSI bsloc
mbs_img_loc = [bsloc, 'BrainImages/'];

if strcmp(filename(end-2:end), '.gz')
    use_nif = 0;
    filename = filename(1:end-7);
elseif nargin < 2
    use_nif = 1;
end

if strcmp(filename(end-3:end), '.nii')
    filename = filename(1:end-4);
end

% if ~isnan( str2double(filename(1)) )  || ~isnan( str2double(filename(1:2)) )
%     filename = strcat(CSI,'Samples/',filename, '.nii');
% end

if use_nif == 1
    try
        nif = nifti(strcat(mbs_img_loc, filename,'.nii'));
    catch
        try
            nif = nifti(strcat(CSI, filename,'.nii'));
        catch
            warning('imgload has used your input as a filename it didn''t match a prespecified input.')
            nif = nifti( [filename,'.nii'] ) ;
        end
    end
    img = nif.dat(:,:,:);
else
    try
        img  = spm_read_vols(spm_vol(strcat(mbs_img_loc, filename, '.nii.gz')));
    catch
        try
            img  = spm_read_vols(spm_vol(strcat(CSI, filename, '.nii.gz')));
        catch
            warning('imgload has used your input as a filename it didn''t match a prespecified input.')
            img = spm_read_vols(spm_vol( [filename,'.nii.gz'] ) );
        end
    end
end

end
