function [h_polyPlot, polyCoef] = plotPolyFit( ax, p, N )
%PLOTPOLYFIT plots polynomial fit to data already present in a figure plot
% h_polyPlot -- handles to plotted lines
% coeff -- list of polynom coefficients


% <TODO>
% (-) For input parsing use the following instead: 
%   [ax, varargin] = axescheck(varargin{:}); and go from there to figure 
%   out 'p' and 'N'.
% (-) return residuals 
% (- return R^2 (norm of residuals) meausre for the requested regression

if ~exist('ax','var')
    ax = gca;
end

% setting default polynomial degree
if ~exist('p','var')
    p = 1;
end

% setting default number of points in polynom plot curve
if ~exist('N', 'var')
    N = 10;
end

assert(strcmpi('axes', get(ax, 'type')), 'Given handle does not point to axes.')

% find the line plots in the axes
axChilds = get(ax,'Children');
h_line_idx = find(strcmpi('line',arrayfun(@(u) get(u,'type'),axChilds,'UniformOutput',false)));

% initialize outputs
h_polyPlot = zeros(length(h_line_idx),1);
polyCoef = zeros(length(h_line_idx),p+1);

% get the "hold" state of the figure
nextPlotInitState = get(ax,'NextPlot');

% set "hold" to "on" to add out line to the figure
set(ax, 'NextPlot', 'add');

for i = 1:length(h_line_idx)
    % get data
    xdata = get(axChilds(h_line_idx(i)),'XData');
    ydata = get(axChilds(h_line_idx(i)),'YData');
    
    % take the NaNs out of the set
    nansIdx = isnan(xdata) | isnan(ydata);
    xdata = xdata(~nansIdx);
    ydata = ydata(~nansIdx);
    
    % get polynomial coefficients
    polyCoef(i,:) = polyfit(xdata, ydata, p);
    x = linspace(min(xdata), max(xdata), N);
    
    % get the color of the current line
    polyColor = get(axChilds(h_line_idx(i)), 'Color');
     
    % plot dashed line of the polynomial fit
    h_polyPlot(i) = plot(x, polyval(polyCoef(i,:), x), 'Color', polyColor, 'LineStyle', '--');

end

% set the "hold" state to what it used to be initially
set(ax, 'NextPlot', nextPlotInitState);

end

