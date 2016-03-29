function y_hat = smgauss1d( X, Y, h)
% takes in 1D data and smmoths it out using Gaussian kernel
% X is X
% Y is Y
% h is the kernel radius
% y_hat is Y after smoothing
%
% X and Y are assumed to be one dimensional vectrors!!

if length(X) > 1e4, error('Input too large, the function is likely to crash the computer, cannot continue...'); end

X = X(:).';
distmat = bsxfun(@(u,v) abs(u-v), X, X.'); 
% //TODO: make this^ deal with huge data inputs without using bsxfun. 
% //TODO: (optional) Make the function decide when it should use bsxfun for
% speed and when it should use a loop to avoid matlab stalling the PC 

if isscalar(h)
    K = @(x0) exp(-0.5*(distmat/h).^2);
else
    K = @(x0) exp(-0.5*bsxfun(@rdivide, distmat, h(:).').^2);
end
KX = K(X);

y_hat = sum(bsxfun(@times, KX, Y(:).'), 2)./sum(KX,2);

end

