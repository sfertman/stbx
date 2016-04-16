function Y = sort( X, distfun, varargin )
%SORT Summary of this function goes here
%   Detailed explanation goes here


% DISTFUN must be a function_handle that defines a distance between an
% input and zero. DISTFUN is applied on X as a whole, whether it is a
% scala,vector, matrix or n-d array. Use 'applyeach' to applies distfun to
% each element of X independently.

% probably best to use the input parser here
if ~isempty(varargin)
    assert(length(varargin) == 1,'Wrong numebr of inputs.');
    if ischar(varargin{1}) && strcmp(varargin{1},'applyeach')
        isApplyEach = true;
    else
        isApplyEach = false;
    end
end


if ~exist('distfun', 'var') || isempty(distfun)
    distfun = @(u) u;
    isApplyEach = false;
else
    assert(isa(distfun,'function_handle'),'DISTFUN input parameter must be of type ''function_handle''.');
end

if isApplyEach 
    distX = arrayfun(distfun, X);
else
    distX = distfun(X);
end

[~, I] = sort(distX);

Y = X(I);

end

