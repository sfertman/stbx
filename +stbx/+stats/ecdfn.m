function [ F,X ] = ecdfn( Y, C )
% ECDFN a clone of Matlab's builtin ecdf but with support for
% multidimensional variables.
% <TODO>
%   (-) make it work in the same way as the builtin excluding the plot (no
%       way of plotting anything with more than 3D anyway).
% </TODO>

if ~exist('C','var') || isempty(C)
    C = ones(size(Y,1),1);
end

% //TODO:
%   this is a brute force approach. works for now, but will have to find a
%   more intelligent way of doing it in the future. look at spatial
%   indexind for more efficient algorithms in higher dimensionality data
%

F = arrayfun(@(i) sum(C(all(bsxfun(@le,Y, Y(i,:)), 2))), (1:size(Y,1)).');
X = Y;
