function padded_im = pad_im( im, lower_padding, upper_padding )
% PAD_IM( im, padding )
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
% Optional
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% Copyright (C) - 2024 - Samuel Davenport
%--------------------------------------------------------------------------

%%  Check mandatory input and get important constants
%--------------------------------------------------------------------------

%%  Add/check optional values
%--------------------------------------------------------------------------
if ~exist( 'upper_padding', 'var' )
   % Default value
   upper_padding = lower_padding;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if lower_padding(1) >= 0
    % Pad the image
    padded_im = zeros(size(im)+ lower_padding + upper_padding);
    if length(size(im)) == 2
        padded_im((lower_padding(1)+1):end-upper_padding(1), (lower_padding(2)+1):end-upper_padding(2)) = im;
    elseif length(size(im)) == 3
        padded_im((lower_padding(1)+1):end-upper_padding(1), (lower_padding(2)+1):end-upper_padding(2), (lower_padding(3)+1):end-upper_padding(3)) = im;
    else
        padded_im((lower_padding(1)+1):end-upper_padding(1), (lower_padding(2)+1):end-upper_padding(2), (lower_padding(3)+1):end-upper_padding(3), (lower_padding(4)+1):end-upper_padding(4)) = im;
    end
else
    % Shrink the image
    lower_padding = abs(lower_padding);
    upper_padding = abs(upper_padding);
    if length(size(im)) == 3
        padded_im = im((lower_padding(1)+1):end-upper_padding(1), (lower_padding(2)+1):end-upper_padding(2), (lower_padding(3)+1):end-upper_padding(3));
    elseif length(size(im)) == 4
        padded_im = im((lower_padding(1)+1):end-upper_padding(1), (lower_padding(2)+1):end-upper_padding(2), (lower_padding(3)+1):end-upper_padding(3), :);
    end
end
end

