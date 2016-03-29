function mX = meanalldims(X)
% use min(X(:)) or nanmean(X(:)) instead
mX = squeeze(X);
nd = ndims(mX);

for dim = 1:nd
    mX = sum(mX,dim)/size(mX,dim);
end

end

