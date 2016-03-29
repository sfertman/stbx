function [tf, R, chi2_cr] = isWhiteNoise(X, m, alpha)
%isWhiteNoise tests whether a 1D sequence is white noise or not. The
%function uses chi square goodness of fit test to check for "second degree
%whiteness". 
% Inputs:
%   X is the sequence to test (1D vector)
%   m is the number of lags (default 10)
%   alpha is the confidence level (default 0.95)
% Outputs:
%   tf is true when the null hypothesis, H=0, cannot be rejected with
%   significance level of alpha. The null hypothesis states that the
%   sequence is white noise. If the null hypothesis is rejected then tf
%   returns false.
% 
% See also:
%   chi2inv

% <TODO> turn this into a more versatile tool "isNoise". The funtion should
% return some sort of indication of whiteness, brownness, pinkness, etc.
% (according to input parameter or otherwise maybe, maybe make it a group
% of functions or a class) of input sequence. 'Definite' yes/no decision
% could be made using Chi^2 goodness of fit as done for white-noise case
% here. </TODO>
% 

if ~exist('m','var')
    m = 10; % default value for number of lags for testing whiteness
end

if ~exist('alpha', 'var')
    alpha = 0.95;
end

N = length(X);
xc = xcorr(X,m);
l0 = floor(length(xc)/2) + 1; % zero lag location
lags = l0 + (1:m);
R = N*sum(xc(lags).^2)/xc(l0).^2;
chi2_cr = chi2inv(alpha, m);
tf = R <= chi2_cr;

end