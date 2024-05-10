function sliderGUI(f2plot, minval, maxval, label)
    % Create figure and axis
    fig = figure('Position', [200, 200, 600, 400]);
    monitorPositions = fullscreen;
    ax = axes('Parent', fig, 'Position', [0.1, 0.2, 0.8, 0.7]);

    avval = (minval + maxval)/2;
    maxmindiff = maxval - minval;
    stepsize = 1/50;
    % Create slider
    slider = uicontrol('Style', 'slider', 'Parent', fig, ...
        'Position', [monitorPositions(4)/2+100, 50, 300, 100], 'Value', avval, 'Min', minval, 'Max', maxval, ...
        'Callback', @slider_callback);
    % label_handle = uicontrol('Style', 'text', 'Parent', fig, 'Position', [monitorPositions(4)/2+200, 90, 100, 30], ...
    %     'String', [label, ' = ', num2str(avval) ], 'HorizontalAlignment', 'center', 'FontSize', 20);

    % Initial plot
    f2plot(avval);

    % text_box_pos = [monitorPositions(4)/3, 120, 75, 30];
    text_box_pos = [monitorPositions(4)/2+225, 90, 75, 30];
    text_box = uicontrol('Style', 'edit', 'Parent', fig, ...
        'Position', text_box_pos, 'String', num2str(avval), ...
        'Callback', @text_box_callback, 'FontSize', 20);

    fixed_label_handle = uicontrol('Style', 'text', 'Parent', fig, 'Position', text_box_pos - [125,0,-50,0], ...
        'String', [label, ' ='], 'HorizontalAlignment', 'right', 'FontSize', 20); % Set initial font size

        % Text box callback function
    function text_box_callback(hObject, ~)
        value = str2double(hObject.String);
        if ~isnan(value) && value >= minval && value <= maxval
            update_slider_value(value);
        else
            % Reset text box to last valid value
            hObject.String = num2str(get(slider, 'Value'));
        end
    end

    ndigits2round = -floor(log10(maxmindiff/100));
    % Slider callback function
    function slider_callback(hObject, ~)
        value = hObject.Value;
        value = round(value, ndigits2round);
        cla(ax);
        f2plot(value);
        % set(label_handle, 'String', [label, ' = ', num2str(value)]);
        set(text_box, 'String', num2str(value));
    end

    function update_slider_value(value)
        % Update slider value
        set(slider, 'Value', value);
        % Update label text based on slider value
        % set(label_handle, 'String', [label, ' = ', num2str(value)]);
        % Update plot
        cla(ax);
        f2plot(value);
    end
end
