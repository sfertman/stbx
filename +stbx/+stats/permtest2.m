function [ H, P, CI ] = permtest2( X1, X2, testfun, testfunargs, varargin )
% PERMTEST2 performs permutaion testing of difference between two
% populations. The null hypothesis is that both populations are from the
% same distributions, and the alternative hypothesis is that they are not.
% This functions is based on:
% https://normaldeviate.wordpress.com/2012/07/14/modern-two-sample-tests/
%
% H = PERMTEST2( X1, X2 ) -- performs permutaion test between two 
%   populations given in vectors X1 and X2 using ttest by default. The
%   function returns 0 if the null hypothesis cannot be regected at 0.05
%   significance level and 1 otherwise.
%
% PERMTEST2(X1,X2, tests) -- performs the testing using the function
%   pointed to by handle testfun. testfun can be builtin (ttest2, kstest2,
%   etc...) or user defined. The function must accept two populations as
%   first inputs. If testfun is not given, @ttest2 will be used by default.
% 
% PERMTEST2(X1,X2, testfun, testfunargs) -- passes additional arguments in
%   cell array testfunargs to testfun in the following manner:
%   testfun(X1,X2,testfunargs{:}). See example bellow for clarification. 
%
% [H,P] = PERMTEST2(...) also returns the P value.
%
% [H,P,CI] = PERMTEST2(...) also returns the confidence intervals.
%
%
% % Example: 
% % --------
% % Compare two Gaussian disributions with a left tailed T-test at
% % significance level of 0.01: 
%       X1 = 1.0 + 0.2*randn(100,1);
%       X2 = 0.5 + 1.0*randn(100,1);
%       [H,P] = permtest2(X1,X2, @ttest2, {'tail','left', 'alpha',0.01});

% TODO:
%   (-) Actually we would require the test statistic function and more
%       arguments as input and not the matlab builtin sig. testing
%       function. 

error(stbx.commons.err.underConstruction)

end

