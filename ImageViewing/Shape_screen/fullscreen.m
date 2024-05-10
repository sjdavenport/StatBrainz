function screen_size = fullscreen
% fullscreen makes the plot fullscreen
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

screen_size = get(0, 'ScreenSize');
% Set the figure position to cover the entire screen
set(gcf, 'Position', screen_size);

end

% if ~isempty(strfind(pwd, '12SDa'))
%     set(gcf, 'position', [0,35,1500,607])
% elseif strcmp(TYPE, 'sdavenport')
%     set(gcf, 'position', [0,0,1512, 982])
% else
%     set(get(groot, 'Children'), 'WindowState', 'maximized');
% end
