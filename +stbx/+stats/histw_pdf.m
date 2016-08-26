function hpdf = histw_pdf(D, C, B, bintype)
% HISTW_PDF returns a function handle to pdf estimated by weigted histogram
% D -- assumes 1d data transformed to col
% W -- aussmes 1d data transformed to col
% B -- bins used to construct histogram
%
% See also:
%   hist, ecdf

BINTYPES = {'centers', 'edges'};
if ~exist('bintype', 'var')
    bintype = 'centers';
else
    assert(any(strcmpi(bintype,BINTYPES)), ...
        'Only possible values for bin type are: %s', pyjoin(', ', BINTYPES{:}));
end

switch bintype
    case 'centers'
        [F,X] = ecdf(D(:), 'frequency', C(:));
        [N,x_] = ecdfhist(F,X,B);
        x_ = [-inf, 0.5*(x_(1:end-1) + x_(2:end)), inf].';
    case 'edges'
        [~, IB] = histc(D, B);
        N = accumarray(IB, C);
        x_ = B(:);
        [x_(1), x_(end)] = deal(-inf, inf); % make sure the leading and trailing edges cover everything
        if sum(N) < length(D)
            warning('Not all data were included in the given bins.');
        end
end



% % % [F,X] = ecdf(D(:), 'frequency', C(:));
% % % 
% % % [N,x_] = ecdfhist(F,X,B);
% % % 
% % % % bin bounds
% % % x_ = [-inf, 0.5*(x_(1:end-1) + x_(2:end)), inf].';

% counted probability at each bin
p_ = N(:)/sum(N);

% function_handle to match input x with bin and probabiltiy 
hpdf = @(x) p_(sum(bsxfun(@gt, x(:).', x_),1));
% hpdf = @(x) hpdfw(p_,x_, x);

end

function p_out = hpdfw(p_,x_,x)
p_idx_mat = bsxfun(@gt, x(:).', x_);
p_idx = sum(p_idx_mat,1);
p_out = p_(p_idx);
end

