function highlightSelPoint( gcbo, eventdata )
persistent cursor_h

ax = gcbo; % we get the event from axes only at this point. Maybe make sure it is coming from axes

if ~exist('cursor_h','var') || isempty(cursor_h) || ~ishandle(cursor_h)
    axNextPlotProp = get(ax, 'NextPlot'); % get current figure prop for hold
    set(ax, 'NextPlot', 'add'); % make sure we don't overwrite entire figure with our cursor
    cursor_h = plot(ax, 0, 0,'rs', 'MarkerSize', 12.0, 'Visible', 'off');
    set(cursor_h, 'HandleVisibility', 'off');
    set(ax, 'NextPlot', axNextPlotProp); % set prop to the original
end

switch get(get(ax, 'Parent'),'SelectionType') % it's a figure property
    case 'normal'
        [ plt_h, pnt_id, pnt_coo ] = stbx.plot.findNearestPlotPoint(ax);
        set(gca, 'NextPlot', 'add');
        set(cursor_h, 'XData',pnt_coo(1), 'YData', pnt_coo(2), 'Visible', 'on')
        
    otherwise
        % do nothing
        
end

end

