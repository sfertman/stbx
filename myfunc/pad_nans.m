function new_X = pad_nans( X, new_size )
% not sure why this is useful
[szx_r, szx_c] = size(X);
new_X = nan(new_size);
new_X(1:szx_r, 1:szx_c) = X;
end

