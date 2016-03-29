function out = iffun(varargin)

% iffun works through an IF statement but doing so in one row.
% The familiar Matlab expression: 
%
%   if cond1
%       A = expr1;
%   elseif cond2
%       A = expr2;
%   ...
%   elseif condN
%       A = exprN;
%   else
%       A = default;
%   end
%
% can be now written in the following way using IFFUN:
% 
% A = iffun(cond1, expr1, cond2, expr2, ... condN, exprN, default);
%
% Number of inputs must be equal or greater than 3
%
% Important note: THIS FUNCTION TAKES condI AS THEY ARE!! IF CELLSTR OR
% SOMETHING WILL *NOT* COMPARE EACH MEMBER -- YOU GOT TO RIG THAT
% EXTERNALLY USING CELLFUN AND/OR CELLSTRSPEEDBOOST.
%
% See also, if, switchfun

% <TODO> can be implemented in mex for improved performance </TODO>

if nargin == 0
    help(mfilename);
    return
end

narginchk(3,inf); 

conditions = [varargin{1:2:end-2}];
firstTruth = find(conditions,1,'first');

if ~isempty(firstTruth)
    out = varargin{2*firstTruth};
else
    out = varargin{end};
end
