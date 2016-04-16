function [ output_args ] = aggregate( X, G, F, C )
% AGGREGATE data X by group(s) G using function(s) F and collects outputs
% into bins / sets of arrays (implemented as cell arrays) according to
% optional scalar C.
%
% X can be nd numeric/cell/object matrix (any type of array really).
%   AGGREGATE works along the first non-singelton dimension. 
%
% G can be matrix that unique(...,'rows') is defined for. Easy choices are
%   cellstr, categorical and integers. Number of rows in G must be equal to
%   the size of the working dimension of X (1st non-singelton). The number
%   of columns in G can be 1 or more, where each column represents a
%   grouping variable. The grouping will be applied in left-to-right order.
% 
% F can be one function_handle or cell array of function_handle. In the
%   former case, F will be applied with all aggregation levels (columns in
%   G); in the latter case F must be equal in size to the number of columns
%   in G and each function will be applie with its coresponding aggregation
%   level. If F is not defined, default @sum is used.
%
% C is a scalar (integer) number between 1 and size(G,2) and it specifies
%   the index of the column in G according to which output is collected. If
%   C is not given or is empty, the the output is not collected into cell
%   arrays and returned in a single block.
%
% See also:
%   unique, cellstr, cetegorical, function_handle, cellfun

narginchk(2,3); 

% deal with X
wdimX = find(size(X) > 1, 1, 'first'); % find working dimension
assert(~isempty(wdimX), 'Input data must have at least one non-singelton dimension.');
onesPrefix = num2cell(ones(1, wdimX-1));
colonSuffix = repmat({':'}, [1, ndims(X) - wdimX]); 
refX = @(i) [onesPrefix, i, colonSuffix]; % use: r = refX(i), X(r{:}) = ...
% or maybe just use: X(onesPrefix{:},i,colonSuffx{:})

% deal with G
% -- check if cellstr and pop a flag up 
%%%% not sure about that^ one yet 
% -- make sure dimensions match with X
assert(size(G,1) == size(X,wdimX), 'Data and grouping variables size mismatch.');
% -- make sure that it's a metrix at the most 
assert(ismatrix(G), 'Grouping variables can be either a vector or a matrix.')



% deal with F
if ~exist('F','var') || isempty(F)
    F = @(u) sum(u(:)); % default -- sum everything in a box 
end

assert(isvector(F), 'Aggregation functions must be provided in either vector or scalar form.');

if ~iscell(F), F = {F}; end

if length(F) == 1
    if size(G,2) ~= 1 
        repmat(F, [1, size(G,2)]);
    end
else
    assert(length(F) == size(G,2), 'Number of aggregation functions goes not match the number of grouping columns.');
end

% deal with C
if ~exist('C','var')
    C = [];
else
    assert(isscalar(C) && isnumeric(C), 'Collection index (input 4) must be a numeric scalar.');
end









error(stbx.commons.err.underConstruction);

end


