function P = f_cdf( x, d1, d2 )
% FDIST Fisher-Snedecor cummulative probability dustribution function
% <TODO.
%   (-) document vectorized behavior and options
% </TODO>
assert(all(x(:) >= 0), 'x values must be greter than zero.');
assert(all(d1(:) >= 0), 'd1 parameters must be greter than zero.');
assert(all(d2(:) >= 0), 'd2 parameters must be greter than zero.');


P = betainc(d1.*x./(d1.*x + d2), 0.5*d1, 0.5*d2);

end

