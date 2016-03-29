function [ plt_h, pnt_id, pnt_coo ] = findNearestPlotPoint( varargin )
% [plt_h, pnt_id, pnt_coo] = findNearestPlotPoint() -- finds the point
% within gca using its 'CurrentPoint' as reference
%
% [plt_h, pnt_id, pnt_coo] = findNearestPlotPoint(x,y,z) -- finds the point
% within gca using input 'x', 'y' and 'z' as reference. 'z' is optional and
% the function will default to z = 0 if not given in 3D plot.
%
% [plt_h, pnt_id, pnt_coo] = findNearestPlotPoint(ax, ...) -- finds the
% point within given axes 'ax'
%


% function inner parameters - touch at your own risk
PLOT_TYPES_SUPPORTED = {'line'}; % will work with 'line' for now, other plot types may be added in future

% handle axes input stuff
if isempty(varargin)
    ax = gca;
elseif ishandle(varargin{1})
    if strcmpi(get(varargin{1}, 'Type'), 'axes')
        [ax, varargin] = deal(varargin{1}, varargin(2:end));
        
    else
        error('Input handle must be valid axes handle...');
    end
else
    ax = gca;
end

% make the following two possible to be specified as input
currentPoint = get(ax, 'CurrentPoint');

% find all the supported plots in the axes
thingsInAxes_h = get(ax, 'Children');
thingsInAxes_types = get(thingsInAxes_h, 'type'); % this is cellstr, might be required to speedboost it if many points in chart - we'll see if necessary

plotsInAxes_logical = cellfun(@(u) strcmpi(thingsInAxes_types, u), PLOT_TYPES_SUPPORTED, 'UniformOutput',false);
plotsInAxes_logical = any([plotsInAxes_logical{:}],2);
plotsInAxes_h = thingsInAxes_h(plotsInAxes_logical);

% find the closest point on any of the plots to currentPoint (assuming always 3D)
plotsInAxes_data = get(plotsInAxes_h,{'XData','Ydata','ZData'});
plotsInAxes_dataLength = cellfun(@length, plotsInAxes_data(:,1)); % get lengths of plotted datasets
plotsInAxes_data = [[plotsInAxes_data{:,1}].', [plotsInAxes_data{:,2}].', [plotsInAxes_data{:,3}].'];

%%% vvvvvvvvv this whole thing is sketcy vvvvvvvvvvvvvvvvvvvvvvvvv
% <TODO>
if size(plotsInAxes_data, 2) ~= 3 % if 2D
    currentPoint =  currentPoint(:,1:2); % we keep only x and y (junking z)
end % else, we don't need to do anything

% weird 'CurrentPoint' thing - on a 2D plot is gives us two ponts with the
% same x and y but one with z=1 and one with z=-1; This may be different in
% 3D plot, if bugs occur, it might be around this area
% *** Solution *** So, actually 'CurrentPoint' gives us the two points on a
% line that pierces two visible planes in 3D space where you clicked, this
% will need to be taken care of if I ever want this function to work with
% 3D plots.
currentPoint = currentPoint(1,:);
%%% ^^^^^^^^^ this whole thing is sketcy ^^^^^^^^^^^^^^^^^^^^^^^^^

plotsRange = max(plotsInAxes_data,[],1) - min(plotsInAxes_data,[],1);
plotsInAxes_data_n = bsxfun(@rdivide, plotsInAxes_data, plotsRange);
currentPoint_n = currentPoint./plotsRange;
distVectToCurrent = bsxfun(@minus, plotsInAxes_data_n, currentPoint_n);
absDistToCurrent = sqrt(distVectToCurrent(:,1).^2 + distVectToCurrent(:,2).^2);
[~, selPoint_i] = min(absDistToCurrent); % min returns first index
pnt_coo = plotsInAxes_data(selPoint_i, :);

% find which of the plots within ax the selected point belongs to
selPointPlot_i = find(selPoint_i <= plotsInAxes_dataLength, 1, 'first');
plt_h = plotsInAxes_h(selPointPlot_i);

% find the location of the point in its own plot's data
if selPointPlot_i > 1
    pnt_id = selPoint_i - (selPointPlot_i - 1);
else
    pnt_id = selPoint_i;
end


end
