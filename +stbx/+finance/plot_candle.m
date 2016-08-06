function [varargout] = plot_candle(varargin) 
% PLOT_CANDLE generates a candlebar plot of price / volume vs. time data.
%   If candle's close price is higher then open it will be GREEN; if lower
%   then RED; if equal then GREY.
% 
% PLOT_CANDLE(O,C,H,L) -- generates candle plot from (O)pen, (C)lose,
%   (H)igh and (L)ow data.
% PLOT_CANDLE(O,C,H,L,T) -- in addition to above, creates time axis with
%   values in T
% PLOT_CANDLE(O,C,H,L,T,V) -- in addition to above, creates volume bar plot
%   in a subplot at the bottom of the figure
% (not implemented: PLOT_CANDLE(AX,...) -- plots into axes AX instead of
%   gca)
%
% See also
%   subplot

narginchk(4,6);

redColor = [1,0,0];
greenColor = [0,1,0];
greyColor = 0.65*[1,1,1];

gridColor = pi/10*[1,1,1];
axesColor = [0,0,0];

assert_allInputsSameSize(varargin);

% input validation
if nargin == 4
    [open_, close_, high_, low_] = deal(varargin{:});
elseif nargin == 5 
    [open_, close_, high_, low_, vol_] = deal(varargin{:});
elseif nargin == 6
    [open_, close_, high_, low_, vol_, t] = deal(varargin{:});
else
    % shouldn't be triggered because of narginchk at the top
    error(stbx.commons.err.inputs_wrongNumber) 
end

if ~exist('t', 'var');
    t = reshape(1:length(open_), size(open_));
end
    
if exist('vol_', 'var')
    isPlotVol = true;
else 
    isPlotVol = false;
    ax1 = gca;
end

cnd_green = close_ > open_;
cnd_red = close_ < open_;
cnd_grey = close_ == open_;

if isPlotVol
    ax1 = subplot(3,1,[1,2]);
end

% plot greens
hhh1 = line([t(cnd_green)'; t(cnd_green)'], [high_(cnd_green)'; low_(cnd_green)']);
hhh2 = line([t(cnd_green)'; t(cnd_green)'], [open_(cnd_green)'; close_(cnd_green)']);
set([hhh1;hhh2], 'Color', 'g');
set(hhh2, 'LineWidth', 4);

% plot reds
hhh1 = line([t(cnd_red)'; t(cnd_red)'], [high_(cnd_red)'; low_(cnd_red)']);
hhh2 = line([t(cnd_red)'; t(cnd_red)'], [open_(cnd_red)'; close_(cnd_red)']);
set([hhh1;hhh2], 'Color', 'r');
set(hhh2, 'LineWidth', 4);

% plot greys
hhh1 = line([t(cnd_grey)'; t(cnd_grey)'], [high_(cnd_grey)'; low_(cnd_grey)']);
if ~ishold
    %%% this is necessary because if hold is off the plot function
    %%% ovewrites the current axes (ax)
    hold_state = false;
    hold on; 
else
    hold_state = true;
end
hhh2 = plot(ax1,t(cnd_grey)', open_(cnd_grey)','x'); 
if ~hold_state % meaning if previous hold state was false (off)
    hold off
end % else hold stays on


set([hhh1;hhh2], 'Color', greyColor);
% set(hhh2, 'LineWidth', 4);


% axis formatting
grid on;
set(ax1, 'Color', axesColor, 'XColor', gridColor, 'YColor', gridColor);


if ~isPlotVol
    varargout = {ax1};
    return
end
%%% from here on we plot volume bars
ax2 = subplot(313); hold on;

stem(ax2,t(cnd_green), vol_(cnd_green), 'filled', 'Color', greenColor);
stem(ax2,t(cnd_red),   vol_(cnd_red),   'filled', 'Color', redColor);
stem(ax2,t(cnd_grey),  vol_(cnd_grey),  'filled', 'Color', greyColor);

grid on;
set(ax2, 'Color', axesColor, 'XColor', gridColor, 'YColor', gridColor);
hold off;
varargout = {ax1, ax2};

end

function assert_allInputsSameSize(args)
szArgs = cellfun(@size, args.','UniformOutput',false);
szArgs = cell2mat(szArgs);
assert(size(unique(szArgs,'rows'),1) == 1, stbx.commons.err.inputs_mustBeSameSize);
end