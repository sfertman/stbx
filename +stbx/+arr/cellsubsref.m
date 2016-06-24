% CELLSUBSREF works basically like cellfun on subsref but at C++ breakneck 
% speeds. It doesn't support everything under the sun just yet but 
% the goal is to eventually support all possible Matlab/Octave classes and 
% cases.
%
% This function will save time if you need to make a large number of 
% references to small portion of you array. For small number of references
% to large portions of array, cellfun is faster (see below).
%   
% Example of use:
%   Y = CELLSUBSREF(X, R)
% is equivalent to:
%   Y = cellfun(@(r) X(r), R, 'UniformOutput', false);
%
% Example code to test different array types and timing vs. cellfun:
%
%   import stbx.arr.CELLSUBSREF;
% 
%   % number of random subscripts
%   N = 100e3; 
% 
%   % max number of subscripts in a single cell
%   n = 5;
% 
%   % number of runs to test mex overhead
%   M = 10;
% 
%   % generating a cell array to fetch members from
%   X = {'a','b','c','d','e','f','gh','ijk',1,2}.';  
%   X = repmat(X, 10e3,1);
% 
%   % length of X
%   L = length(X);
% 
%   % generating random subs cell array
%   R = cellfun(@(~) randi(L, randi(n,1),1) ,num2cell((1:N).'), 'UniformOutput', false); 
% 
%   fprintf('Length of array to process: %d\n', L);
%   fprintf('Total number of subscripts to process: %d\n',length(vertcat(R{:})))
% 
%   tic
%   a = CELLSUBSREF(X, R);
%   fprintf('Single CELLSUBSREF run completed in %0.3f seconds.\n',toc)
% 
%   tic
%   a = cellfun(@(r) X(r), R, 'UniformOutput', false);
%   fprintf('Single CELLFUN run completed in %0.3f seconds.\n',toc)
% 
%   tic 
%   for i = 1:M, a = CELLSUBSREF(X,R); end
%   fprintf('%d CELLSUBSREF runs completed in %0.3f seconds.\n',M, toc)
% 
%   tic 
%   for i = 1:M, a = cellfun(@(r) X(r), R, 'UniformOutput', false); end
%   fprintf('%d CELLFUN runs completed in %0.3f seconds.\n',M, toc)
%
% See also:
%   cellfun



