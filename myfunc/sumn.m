function sumx = sumn( X, varargin )
% SUMN(X, dims) sums up a multidimensional array 'X' along the dimensions
% specified by 'dims'. 'dims' can be specified as a one dimensional vector
% or a list of inputs one by one. This functions does not have any sanity
% checks so, if you input anything other than what is specified here,
% expect the unexpected.
%
% Example:
%   X = ones(4,5,6,7);
%   sumX = sumn(X, [4,2]);
% 
% See also:
%   sum
%

dims = [varargin{:}]; % read dimensions array

sumx = X; % init sum variable
while ~isempty(dims)
    sumx = sum(sumx, dims(1)); % sum over each individual dimension
    dims = dims(2:end); % once used, throw it away
end 
