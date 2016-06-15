function varargout = group_by( X, G, SORTFLAG )
% GROUP_BY splits the data in X by categories in C. 
% 
% B = GROUP_BY(X, G) -- returns data in X binned/grouped by unique rows in 
%   G. The data is put into cell array B which contains sub-arrays of X. X
%   can be any n-d array, including cell array. G can be a column vector or
%   a matrix. X will be split along the dimension that matches the first
%   dimentsion of G (number of rows in G). If more than one of X's
%   dimensions matches the number of rows in G, GROUP_BY works along the
%   forst one. Any type that has UNIQUE(...,'rows') functionality supported
%   can be used for grouping, including but not limited to: character
%   arrays, numeric arrays, logical arrays and categorical arrays. Special
%   case support was added for finding unique rows in cellstr matrices as
%   well.
%
% GROUP_BY(..., SORTFLAG) determines how the output data is sorted.
%   Similarly to bultin UNIQUE, it can have one the following values:
%   'sorted' (default) -- returns the grouped data such that the grouping
%       variable rows are sorted in ascending order.
%   'stable' -- returns the grouped data such that the grouping variable
%       rows appear in the same order as the were encountered in G.
%
% [B,C] = GROUP_BY(...) also returns the caterories corresponding with each
%   bin in C. The type / class of C is the same as G.
%
% [B,C,R] = GROUP_BY(...) also returns the corresponding indices (row
%   numbers) of data in X.
%
% See also:
%   unique, cellstr

% <TODO>
% - need to decide what to do when missing labels in grouping arrays are
%   encountered. Most obvious solution is to ignore the data where labels
%   are missing, i.e., <undefined>, NaN, {''}, {[]}, etc...
% - for now we assume that X is at most 2D. make it work with X having any
%   dimensionality.
% - add option to specify group variables by index from within X.
% - add option to specify group variables by functions applied on each
%   record in X that result in grouping arrays / matrices. 
%   - Example 1: @(x) round(x) may result in an array of integers that can
%     be used to group X into several groups.
%   - Example 2: @(x) iffun(x <= 2, 'le2', 'gt2') will result in a cellstr
%     array grouping X into 2 groups ('le2', 'gt2')
% </TODO>

%%% Assuming X is a matrix (see above TODO)
assert(size(X,1) == size(G,1),'Input data and grouping variables must have the same number of rows.');

if ~exist('SORTFLAG', 'var')
    SORTFLAG = 'sorted';
else
    assert(ischar(SORTFLAG), 'SORTFLAG parameter must be of type char.');
    assert(any(strcmpi(SORTFLAG, {'sorted', 'stable'})), 'Unknown input parameter: ''%s''.', SORTFLAG);
end

% find unique rows in G
if iscellstr(G)
    [C,~,IC] = uniquerows_cellstr(G, SORTFLAG); 
else
    [C,~,IC] = unique(G,'rows', SORTFLAG);
end

if iscell(X)
    B = accumarray_group_cell(IC, X);
else
    B = accumarray(IC, X, [], @(x) {x});
end

varargout = cell(1,nargout);

if nargout >= 0
    varargout{1} = B;
end

if nargout >= 2
    varargout{2} = C;
end

if nargout >= 3
    varargout{3} = accumarray(IC, (1:size(X,1)).', [], @(x) {x});
end

if nargout >= 4
    error('Too many outputs.');
end

end

function [C, IA, IC] = uniquerows_cellstr(A, SORTFLAG)
% This is barebone implementation for this specific function to make it
% stand alone. See stbx/myfunc/uniquerows_cellstr.m for extended
% functionality, help on correct use and TODOs. 

if ~exist('SORTFLAG', 'var')
    SORTFLAG = 'sorted';
else
    assert(ischar(SORTFLAG), 'SORTFLAG parameter must be of type char.');
    assert(any(strcmpi(SORTFLAG, {'sorted', 'stable'})), 'Unknown input parameter: ''%s''.', SORTFLAG);
end

[~,~,IC] = arrayfun(@(u) unique(A(:,u),'sorted'), 1:size(A,2), 'UniformOutput', false); 
[~, IA, IC] = unique([IC{:}], 'rows', SORTFLAG);
C = A(IA,:);
end

function B = accumarray_group_cell(IC, X)
% The second parameter, VAL in the builtin accumarray function can only be
% numeric, logical, or character vector. When the input data for grouping
% in stbx.data.group_by is a cell array, the builtin accumarray will fail.
% This function takes care of bussiness in these cases.

% map values of X into their positions in X
X_idx = reshape(1:numel(X), size(X));

% group the numbers by IC
B_idx = accumarray(IC, X_idx, [], @(x) {x});

% substitute the positions with the original values of X
B = stbx.arr.cellsubsref(X, B_idx);

end
