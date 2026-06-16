function im2 = viewdata( data, brain_mask, region_masks, colors2use, rotate, bounds, alpha_val, outside_color)
% VIEWDATA visualizes a data matrix with a binary brain mask and optional
% region mask overlays.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  data          a 2D data matrix of size [r,c]
%  brain_mask    binary image of size [r,c]; area outside mask is colored black
% Optional
%  region_masks  a cell array of binary region masks of size [r,c]. Default is {NaN}.
%  colors2use    a cell array of color strings for each region mask. Default is {'white'}.
%  rotate        numeric value specifying orientation: 2=transpose, 3=flipud,
%                4=flipud+transpose. Default is 4.
%  bounds        cell array of index ranges used to crop data and masks before
%                display. Default is [] (no cropping).
%  alpha_val     scalar or vector of transparency values for each overlay. Default is 1.
%  outside_color scalar intensity for the color outside the brain mask. Default is 0 (black).
%--------------------------------------------------------------------------
% OUTPUT
% im2   handle to the last imagesc object drawn (the outside-brain color overlay)
%--------------------------------------------------------------------------
% EXAMPLES
% % Brain imaging example
% MNImask = imgload('MNImask');
% mask2D = MNImask(:,:,50);
% lat_data = wfield([91,109]);
% smooth_data = convfield(lat_data, 3);
% region_mask = get_mask('HOsc', 'amygdala');
% viewdata( smooth_data.field, mask2D, region_mask(:,:,23) )
% viewdata( smooth_data.field > 0, mask2D, region_mask(:,:,23) )
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
%--------------------------------------------------------------------------

if ~exist('rotate', 'var')
   rotate = 4; 
end

if ~exist('region_masks', 'var')
    useregionmasks = 0;
    region_masks = {NaN};
else
    useregionmasks = 1;
end

if ~exist('alpha_val', 'var') || isempty(alpha_val)
    alpha_val = ones(1, length(region_masks));
end

if ~exist('outside_color', 'var')
    outside_color = 0;
end

if length(alpha_val) == 1
    alpha_val =  repmat(alpha_val, 1, length(region_masks));
end

if ~iscell(region_masks)
    region_masks = {region_masks};
end

if ~exist('colors2use', 'var') || isempty(colors2use)
    colors2use = repmat({'white'}, 1, length(region_masks));
end

if ~iscell(colors2use)
    colors2use =  repmat({colors2use}, 1, length(region_masks));
end

if length(colors2use) == 1
    colors2use =  repmat(colors2use, 1, length(region_masks));
end

if length(colors2use) ~= length(region_masks)
    error('The number of colors used must be the same as the number of regions');
end

if exist('bounds', 'var')
    if ~isempty(bounds)
        data = data(bounds{:});
        brain_mask = brain_mask(bounds{:});
        if ~isnan(region_masks{1})
            for I = 1:length(region_masks)
                region_masks{I} = region_masks{I}(bounds{:});
            end
        end
    end
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if length(size(data)) < 3
if rotate == 2
    data = data';
    brain_mask = brain_mask';
    for I = 1:length(region_masks)
        region_masks{I} = region_masks{I}';
    end
elseif rotate == 3
    data = flipud(data);
    brain_mask = flipud(brain_mask);
    for I = 1:length(region_masks)
        region_masks{I} = flipud(region_masks{I});
    end
elseif rotate == 4
    data = flipud(data');
    brain_mask = flipud(brain_mask');
    for I = 1:length(region_masks)
        region_masks{I} = flipud(region_masks{I}');
    end
end
end

data_mask = isnan(data);
% im1 = imagesc(nan2zero(data), [0, 0.1849]);
im1 = imagesc(nan2zero(data));
if length(size(data)) < 3
    set(im1,'AlphaData',1-data_mask);
end
hold on

if useregionmasks
    for I = 1:length(region_masks)
        colored_region_mask = colorRegion(region_masks{I}, colors2use{I});
        im2 = imagesc(colored_region_mask);
        set(im2,'AlphaData',alpha_val(I)*region_masks{I});
        hold on
    end
end
% colored_region_mask = zeros([s_data, 3]);
% if strcmp(color, 'white')
%     for I = 1:3
%         colored_region_mask(:,:,I) = region_mask;
%     end
% elseif strcmp(color, 'red')
%     for I = 1:3
%         colored_region_mask(:,:,I) = region_mask;
%     end
% end

% Set the area outside the brain to be black
color = ones([size(brain_mask), 3]).*outside_color;
im2 = imagesc(color);
set(im2,'AlphaData',1-brain_mask);

axis off
% axis image

end

