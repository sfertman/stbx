function L = likelihood(D, f, LOGFLAG)

% X -- data, rows are iid sample points, cols are dimensions. 
% f -- probability distribution / density function handle(!). must be able
%   to work with data in X in vectorized form.

if ~exist('LOGFLAG', 'var')
    LOGFLAG = 'log'; 
end

% calculate conditional probability of input data
pX = f(D); 
% make sure that no probability is zero
pX(pX == 0) = min(pX(pX~=0))/1e6; 

if strcmpi(LOGFLAG, 'log')
    L = sum(log(pX));
else
    L = prod(pX);
end
    
    

