function h_ = summaryplot( varargin ) 
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% SUMMARYPLOT computes and plots summary statistics for input data.
% Copyright (C) 2016 Alexander Fertman.
%     
%     This file is part of STBX package.
%
%     STBX package is distributed in the hope that it will be useful and
%     it is absolutely free. You can do whatever you want with it as long
%     as it complies with GPLv3 license conditions. Read it in full at: 
%     <http://www.gnu.org/licenses/gpl-3.0.txt>. Needless to say that
%     this program comes WITHOUT ANY WARRANTY for ANYTHING WHATSOEVER. 
%   
%     On a personal note, if you do end up using any of my code, consider
%     sending me a note. I would like to hear about the cool new things my
%     code helped to make and get some inspiration for my future projects
%     too.
%     
%     Cheers.
%     -- Alexander F.
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% SUMMARYPLOT(AX, ...) plots into axes AX. If AX is not provided, a new
%   plot will created.
% SUMMARYPLOT(X, STAT) plots the statistics of X specified in STAT. 
% X can be one of the following: 
%   vector -- one point per statistic will be plotted in the same position
%   on the horizontal axis.
%   matrix -- statistics will be computed for each column and each col will
%       be plotted in differenet position on horizontal axis
%   cell array -- summaryplot will be applied on each member of cell array.
%       If member is vector or atrix, the above rules apply. Data will be
%       grouped according to cell membership. E.g. if cell contains several
%       matrices then columns of each matrix will be plotted closer
%       together on the horizontal axis. 
%
%   .... more options may be added later ....
%
% STAT specifies the statistics to be calculated and plotted. It can be one
%   of the following values:
%   string -- each of the following string inputs is supported, computation 
%     will ignore NaN values:
%       'count'     count data points
%       'min'       find minimum value
%       'max'       find maximum value
%       'mean'      compute mean
%       'median'    compute median
%       'std'       compute std with default behavior (flag = 0)
%       'std0'      compute std with flag 0
%       'std1'      comupte std wuth flag 1
%       'var'       compute var with default behavior (flag = 0)
%       'var0'      compute var with flag 0
%       'var1'      comupte var wuth flag 1
%       
%       ... easy to add more later ...
%
%   cellstr -- cell array containing any of the strings above. SUMMARYPLOT
%       will plot all of them in the same position on the horizontal axis
%       for each data container in X as described above.
%   function_handle -- will plot whatever comes out of the function defined
%       by the input function handle. The function must accept inputs as
%       described for X above. The function output must have the same
%       number of columns as the input matrix. Each output row will be
%       considered as a separate statistic on the matrix X and will be
%       plotted as such.
%   cell array containing any mix of the above two options.
% 
% Special abilities and superpowers:
% SUMMARYPLOT(X, G, STAT) -- will plot STATs mimicking boxplot
%   behaior. G can be cellstr, categorical or integer arrays of
%   matching size. G can be one of the following:
%     vector -- each column in X matrix (or vector, or cell array) is
%     grouped in the same way.
%     matrix -- each col in X is grouped by the matrix, starting with the
%     first col in G and going forward.
%     cell array of cells as above with matching sizes to members of X cell
%     array (iff X in cell array also) then grouping is applied each cell
%     on its counterpart. 
%
% See also:
%   plot, boxplot, function_handle
%       

% <TODO> 
% (*) adopt boxplot behavior: if X is vector, each stat is made for the
%   same line. If X is matrix, the stats are made for each column. If there
%   are grouping columns then do the same groupping thing as boxplot
%   (except group num of rows equals num of data cols, seems redundant)
%
% (*) make sure to plot all stats with different colors and markers (cycle
%   through the builtin defaults for the builtin plot function)
% </TODO>

if nargin == 0
    help(mfilename('fullpath'))
    return
end

char2fun = {
    'count'     @(u)sum(~isnan(u),1)
    'min'       @(u)nanmin(u,[],1)  
    'max'       @(u)nanmax(u,[],1)  
    'mean'      @(u)nanmean(u,1)    
    'median'    @(u)nanmedian(u,1)  
    'var'       @(u)nanvar(u,[],1)  
    'var0'      @(u)nanvar(u,0,1)   
    'std'       @(u)nanstd(u,[],1)  
    'std0'      @(u)nanstd(u,0,1)   
    'std1'      @(u)nanstd(u,1,1)   
    };

char2fun = containers.Map(char2fun(:,1).', char2fun(:,2).');

% checking out the first input to see if plotting axes were specified
if isscalar(varargin{1}) && ishandle(varargin{1}) && strcmpi(get(varargin{1}, 'Type'), 'axes')
    [AX, varargin] = deal(varargin{1}, varargin(2:end));
else
    AX = newplot;
end

% after this we have between 2 and 3 input arguments
switch length(varargin)
    case 2
        [X, STAT] = deal(varargin{:});
        G = {};
    case 3
        [X, G, STAT] = deal(varargin{:});
    otherwise
        error(stbx.commons.err.superunknown);
end



% making sure X is in  cell array b/c it's easier to deal with
if ~iscell(X), X = {X}; end
if ~iscell(STAT), STAT = {STAT}; end

% making sure that each member of X is a numeric matrix
assert(all(cellfun(@isnumeric, X) & cellfun(@ismatrix, X)), 'All data must be numeric (matrices or vectors).');
% making sure all vector members of X column vectors
assert(all(cellfun(@iscolumn, X(cellfun(@isvector, X)))), 'All vectors must be columns.')
% 

% <TODO> make sure all dimensions match </TODO>

% this should be done for each member of STAT array (assuming all dimensions match)

% make sure each member is either char or function handle
assert(all(cellfun(@ischar,STAT) | cellfun(@(u) isa(u, 'function_handle'),STAT)), 'Summary statistics can be defined only builtin string identifiers or by using function_handle.');
% replace all chars with the appropriate functions
STAT = cellfun(@(u) iffun(ischar(u), char2fun(u), u), STAT, 'UniformOutput', false);
% <TODO>
% (*) make sure that if cellfun (^) fails to work, the user gets an
%   informative error message, maybe wrap the above line into some error
%   handler. 
% </TODO>

fvarsin = cell.empty(length(STAT),0); 
% <TODO> 
% (*) (^) this is to allow for definition of stats that pass additional
%   arguments to input functions. Extract fvarsin from STAT
%   structure/cell/whatever
% </TODO>


% compute each stat for each X
stat2plot = cellfun(@(x, f, fv) f(x,fv{:}), X, STAT, fvarsin, 'UniformOutput', false);


%%% plotting everithhing onto axes 'ax
axNextPlotParam = get(AX, 'NextPlot');
if ~strcmpi(axNextPlotParam, 'add') % if hold is not on
    % we initialize the handle vector/matrix
    h_ = zeros(size(stat2plot));
    % plot the 1st stat according to whatever rule is set at the moment
    h_(1) = plot(AX, stat2plot{1}, '.');
    % put a 'hold on' on the axes
    set(AX, 'NextPlot', 'add'); 
    % plot the rest
    h_(2:end) = cellfun(@(u) plot(AX, u, '.'), stat2plot(2:end));
    % go back to original 'NextPlot' setting for the axes
    set(AX, 'NextPlot', axNextPlotParam); 
else
    % we plot everything in one go
    h_ = cellfun(@(u) plot(AX, u, '.'), stat2plot);
end


end



