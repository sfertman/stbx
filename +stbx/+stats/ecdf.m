function [ F, x ] = ecdf( X )
%EMPCDF computes empirical cdf from given data

% assumptions x is numerical 1D for now


x = sort(X);

F = cumsum(ones(size(x)))/numel(x);


end

