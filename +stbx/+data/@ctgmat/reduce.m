function that = reduce(this, dim)
% reduces CtgMat along dimension DIM - dangerous function - use wisely 
% If all values are the same, reduction results in a signle value and a map
% that contains a single category. If at least one value is different from
% all the rest, reduction results in NaN and empty map.


size_this = size(this);

% if dim undefined, operate on the first non-singeelton
% dimension of this matrix.
if ~exist('dim', 'var') || isempty(dim)
    dim = find(size_this ~= 1, 'first');
else % check if dim is ok for our matrix
    assert(dim <= numel(size_this), 'Requested demension exceeds number of matrix dimension.')
end


idx = cell(1,length(size_this));
for d = 1:length(idx)
    idx{d} = ':';
end

% init that_numMat to the 1st hyperplane along dim
idx{dim} = 1; 
that_numMat = this.num_mat(idx{:}); 

% iterate over all hyperplanes along dim
for d = 2:size_this(dim) 
    % select hyperplane along dim
    idx{dim} = d;
    % insert NaN where the value is different from the existing one
    that_numMat(that_numMat ~= this.num_mat(idx{:})) = NaN;
end

% create a new object for output
warning('make sure that an empty map is created where appropriate.');
that = CtgMat(this.ctg_map, that_numMat);
end

% %%% was made to be helper in 'reduce' but no need for it there
% %%% cannot see a use for it anywhere but will keep it around
%         function x = reduceVector(X)
%             % if vector is empty it's already reduced
%             if isempty(X), x = X; return; end
%             % check if X is vector (in the most general sense)
%             assert(sum(size(X) ~= 1) == 1, 'Input must be vector.');
%             % reduced vector size is always 1 (single value)
%             if length(unique(X)) == 1
%                 x = X(1);
%             else
%                 x = NaN;
%             end
%         end