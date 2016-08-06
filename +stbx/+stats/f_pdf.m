function p = f_pdf( x, d1, d2 )
% FDIST Fisher-Snedecor probability dustribution function
assert(all(x(:) >= 0), 'x values must be greter than zero.');
assert(all(d1(:) >= 0), 'd1 parameters must be greter than zero.');
assert(all(d2(:) >= 0), 'd2 parameters must be greter than zero.');

p = sqrt( ((d1.*x).^d1).*(d2.^d2)./(d1.*x + d2).^(d1+d2) )./x./beta(0.5*d1,0.5*d2);

end

