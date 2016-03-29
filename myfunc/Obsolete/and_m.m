function a = and_m(m, dim)
% seems redundant one liner - use all or any
% See also
% 	all, any
if ~exist('dim', 'var')
    dim = 2;
end
a = logical(prod(m, dim));
end