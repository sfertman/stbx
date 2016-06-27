function allHandles = plot_series( varargin ) 
% inputs: (ax, grouped_xData, grouped_yData, groupedDataLabels )
% plot all data and save the labels 
% applies plot(x,y) on each group to plot the data -- so make sure each
% cell is arranged in the desired way using this function. It is recomended
% that each data series will have x and y data specified as different
% members (vectors) of cell arrays. Otherwise, expect the unexpected.



warning('Add legend??'); % according to data labels? or just series1, series2, etc...?

%%% ||| use the universal input parser I wrote to find the parameters, or
%%% better yet, use the builtin matlab input parser
%%% vvv
if nargin == 0, help(mfilename); return; end

datalabels_idx = find(strcmp(varargin,'datalabels'));
if ~isempty(datalabels_idx)
    groupedDataLabels = varargin{datalabels_idx+1};
    varargin = varargin([1:datalabels_idx-1, datalabels_idx+2:end]);
else
    groupedDataLabels = 'noinput';
end
            
plot_params_idx = find(strcmp(varargin,'plotparams'));
if ~isempty(plot_params_idx)
    plot_params = varargin{plot_params_idx+1};
    assert(iscell(plot_params), 'plot parameters must be given in cell');
    varargin = varargin([1:plot_params_idx-1, plot_params_idx+2:end]);
else
    plot_params = 'noinput';
end
%%% ^^^ FlatTable.FT_parseInputs - make it independent
%%% ||| use the universal input parser I wrote to find the parameters.


nargs = length(varargin);

assert(nargs <= 3, 'Wrong number of inputs. See help for correct use.');
% check whether the 1st input is an axes handle
if ishandle(varargin{1})
    if strcmp(get(varargin{1}, 'Type'), 'axes');
        ax = varargin{1};
        varargin = varargin(2:end);
        nargs = nargs - 1;
    else
        error('Handle must be a valid axes handle, not anything else.')
    end
else
    ax = gca;
end

% by now must be 2 inputs only
assert(nargs == 2, 'Wrong number of inputs.');

% get the x-y data for plot and make sure they're the same size
[grouped_xData, grouped_yData] = deal(varargin{:});
assert(isequal(size(grouped_xData),size(grouped_yData)),'x and y data must have the same numebr of groups.');

% make sure everything is given in cell arrays (one array member per group)
assert(iscell(grouped_xData), iscell(grouped_yData), iscell(groupedDataLabels), 'All data must be in cell arrays.');

% figure out if data labels correspond with the data, if not: issue warning
% and ignore while plotting
if ~isequal(groupedDataLabels,'noinput') && ~isequal(size(grouped_yData), size(groupedDataLabels))
    isPlotLabels = false;
    warning('Ignoring labels: number of label groups does not match the number of data groups.');
elseif isequal(groupedDataLabels,'noinput')
    isPlotLabels = false;
else
    isPlotLabels = true;
end


% if nargs == 3
%     [grouped_xData, grouped_yData, groupedDataLabels] = deal(varargin{:});
%     assert(iscell(grouped_xData), iscell(grouped_yData), iscell(groupedDataLabels), 'All data must be in cell arrays.');
%     if ~isequal(size(grouped_yData), size(groupedDataLabels))
%         isPlotLabels = false;
%         warning('Ignoring labels: number of label groups does not match the number of data groups.');
%     else
%         isPlotLabels = true;
%     end
% elseif nargs == 2
%     [grouped_xData, grouped_yData] = deal(varargin{:});
%     assert(iscell(grouped_xData), iscell(grouped_yData), 'All data must be in cell arrays.');
%     isPlotLabels = false;
% end


% make sure the number of groups matched in x and y
% assert(isequal(size(grouped_xData),size(grouped_yData)),'x and y data must have the same numebr of groups.');

N_groups = length(grouped_xData);

% save current 'NextPlot' state
prevNextPlotVal = get(ax, 'NextPlot');

% get the color order for the axes ax -- will be used to color each series
colors = get(ax, 'ColorOrder');

plotHandles = cell(size(grouped_xData));
textHandles = cell(size(grouped_xData));
for groupIdx = 1:N_groups
    % if x or y isempty, ignore group -- issue warning
    this_xData = grouped_xData{groupIdx};
    this_yData = grouped_yData{groupIdx};
    if isempty(this_xData) || isempty(this_yData)
        warning('Ignoring group %0.0f (empty data).', groupIdx);
        continue;
    end
    
    plotHandles{groupIdx} = plot(ax, this_xData, this_yData, '.', 'LineStyle', 'none');
    set(plotHandles{groupIdx}, 'Color', cyclicIdx(groupIdx, colors, 1));
    
    if groupIdx == 1
        % first plot is done according to the current figure rules, all
        % subsequent plots are done with 'hold on'
        set(ax, 'NextPlot', 'add');
    end
    
    % this section adds labels to data points (if they exist)
    if isPlotLabels
        this_txt_xData = this_xData + 0.02*(max(this_xData) - min(this_xData));
        this_txt_yData = this_yData + 0.02*(max(this_yData) - min(this_yData));
        this_dataLabels = groupedDataLabels{groupIdx};
        textHandles{groupIdx} = text(this_txt_xData, this_txt_yData, this_dataLabels);
        set(textHandles{groupIdx}, 'Color', cyclicIdx(groupIdx, colors, 1));
    end
    
end

% after we finish plotting, we set the old axes nextplot rules to whatever
% they were before
set(ax, 'NextPlot', prevNextPlotVal); 

% if any plot parameters were entered, set them to all plot handles
if ~isequal(plot_params, 'noinput') && ~isempty(plot_params) && ~isempty(plotHandles)
    set(vertcat(plotHandles{:}), plot_params{:});
    colorIdx = find(strcmp(plot_params, 'Color')); 
    if ~isempty(vertcat(textHandles{:})) && ~isempty(colorIdx)
        set(vertcat(textHandles{:}), 'Color', plot_params{colorIdx+1});
    end
end

% put all plot and text handles in one struct for output
allHandles = struct('plotHandle',plotHandles, 'textHandles', textHandles);

end

