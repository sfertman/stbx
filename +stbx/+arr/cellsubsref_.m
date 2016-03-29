function [ out ] = cellsubsref_(varargin) %cellsubsref( X, subscell, varargin )
error('this thing doesn''t work at all as expected, ndims returns 2 for vectors and scalars as well as matrices... Fix it!');

%% parsing inputs
p = inputParser;
addRequired(p, 'X');
addRequired(p, 'subscell', @(u) iscell(u)); 
addParameter(p, 'UniformOutput', false, @(u) isscalar(u) && islogical(u) );
parse(p, varargin{:});

%% main body of function 

% making sure subscell is of corect type 
assert(all(cellfun(@numel, p.Results.subscell) == ndims(p.Results.X)), 'Each member of cell array must have numel equal to the number of dimensions of input array.');

% retrieving the elements by subscript 
out = cellfun(@(u) p.Results.X(u{:}), p.Results.subscell, 'UniformOutput', p.Results.UniformOutput);

% % % %%% for debugging purposes
% % % try
% % %     out = cellfun(@(u) p.Results.X(u{:}), p.Results.subscell, 'UniformOutput', p.Results.UniformOutput);
% % % catch e
% % %     rethrow(e);
% % % end


