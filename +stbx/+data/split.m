function [ a, b ] = split( arr, subs )
% SPLIT divides input array into two parts where the first contains members
%   specified by input subscripts (numeric or logical) and the second
%   contains all the rest. I made this function simply to save some writing
%   when I don't have to use the subscripts down the line.
%
%   Example:
%       [a,b] = SPLIT(arr, subs);
%
%   is equvalent to the following code
%       a = arr(subj)
%       b = arr; b(subs) = [];
%

narginchk(2,2); % exactly 2 inputs are expected
assert(isnumeric(subs) || islogical(subs),...
    'Second input must be either numeric or logical.')

a = arr(subs);
b = arr;
b(subs) = [];


end

