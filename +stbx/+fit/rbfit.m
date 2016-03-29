function rbfit = rbfit( data, X, func, N, skipSanity )
% RBFDATAFIT fits a set of radial basis functions to the scatered input
% data. The best fit is estimated by minimizing the sum of square errors of
% the resulting fit from the data points using some fancy optimization
% algorithm.
%
% Inputs:
%   data -- is an N-dimensional matrix of scattered data
%   X -- is a set of N-dimensional coordinates for each datapoint. X
%       can be input in one of two ways, either a N-long cell array where
%       each member is a vector containing one coordinate axis values. Or,
%       if given as [] or {}, a uniform grid is assumed for each dimension.
%   func -- is the radial basis function to be used. If not given, default
%       will be used according to rbf.m function. Type 'help stbx.math.rbf'
%       for further details.
%   N -- is the number of functions to use in the fit model. If it is not
%       given, the optimal number of functions will be determined
%       automatically at some computational expense. //TODO: right now it
%       uses 10 by default
%   skipSanity -- is flag to indicate skipping of all sanity checks in the
%       beginning of this function for added performance. Values accepted
%       are truTe or false. Use at your own risk. If skipSanity is true,
%       then the assumption is that X and data are consistent and ready to
%       rock and roll. N is assumed to be given also. 
% Output:
%   rbfit -- is an array of structures where each member repesents one of
%       the set of fitting funtions. 
%       rbfit(:).w -- are the weigths for each function in the model
%       rbfit(:).a -- are the scaling parameters for each function
%       rbfit(:).c -- are the constant offsets for each function
%
% See also:
%   stbx.math.rbf





warning('not done - start and finish it!');

sz = size(data);
nthvarout

if ~skipSanity
    % figure out X
    if ~exist('X', 'var') || isempty(X)
        % create a unifor grid for X
        X = cellfun(@(u) 1:u, num2cell(sz), 'UniformOutput', false);
    elseif iscell(X)
        % make sure it's a cell array of numerics and the sizes math 'data'
        assert_func = @(x, lng) isnumeric(x) && isvector(x) && length(x) == lng;
        assert_msg = 'All members of coord cell array must be numeric vectors of lengths corresponding with the sizes if the data matrix in each dimension. See help for this file.';
        assert(all(cellfun(assert_func, X, num2cell(sz))), assert_msg);
    end
    
    % figure out N
    if ~exist('N', 'var') || isempty(N)
       %%% do something to figure it out automatically. In the meanwhile
       %%% default value of 10 will be used.
       N = 10;
    end
end    

% assume initial guesses for the weights 'w'
% assume initial guesses for the scaling parameters 'a'
% assume initial guesses for the constant offsets 'c'
% calculate the square error for the current fit
%
% while error is too large
%   (-) optimize for all parameters together 
%       OR
%   (1) optimize 'w'
%   (2) optimize 'a'
%   (3) optimize 'c'
% end

% optimize for 'w'
% get error gradient with respect for each 'w' - gradient descent
% maybe get hessian with respect for each 'w' - Newton's method

% error derivative wrt weights is just the rbf for i == j and zero
% otherwise. for exp, it's: exp(-(a*r).^2)

% error derivative wrt a is more comlcated 
% for exp, it's: exp(-(a*r).^2).*(2*a.*r.^2)
% for other things we might do it later

% error derivative wrt to c (where r = sqrt(x.^2 - c.^2)) is complicated 2
% for exp, it's: 
%       exp(-(a*r).^2).*(2*r.*a.^2).*dr_dc
%       exp(-(a*r).^2).*(2*r.*a.^2).*(2*c.*(x.^2 - c.^2).^(-0.5))


end



function rbf_original 
switch lower(func)
    case 'ga'
        phi = exp(-(ar).^2);
    case 'iq'
        phi = (1 + (ar).^2).^-1; % X.^1 is numerically faster that 1./X or at least supposed to be
    case 'imq'
        phi = sqrt(1 + (ar).^2).^-1;
    case 'mq'
        phi = sqrt(1 + (ar).^2);
    otherwise
        error('Unsupported ''func'' parameter. See help for this file.');
end

end
