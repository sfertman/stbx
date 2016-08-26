function [Y,GC,IY] = aggregate(X,G,F,varargin) 
% AGGREGATE 2d data X by group(s) G using function(s) F and collect outputs
% into bins / sets of arrays / cell arrays 
%
% Y = AGGREGATE(X,G) aggregates rows of vaues in X according to unique
%   rows of G. Default aggregation function F = @(u) sum(u(:)). 
%
% Y = AGGREGATE(X,G,F) uses function F (of type function_handle) to
%   aggregate the rows of X. For axample, to find the mean rows of X
%   according to grouping in G set F to: @(x) mean(x,1); to find the
%   standard deviation, set F to: @(x) std(x,[],1); and so on... F can
%   return whatever you want. If F maps matrices to rows of the same type,
%   they will be concatinated to form a 2-d array (numericals, objects,
%   chars, matrices, whatever). If the results of F cannot be concatinated,
%   the output will be put in a cell array. To force cell array output use 
%   {'UniformOutput', false} like in cellfun.
%
% X can be at most 2d numeric/cell/object matrix (any type of array
%   really). 
%
% G can be matrix that unique(...,'rows') is defined for. Easy choices are
%   categorical and integers, cellstr matrices are also supported. G must
%   must have the same number of rows as X. The number of columns in G can
%   be 1 or more, where each column represents a grouping variable. The
%   grouping will be applied in left-to-right order. 
% 
% F can be one function_handle or cell array of function_handle. In the
%   former case, F will be applied with all aggregation levels (columns in
%   G); in the latter case F must be equal in size to the number of columns
%   in G and each function will be applied with its coresponding
%   aggregation level. If F is not defined, default @(u) sum(u(:)) is used.
%
% [Y,GC] = AGGREGATE(...) will return the aggregated and collected output
%   in Y and the grouping categories in GG.
%
% [Y,GC,IY] = AGGREGATE(...) will also return a cell array of numericals
%   indicating the records which were used to calculate each cell element
%   in Y (or each "row" in Y), such that: Y{i} = F(X(IY{i})) 
%   
% AGGREGATE(..., PARAM1,VAL1, PARAM2,VAL2, ...) function's behavior can be
%   also controlled by using parameter-value paired inputs. The following
%   options are supported:
%   (-) '-uniform' -- similarly to cellfun, is a logical value
%       indicating whether or not the output(s) of F can be returned
%       without encapsulation in a cell array. If true (the default), F
%       must return values that can be concatenated into an 2-d array,
%       meaning values with size 1 in the first dimension (rows). The
%       number of colunms of F's output(s) must be the same for
%       concatination to be possible. If true, the outputs can be of any
%       type, as long as they match in size and can therefore be
%       concatinated. If false, AGGREGATE returns a cell array (or multiple
%       cell arrays), where the (I,J,...)th cell contains the value
%       F(C{I,J,...}, ...). When '-uniform' is false, the outputs can be of
%       any type shape or form. 
%   (-) '-collect' -- numeric (or logical) array indicating a subset of
%       grouping variables in G by which the output(s) will be collected.
%       This parameter affects output collection only and aggregation will
%       be performed according to unique rows of G in any case. If this
%       parameter is not specified output(s) will not be collected unless
%       '-uniform' is used, in such case collection will be unique rows in
%       G. 
%   (-) '-multipleOutputs' -- a numerical or logical array specifying which
%       outputs of F should be returned. For example, to get the indices of
%       the maximum value in each grouped bin, use:
%       Y = AGGREGATE(X, G, @max, '-multipleOutputs', 2);
%       % or
%       Y = AGGREGATE(X, G, @max, '-multipleOutputs', logical([0,1]));
%       
% See also:
%   unique, cellstr, categorical, function_handle, cellfun, accumarray, 
%   stbx.data.group_by

%error(stbx.commons.err.underConstruction)
narginchk(2,inf); 

[isUniform, isCollect, isMultOuts, isSorted, varargin] = parseParams( varargin, {...
    {'-uniform',@(u) islogical(u) && isscalar(u), '-uniform must be true or false.', true}, ...
    {'-collect',@(u) islogical(u) || isnumeric(u), '-collect must be either numeric or logical array.', [] },...
    {'-multipleOutputs',@(u) islogical(u) || isnumeric(u), '-multipleOutputs must be either numeric or logical array.', [] },...
    {'-sorted', @(u) islogical(u) && isscalar(u), '-sorted must be true or false.', true} ...
    });

assert(isempty(varargin), 'Too many inputs.');

% deal with X
assert(ismatrix(X), 'X must be a matrix.')


% wdimX = find(size(X) > 1, 1, 'first'); % find working dimension
% assert(~isempty(wdimX), 'Input data must have at least one non-singelton dimension.');
% onesPrefix = num2cell(ones(1, wdimX-1));
% colonSuffix = repmat({':'}, [1, ndims(X) - wdimX]); 
% refX = @(i) [onesPrefix, i, colonSuffix]; % use: r = refX(i), X(r{:}) = ...
% or maybe just use: X(onesPrefix{:},i,colonSuffx{:})

% deal with G
% -- check if cellstr and pop a flag up 
%%%% not sure about that^ one yet since group_by already takes care of that
% % % % -- make sure dimensions match with X
% % % assert(size(G,1) == size(X,wdimX), 'Data and grouping variables size mismatch.');
% % % % -- make sure that it's a metrix at the most 
% % % assert(ismatrix(G), 'Grouping variables can be either a vector or a matrix.')
% % % 

SORTFLAG = iffun(isSorted, 'sorted', 'stable');
% default^ is sorted, need to think how exactly I want it to behave here
% % % % deal with COLLECT in input parser
% % % if ~exist('C','var')
% % %     GC = [];
% % % else
% % %     assert(isscalar(GC) && isnumeric(GC), 'Collection index (input 4) must be a numeric scalar.');
% % % end




% deal with F
if ~exist('F','var') || isempty(F)
    F = @(u) sum(u(:)); % default -- sum everything in a box 
end

assert(isvector(F), 'Aggregation functions must be provided in either vector or scalar form.');

% if ~iscell(F), F = {F}; end

% grouping and applying aggregation function 
if length(F) == 1
    [Y,GC,IY] = aggregate_all(X,G,F);
else
    assert(length(F) == size(G,2), 'Number of aggregation functions goes not match the number of grouping columns.');
end

% 
%     if size(G,2) ~= 1 
%         repmat(F, [1, size(G,2)]);
%     end
% else
%     assert(length(F) == size(G,2), 'Number of aggregation functions goes not match the number of grouping columns.');
% end



% group X by G
[Xbinned,GC,IY] = stbx.data.group_by(X,G,SORTFLAG);

% apply F on each bin of X (XB)
if ~isempty(isMultOuts)
    if islogical(isMultOuts)
        Y = cell(1, sum(isMultOuts));
    else % must be numerical -- asserted during input processing
        Y = cell(1,length(isMultOuts));
    end
    [Y{:}] = cellfun(F, Xbinned, 'UniformOutput', isUniform);
else
    Y = cellfun(F, Xbinned, 'UniformOutput', isUniform);
end

% collect outputs:





error(stbx.commons.err.underConstruction);

end


