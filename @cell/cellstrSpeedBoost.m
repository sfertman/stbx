function B = cellstrSpeedBoost(f, A, varargin)
% function [out] = cellstrSpeedBoost(func, cellstr_in, varargin)
%
% B = cellstrSpeedBoost(FUNC, A)
% B = cellstrSpeedBoost(FUNC, A, x, y, z, ...)
% 
% FUNC - function handle
% A - the data structure to pass to that function
% varargin - comma separated list of arguments to be passed to the function
% ( func(cellstr_in, x, y, z, ...) )
%
%
% This function attempts to shorten processing time of cellstr data types
% by finding repeated strings in cell. If your cell array is big, contains
% strings that repeat many times and the processing done on these strings
% is regardless of their position in cell, this will work much faster that
% one by one iteration. Otherwise -- expect the unexpected. 
%
% One very usefull way of using this function is the following: instead of
% applying a function directly on the cell array 'A' like so: 
%
%   B = some_function( A, x, y, z, ... ) 
%
% wrap it with 'cellstrSpeedBoost' by passing an anonymous function to it:
%
%   B = cellstrSpeedBoost( @(U) some_function( U, x, y, z, ... ), A );
%
% Example: 
% --------
% Adding a suffix to each string in cell array (run the code below to see
% the difference in speed, and don't forget to check out the results in
% your workspace):
%
%   % 500 random numbers that will be repeated many times in our test array
%   some_numbers = 1e4*rand(500,1); 
%   % replicating the numbers into a much larger vector
%   some_numbers = repmat(some_numbers, [1000,1]);
%   % transforming the numbers into a cell array of strings
%   cellArray = cellstr(num2str(some_numbers, '%04.0f'));
%   % defining the suffix we want to add:
%   suffix = '_mySuffix'; 
%
%   % Usually one would do it like this:
%       tic;
%       B_1 = cellfun(@(u) [u, suffix], cellArray, 'UniformOutput', false);
%       fprintf('Done task the hard way in %0.3f sec\n', toc);
%
%   % For this task specifically Matlab has a useful function called
%   % 'strcat'. Using 'strcat' results in slightly better processing time:
%       tic;
%       B_1a = strcat(cellArray, suffix);
%       fprintf('Done task the Matlab way (strcat) in %0.3f sec\n', toc);
%
%   % Using 'cellstrSpeedBoost' it would look like this:
%       tic;
%       func = @(v) cellfun(@(u) [u, suffix], v, 'UniformOutput', false);
%       B_2 = cellstrSpeedBoost(func, cellArray);
%       fprintf('Done task the fast way in %0.3f sec\n', toc);
% 

[A_u, ~, i_au] = unique(A);
B_u = f(A_u, varargin{:});
B = B_u(i_au);
