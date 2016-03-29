function dX = diff( func, X, N, method )

switch lower(method)
    case 'backward'
        
    case 'forward'

    case 'central'
        dX = diff_central(func, N);
    otherwise
        error('Unknown method.')
end

end

function dX = diff_backward(X, N)
end

function dX = diff_central(X, N)
% 2nd derivative case:
% f''(x) ~ ( f(x+h) - 2f(x) + f(x-h) ) / h^2
% OR 
% f''(x) ~ ( X(i+1) - 2X(i) + x(i-1) ) / 1^2 % cuz we don't have x and y axes
    ii = 0:N;
    dX = sum( (-1).^ii.*n_over_k(N, ii).*X
end

function dX = diff_forward(X, N)
end

function nok = n_over_k(n, k)
nok = factorial(n)./factorial(k)./factorial(n-k);
end
