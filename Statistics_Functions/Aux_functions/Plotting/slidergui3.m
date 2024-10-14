function sliderGUI3(f2plot, lowerbounds, upperbounds, label1, label2, label3)
    % Create figure and axis
    fig = figure('Position', [200, 200, 800, 600]);
    monitorPositions = fullscreen;
    ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);

    % Initial values
    minval1 = lowerbounds(1);
    minval2 = lowerbounds(2);
    minval3 = lowerbounds(3);

    maxval1 = upperbounds(1);
    maxval2 = upperbounds(2);
    maxval3 = upperbounds(3);

    avval1 = (minval1 + maxval1) / 2;
    avval2 = (minval2 + maxval2) / 2;
    avval3 = (minval3 + maxval3) / 2;
    
    % Create sliders
    slider1 = uicontrol('Style', 'slider', 'Parent', fig, ...
        'Position', [100, 200, 300, 30], 'Value', avval1, 'Min', minval1, 'Max', maxval1, ...
        'Callback', @slider1_callback);
    
    slider2 = uicontrol('Style', 'slider', 'Parent', fig, ...
        'Position', [100, 150, 300, 30], 'Value', avval2, 'Min', minval2, 'Max', maxval2, ...
        'Callback', @slider2_callback);
    
    slider3 = uicontrol('Style', 'slider', 'Parent', fig, ...
        'Position', [100, 100, 300, 30], 'Value', avval3, 'Min', minval3, 'Max', maxval3, ...
        'Callback', @slider3_callback);

    % Initial plot
    f2plot([avval1, avval2, avval3]);

    % Create text boxes
    text_box1 = uicontrol('Style', 'edit', 'Parent', fig, ...
        'Position', [425, 200, 75, 30], 'String', num2str(avval1), ...
        'Callback', @text_box1_callback, 'FontSize', 12);

    text_box2 = uicontrol('Style', 'edit', 'Parent', fig, ...
        'Position', [425, 150, 75, 30], 'String', num2str(avval2), ...
        'Callback', @text_box2_callback, 'FontSize', 12);

    text_box3 = uicontrol('Style', 'edit', 'Parent', fig, ...
        'Position', [425, 100, 75, 30], 'String', num2str(avval3), ...
        'Callback', @text_box3_callback, 'FontSize', 12);

    % Create fixed labels
    fixed_label_handle1 = uicontrol('Style', 'text', 'Parent', fig, 'Position', [375, 200, 50, 30], ...
        'String', [label1, ' ='], 'HorizontalAlignment', 'right', 'FontSize', 12);

    fixed_label_handle2 = uicontrol('Style', 'text', 'Parent', fig, 'Position', [375, 150, 50, 30], ...
        'String', [label2, ' ='], 'HorizontalAlignment', 'right', 'FontSize', 12);

    fixed_label_handle3 = uicontrol('Style', 'text', 'Parent', fig, 'Position', [375, 100, 50, 30], ...
        'String', [label3, ' ='], 'HorizontalAlignment', 'right', 'FontSize', 12);

    % Text box callback functions
    function text_box1_callback(hObject, ~)
        value = str2double(hObject.String);
        if ~isnan(value) && value >= minval1 && value <= maxval1
            update_slider1_value(value);
        else
            % Reset text box to last valid value
            hObject.String = num2str(get(slider1, 'Value'));
        end
    end

    function text_box2_callback(hObject, ~)
        value = str2double(hObject.String);
        if ~isnan(value) && value >= minval2 && value <= maxval2
            update_slider2_value(value);
        else
            % Reset text box to last valid value
            hObject.String = num2str(get(slider2, 'Value'));
        end
    end

    function text_box3_callback(hObject, ~)
        value = str2double(hObject.String);
        if ~isnan(value) && value >= minval3 && value <= maxval3
            update_slider3_value(value);
        else
            % Reset text box to last valid value
            hObject.String = num2str(get(slider3, 'Value'));
        end
    end

    % Slider callback functions
    function slider1_callback(hObject, ~)
        value = hObject.Value;
        update_plot();
        set(text_box1, 'String', num2str(value));
    end

    function slider2_callback(hObject, ~)
        value = hObject.Value;
        update_plot();
        set(text_box2, 'String', num2str(value));
    end

    function slider3_callback(hObject, ~)
        value = hObject.Value;
        update_plot();
        set(text_box3, 'String', num2str(value));
    end

    % Update plot based on slider values
    function update_plot()
        cla(ax);
        f2plot([slider1.Value, slider2.Value, slider3.Value]);
    end

    % Update slider value functions
    function update_slider1_value(value)
        set(slider1, 'Value', value);
        update_plot();
    end

    function update_slider2_value(value)
        set(slider2, 'Value', value);
        update_plot();
    end

    function update_slider3_value(value)
        set(slider3, 'Value', value);
        update_plot();
    end
end
