function [H, pValue, KSstatistic] = ecdfkstest2( X1,C1, X2,C2, N, varargin )
% performs KS test between two populations given their ECDFs
% X1,C1 are the positions and counts for the first population 
% X2,C2 are the positions and counts for the second population
% If Ci are empty, 1 count per position is assumed
% N is the number of points to be used in interpolation of the two given
%   ECDFs
% Assuming 1 dimensional data (all inputs are vectors)
% additionl inputs are the same as in the builtin KSTEST2 function

% setting default values for now, will be parsed from input using my little
% awesome 'parseParams' function
tail = 0; 
alpha = 0.05;

X1 = X1(:);
X2 = X2(:);

if isempty(C1)
    C1 = ones(size(X1));
else
    assert(all(size(X1) == size(C1)), 'Size mismatch between positions and counts in first population.')
end

if isempty(C2)
    C2 = ones(size(X2));
else
    assert(all(size(X2) == size(C2)), 'Size mismatch between positions and counts in second population.')
end

% in order to perform K-S testing, everything has to be on the same grid
x_ = linspace(min([X1;X2]),max([X1;X2]),N);

sampleCDF1 = ksdensity(X1, x_, 'weights',C1, 'function','cdf');
sampleCDF2 = ksdensity(X2, x_, 'weights',C2, 'function','cdf');

%% starting here, (almost) everything was stolen from Mathworks
% Re: ^ my version will use exact equations, not like stuff below.

switch tail
   case  0      %  2-sided test: T = max|F1(x) - F2(x)|.
      deltaCDF  =  abs(sampleCDF1 - sampleCDF2);

   case -1      %  1-sided test: T = max[F2(x) - F1(x)].
      deltaCDF  =  sampleCDF2 - sampleCDF1;

   case  1      %  1-sided test: T = max[F1(x) - F2(x)].
      deltaCDF  =  sampleCDF1 - sampleCDF2;
end

KSstatistic   =  max(deltaCDF);

n1     =  length(sampleCDF1);
n2     =  length(sampleCDF2);
n      =  n1 * n2 /(n1 + n2);
lambda =  max((sqrt(n) + 0.12 + 0.11/sqrt(n)) * KSstatistic , 0);

if tail ~= 0        % 1-sided test.

   pValue  =  exp(-2 * lambda * lambda);

else                % 2-sided test (default).
%
%  Use the asymptotic Q-function to approximate the 2-sided P-value.
%
   j       =  (1:101)';
   pValue  =  2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
   pValue  =  min(max(pValue, 0), 1);

end

H  =  (alpha >= pValue);
