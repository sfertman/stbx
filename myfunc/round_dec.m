function rnd = round_dec(X,n)
% not needed anymore. randn does the exact same thing.
% Definition and execution
%    function rnd = round_dec(X,n), rnd = round(X.*10^-n).*10^n;
%
% rounds a number X to decimal accuracy specified by parameter n
%
% X a number -- any number or matrix permitted by the builtin 'round' 
% function
% 
% n is an integer scalar, play around with other numbers and get unexpected
% results
% n <  0    round to the n-th decimal 
% n == 0    round to nearest integer (regular round function behavior)
% n >  0    round to the nearest n-th power of 10

rnd = round(X.*10^-n).*10^n;