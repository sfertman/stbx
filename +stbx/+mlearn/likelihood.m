function L = likelihood(X, f, LOGFLAG)

% X -- data, rows are iid sample points, cols are dimensions. 
% f -- probability distribution / density function handle(!). must be able
%   to work with data in X in vectorized form.

if ~exist('LOGFLAG', 'var') 
    LOGFLAG = 'log';
end

pX = f(X);

if strcmpi(LOGFLAG, 'log')
    L = sum(log(pX));
else
    L = prod(pX);
end
    
    

