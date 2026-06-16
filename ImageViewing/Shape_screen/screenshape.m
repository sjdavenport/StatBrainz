function screen_size = screenshape(shape, color)
% SCREENSHAPE sets the current figure position and optionally its background color.
%--------------------------------------------------------------------------
% ARGUMENTS
% Mandatory
%  shape    a 1x4 vector specifying the figure position [left, bottom, width, height]
% Optional
%  color    if provided, sets the figure background to white (any value triggers this)
%--------------------------------------------------------------------------
% OUTPUT
% screen_size   a 1x4 vector specifying the screen size [left, bottom, width, height]
%--------------------------------------------------------------------------
% EXAMPLES
% 
%--------------------------------------------------------------------------
% AUTHOR: Samuel Davenport
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
% set(gcf, 'position', [0,0,1500,642])
% set(gcf, 'position', [0,35,1500,607])
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% pause(0.00001);
% frame_h = get(handle(gcf),'JavaFrame');
% set(frame_h,'Maximized',1);
% global TYPE

% set(groot, 'defaultFigureWindowState', 'maximized');

% monitorPositions = get(0, 'MonitorPositions');
% set(gcf, 'position', [0,0,monitorPositions(3:4)])

% Set the figure position to cover the entire screen
set(gcf, 'Position', shape);

if nargin > 1
    set(gcf, 'Color', 'white');
end

end

% if ~isempty(strfind(pwd, '12SDa'))
%     set(gcf, 'position', [0,35,1500,607])
% elseif strcmp(TYPE, 'sdavenport')
%     set(gcf, 'position', [0,0,1512, 982])
% else
%     set(get(groot, 'Children'), 'WindowState', 'maximized');
% end
