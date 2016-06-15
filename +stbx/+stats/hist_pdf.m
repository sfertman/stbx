function hpdf = hist_pdf(D, bins)
% HISTPMF returns a function handle to pmf estimated by histogram
% X -- assumes 1d data transformed to col

[N,X] = hist(D,bins);

% bin bounds
x_ = [-inf, 0.5*(X(1:end-1) + X(2:end)), inf].';

% countered probability at each bin
p_ = N(:)/sum(N);

% function_handle to match input x with bin and probabiltiy 
hpdf = @(x) p_(sum(bsxfun(@gt, x(:).', x_),1));


end

