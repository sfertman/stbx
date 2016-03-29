function out = nthvarout(n, func, varargin)
% returns only the n-th argument of a function. Sometimes this is usefull
% in anonymous functions where we cannot access anything but the firt
% output argument. Thus this workaround.
% n - the index of the variable you want to get.
% func - function_handle of what you want to calculate (e.g. @max, @sin )
% varargin - list of input arguments to the function 
% Example: 
% Conventionally, to get the location of the maximum element in a 1D array
% A you would use: [~, i] = max(A); however, in an annonymous function it 
% is impossible to define new variables (static workspace?) and to be able 
% to access functions' outputs that are not first in line we must use a 
% workaroud like in the following example. 
% func = @(u) nthvarout(2, @max, A) > nthvarout(2, @min, B)
%

[funcvarout{1:n}] = func(varargin{:});
out = funcvarout{n};