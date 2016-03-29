function [v_, i_] = cyclicIdx(ii, v, dim)
% consider renaming to cyclindex.m sounds cooler :-P
% should be cycling through matrix given an subs index that is not
% necessarily in bounds of matrix dimensions, but I have no idea what I've
% done here. Been too long.

if ~exist('dim', 'var')
    dim = 1;
end
N = size(v, dim);

i_ = rem(ii-1, N) + 1; 

idx = cell(1, ndims(v));
idx(:) = {':'};
idx{dim} = i_;

v_ = v(idx{:});

end
    