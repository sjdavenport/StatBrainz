function padded_im = pad_im( im, padding )
% NEWFUN
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
if ~exist( 'opt1', 'var' )
   % Default value
   opt1 = 0;
end

%%  Main Function Loop
%--------------------------------------------------------------------------
if padding(1) > 0
    % Pad the image
    padded_im = zeros(size(im)+ 2*padding);
    padded_im((padding(1)+1):end-padding(1), (padding(2)+1):end-padding(2), (padding(3)+1):end-padding(3), (padding(4)+1):end-padding(4)) = im;
else
    % Shrink the image
    padding = abs(padding);
    if length(size(im)) == 3
        padded_im = im((padding(1)+1):end-padding(1), (padding(2)+1):end-padding(2), (padding(3)+1):end-padding(3));
    elseif length(size(im)) == 4
        padded_im = im((padding(1)+1):end-padding(1), (padding(2)+1):end-padding(2), (padding(3)+1):end-padding(3), :);
    end
end
end

