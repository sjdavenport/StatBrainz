function screen_size = fullscreen2()
    % Get the screen dimensions first
    screen_size = get(0, 'ScreenSize');
    
    % Check if a figure already exists
    fig = get(groot, 'CurrentFigure');
    
    if isempty(fig)
        % Create a NEW figure already maximized and hidden
        fig = figure('Visible', 'off', 'Units', 'pixels', 'Position', screen_size);
        % Make it visible now that it's the right size
        set(fig, 'Visible', 'on');
    else
        % Resize the EXISTING figure
        set(fig, 'Position', screen_size);
    end
end