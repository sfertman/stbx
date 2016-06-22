function dX = diff( func, X, N, method )

switch lower(method)
    case 'backward'
        
    case 'forward'

    case 'central'
        dX = diff_central(func, X, N);
    otherwise
        error('Unknown method.')
end

end

function dX = diff_backward(X, N)
end

function dX = diff_central(f, X, N)
% 2nd derivative case:
% f''(x) ~ ( f(x+h) - 2f(x) + f(x-h) ) / h^2
% OR 
% f''(x) ~ ( X(i+1) - 2X(i) + x(i-1) ) / 1^2 % cuz we don't have x and y axes

h = get_h(N);
ii = (0:N).';
dX = sum(((-1).^ii).*n_over_k(N, ii).*f(x + (0.5*N - ii)*h))/h^N;
end

function dX = diff_forward(X, N)
end

function h = get_h(~)
% allow for more sophistication later on
h = 1e-8;
end

function nok = n_over_k(n, k)
nok = factorial(n)./factorial(k)./factorial(n-k);
end
