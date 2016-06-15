function hpdf = histw_pdf(D, C, B)
% HISTW_PDF returns a function handle to pdf estimated by weigted histogram
% D -- assumes 1d data transformed to col
% W -- aussmes 1d data transformed to col
% B -- used to construct histogram
%
% See also:
%   hist, ecdf

[F,X] = ecdf(D(:), 'frequency', C(:));

[N,x_] = ecdfhist(F,X,B);

% bin bounds
x_ = [-inf, 0.5*(x_(1:end-1) + x_(2:end)), inf].';

% countered probability at each bin
p_ = N(:)/sum(N);

% function_handle to match input x with bin and probabiltiy 
hpdf = @(x) p_(sum(bsxfun(@gt, x(:).', x_),1));


end

