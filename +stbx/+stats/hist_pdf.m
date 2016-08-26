function hpdf = hist_pdf(D, bins, bintype)
% HIST_PDF returns a function handle to pmf estimated by histogram
% X -- assumes 1d data transformed to col
BINTYPES = {'centers', 'edges'};

if ~exist('bintype', 'var')
    bintype = 'centers';
else
    assert(any(strcmpi(bintype,BINTYPES)), ...
        'Only possible values for bin type are: %s', pyjoin(', ', BINTYPES{:}));
end

switch bintype
    case 'centers'
        [N,X] = hist(D,bins); % use bin centers to count
        x_ = [-inf, 0.5*(X(1:end-1) + X(2:end)), inf].'; % find bin edges
    case 'edges'
        N = histc(D, bins);
        x_ = bins;
        if sum(N) < length(D)
            warning('Not all data were included in the given bins.');
        end
end
% % % [N,X] = hist(D,bins);
% % % 
% % % % bin bounds
% % % x_ = [-inf, 0.5*(X(1:end-1) + X(2:end)), inf].';
% % % 
% countered probability at each bin
p_ = N(:)/sum(N);

% function_handle to match input x with bin and probabiltiy 
hpdf = @(x) p_(sum(bsxfun(@gt, x(:).', x_),1));


end

