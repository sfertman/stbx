function y_out = fillData(y_in, dim)
%
%> function y_out = fillData_(y_in, dim)
%
%> Completes data with the previous last good value.
%
%> y_in .... original data with NaNs indicating missing data
%> dim ..... dimention of data series for completion:
%           if dim == 1 or 'col', will consider each col as independent data series
%           if dim == 2 or 'row', will consider each row as independent data series
% y_out ... the completed data series

% % some test data
% N = 10
% y_in = round(1000*rand(N));
% y_in(logical(round(rand(N)))) = NaN

% works on 2d matrices only
if ~exist('dim', 'var') || isempty(dim)
    dim = 1;
end

if ischar(dim)
    if strcmp(dim, 'col'), dim = 1;
    elseif strcmp(dim, 'row'), dim = 2;
    else error('Unknown dimension specification, see help for this file.');
    end
end

assert(any(dim == [1,2]),'DIM must be either 1 or 2')
y_in_cell = num2cell(y_in, dim);
y_out_cell = cellfun(@(u) fillDataSingleLine(u), y_in_cell, 'UniformOutput', false);
y_out = cell2mat(y_out_cell);

end


function y_out = fillDataSingleLine(y_in)
% function works with 1D data only
% preallocate y_out
y_out = y_in;
% get logical indices of all NaNs in data
nanData_logic = isnan(y_in);
% if all the data are NaNs then nothing to do --> return
if sum(nanData_logic) == length(y_in), return; end; 
% taking care of NaNs at leading edge
if nanData_logic(1)
    firstGoodIdx = find(~nanData_logic,1,'first');
    y_out(1:firstGoodIdx-1) = y_in(firstGoodIdx);
end
% taking care of NaNs at trailing edge
if nanData_logic(end)
    lastGoodIdx = find(~nanData_logic,1,'last');
    y_out(lastGoodIdx+1:end) = y_in(lastGoodIdx);
end
% filling in all the ones on the middle with the previous last good value
% (has to be loop because depends on prev value; can try and use cumsum or
% cumprod here, but a loop turned out to be sufficiently fast -- *very*
% fast)
for ii = 1:length(y_out)
    if isnan(y_out(ii))
        y_out(ii) = y_out(ii-1);
    end
end 
end