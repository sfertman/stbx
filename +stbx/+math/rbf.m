function phi = rbf( r, a, func )
% //TODO: make this thing work on 2D matrix r and 1D vector a as well to
% match the description in help section below
%
% RBF - radial basis function. This function works only with the infinitely
% smooth kernels, i.e. these guys:
%
% Gaussian (GA): exp(-(a*r).^2)
% Inverse Quadratic (IQ): 1./(1 + (a*r).^2)
% Inverse multiquadratic (IMQ): 1./sqrt(1 + (a*r).^2)
% Multiquadratic (MQ): sqrt(1 + (a*r).^2)
%
% Inputs:
%   r - the radius, can be any real number (acalar, vector or matrix)
%   a - scaling parameter, any real number (although usually in (0,1] )
%   func - a string identifier of the radial function to be used, any of
%       the above mentioned, 'ga', 'iq', 'imq' or 'mq'
%
% If a is scalar, the function will be applied on all members of r in the
% same way, i.e. a*r.
%
% If a and r have the *same* dimensions, i.e. all(size(a)==size(r)) then
% inner product is used (a.*r);
% 
% If a has more than one dimension, it will be applied using bsxfun.
% Dimensions of r and a must match accordingly of course.
%
% Output:
%   phi(r,a)
%
% Example:
%   rbf(r, 0.1, 'ga') % where r is of any dimension
% will return 
%   exp(-(0.1*r).^2)
%
% Example:
%   r = rand(3,5); % random 3x5 r matrix
%   a = rand(1,5); % random 1x5 a vector
%   rbf(r, a, 'ga')
% will return
%   exp(-bxsfun(@times, a, r).^2);
%
% See also:
%   bsxfun

% setting default for a, if not exists
if ~exist('a','var') || isempty(a)
    a = 1;
end

% setting default for func, if not exist
if ~exist('func','var') || isempty(func)
    func = 'ga';
end

% figure out dimensions and compute ar = a*r accordingly. then use the
% result in the switch statement below

if isscalar(a)
    ar = a*r;
elseif all(size(a)==size(r))
    ar = a.*r;
else 
    ar = bsxfun(@times, a, r);
end

switch lower(func)
    case 'ga'
        phi = exp(-(ar).^2);
    case 'iq'
        phi = (1 + (ar).^2).^-1; % According to Matlab documentation, X.^-1 is numerically faster that 1./X 
    case 'imq'
        phi = sqrt(1 + (ar).^2).^-1; % According to Matlab documentation, X.^-1 is numerically faster that 1./X 
    case 'mq'
        phi = sqrt(1 + (ar).^2);
    otherwise
        error('Unsupported ''func'' parameter. See help for this file.');
end

end

