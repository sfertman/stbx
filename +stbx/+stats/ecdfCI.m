function [ output_args ] = ecdfCI( X, C )

%ECDFCI empirical confidence intervals for ecdf

% assumes X,C are 1D

X = X(:); % make sure X is col vector

if ~exist('C', 'var')
    C = ones(size(X));
end


N = length(X);
n = floor(sqrt(N));

F_ = cell(n,1);
X_ = cell(n,1);

% randomize X,C
rnd_idx = randperm(N).';
X = X(rnd_idx);
C = C(rnd_idx);

for i = 1:n
%     comb_idx = (1:n) + (i-1)*n; % combination index
%     [F_{i}, X_{i}] = ecdf(X(comb_idx), 'frequency', C(comb_idx));
    [F_{i}, X_{i}] = ecdf(  X((1:n) + (i-1)*n), ...
                            'frequency', C((1:n) + (i-1)*n) );
end


[Xs, I] = sort(vertcat(X_{:}));
Fs = subsref(vertcat(F_{:}), struct('type', '()', 'subs', {{I}}));

% 30 is a "magic" number for a good enough sample size to have a reasonable
% approximation by normal distribution
nbins = floor(N/60);
bin_edg = linspace(min(X), max(X), nbins+1); % bin edges

bin_idx = sum(bsxfun(@gt, Xs, bin_edg),2) + 1; % actual bin number 


Xc = accumarray(bin_idx, Xs, [], @(x) mean(x), NaN);
% median is very similar to mean in in normal distributions
F_stats = accumarray(bin_idx, Fs, [], @(f) {[mean(f(:)), min(f(:)), max(f(:)), std(f(:),0) ]}, {nan(1,4)});
F_stats = vertcat(F_stats{:});

isnanXc = isnan(Xc);
Xc = Xc(~isnanXc);
F_stats = F_stats(~isnanXc, :);

%% plotting -- default for now, will have to be requested later
figure; hold on;
plot(Xc, F_stats(:,1), '-k', 'LineWidth', 2.0)
plot(Xc, F_stats(:,2), '^')
plot(Xc, F_stats(:,3), 'v')
plot(Xc, min(F_stats(:,1) + 2*F_stats(:,4),1), '-');
plot(Xc, max(F_stats(:,1) - 2*F_stats(:,4),0), '-');
legend('mean', 'inf', 'sup','CI', 'Location', 'SouthEast')




end

