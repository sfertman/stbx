function [r_sqr, cos_gamma] = curvature( X, Y )
% CURVATURE finds the local *square* curvature radius of a given spline. Up
% to 2D inputs are allowed since curvature might have a more complicated
% definition in hyper-surfaces, so in case of a matrix the function
% operates along the rows. The output is of the same size as the input
% matrix.

assert(all(size(X) == size(Y)), 'X and Y must be of the same size');

r_sqr = nan(size(X));

% cos(gamma) = 0.5*(a^2 + b^2 - c^2)/a/b
a_sqr = (X(:,1:end-2) - X(:,2:end-1)).^2 + (Y(:,1:end-2) - Y(:,2:end-1)).^2;
b_sqr = (X(:,2:end-1) - X(:,3:end)).^2 + (Y(:,2:end-1) - Y(:,3:end)).^2;
c_sqr = (X(:,1:end-2) - X(:,3:end)).^2 + (Y(:,1:end-2) - Y(:,3:end)).^2;

cos_gamma = 0.5*(c_sqr - a_sqr - b_sqr)./sqrt(a_sqr.*b_sqr);

r_sqr(:,2:end-1) = 0.25*c_sqr./(1+cos_gamma.^2);
r_sqr(:,1) = r_sqr(:,2);
r_sqr(:,end) = r_sqr(:,end-1);

if nargin == 2
    cos_gamma = [cos_gamma(1), cos_gamma, cos_gamma(end)];
end

end

