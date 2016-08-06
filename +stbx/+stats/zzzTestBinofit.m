K = 5000;
X = randn(K,1);
[n_, x_] = hist(X,50);
[p, ci] = stbx.stats.binofit(n_);
[p_, ci_] = binofit(n_, ones(size(n_))*sum(n_));

figure; ax = newplot; hold on
bar(ax, x_, p, 'FaceColor', 'w', 'EdgeColor', 'k')
% errorbar(ax, x_, p*sum(n_), ci{1}, ci{2}, 'LineStyle', 'none')
errorbar(ax, x_, p_, ci_(:,1), ci_(:,2), 'LineStyle', 'none', 'Color', 'r')
errorbar(ax, x_, n_/K, n_/K - 2*sqrt(n_.*(K-n_)/K)/K, n_/K + 2*sqrt(n_.*(K-n_)/K)/K)

% var = K*p*q
% std = sqrt(K*p*q) = sqrt(K*n/K*(K-n)/K)= sqrt(n*(K-n)/K) = sqrt(n*(1-n/K))=sqrt(
