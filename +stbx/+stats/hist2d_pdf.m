function hpdf = hist2d_pdf(D, bins)
% HIST2D_PDF returns a function handle to 2D pmf/pdf estimated by histogram
% D -- assumes 2D data given as a Mx2 matrix (a 2 col matrix)

[N,X] = hist3(D,bins); % may be replaced with histcounts2

% bin bounds
x_ = [-inf, 0.5*(X{1}(1:end-1) + X{1}(2:end)), inf].';
y_ = [-inf, 0.5*(X{2}(1:end-1) + X{2}(2:end)), inf].';

% counted probability at each bin
p_ = N/sum(N(:));

% define prob function using bin counts
hpdf = @(X) p_(sub2ind(size(p_), sum(bsxfun(@gt, X(:,1).', x_),1).',sum(bsxfun(@gt, X(:,2).', y_),1).'));

end


%     function hhh = hpdf_(x,y)
%         x_idx = sum(bsxfun(@gt, x(:).', x_),1).';
%         y_idx = sum(bsxfun(@gt, y(:).', y_),1).';
%         lindex = sub2ind(szp_, x_idx, y_idx);
%         hhh = p_(lindex);
%     end
