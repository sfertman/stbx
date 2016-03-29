function [ counts, C, IA, IC ] = countUnique(X, varargin)
% counts the number of unique occurrences in a vector / matrix / whatever.
% call this function as you would the builtin 'unique'. The counts
% correspond with the C output parameter.
% See also 
%   unique

[C, IA, IC] = unique(X, varargin{:});

% slowest but surest -- for loop
uniqueIC = unique(IC, varargin{:}); % varargin is forwarded again to be consistent with C output above
counts = zeros(size(uniqueIC));
for i = 1:length(uniqueIC)
    counts(i) = sum(uniqueIC(i) == IC);
end
% //TODO: make ^it run faster via vectorized implementation. Loop works well
% enough but for big arrays it can be very slow.
    
    
