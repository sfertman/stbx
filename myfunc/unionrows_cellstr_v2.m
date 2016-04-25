function [U, IA, IC] = unionrows_cellstr_v2(varargin)
% Quick a dirty implementation of UNION(...,'rows') for cellstr matrix
% case. Apparently builtin UNION does not support the 'rows' parameter for
% cellstr inputs. Assumes A is cellstr matrix. Outputs are the same as with
% builtin UNION. 
% U = unionrows_cellstr(A,B,C,...) returns the union of input A,B,C,...
%
% <TODO> rewrite help to match function

% [U,IA,IB,IC,...] = unionrows_cellstr(A,B,C,...) also returns index
%   vectors IA,IB,IC,... such that U is a sorted combination of the values
%   A(IA,:),B(IB,:),C(IC,:),... If there are common values in A,B,C,...
%   then the index is returned according to the first time it is
%   encountered. If there are repeated values in A,B,C,... then the index
%   of the first occurrence of each repeated value is returned.

% returns the indices
% of A,B,C,... the way they appear in U, i.e., 
%   U = vertcat(A(IA,:), B(IB,:), C(IC,:), ...)
% See also:
%   union

% <TODO> 
%   need to add support for 'stable' and 'sorted' optional inputs (now
%   implemented as stable)
% </TODO>

%% Input verification
% make sure all inputs are cellstr
assert(all(cellfun(@(v) iscellstr(v), varargin)),'This function supports cellstr inputs only.');
% make sure all inputs have the same number of columns
assert(length(unique(cellfun(@(v) size(v,2), varargin))) == 1, 'All inputs must have the same numebr of columns.');

% A_ = arrayfun(@(u) strcat(A{u,:}), 1:size(A,1), 'UniformOutput', false);
% B_ = arrayfun(@(u) strcat(B{u,:}), 1:size(B,1), 'UniformOutput', false);
% [~, IA, IB] = union(A_,B_,'stable');
% U = vertcat(A(IA), B(IB));

% another, faster way of doing this might go osmething like this:
% - vertcat the input matrices A,B,...
% - use uniquerows_cellstr on the result
[U,IV,IU] = uniquerows_cellstr(vertcat(varargin{:}));

% - figure out the index vectors IA,IB,...
%   - maybe something like applying one of the outputs of unique on
%     [1:length(A), 1:lenth(B), ...]'

I_ = cellfun(@(v) (1:length(v)).', varargin, 'UniformOutput', false);
I_ = vertcat(I_{:}); % should give a column of doubles
I = I_(IV);

iU_ = cellfun(@(v, i) repmat(i, [size(v,1), 1]), varargin, num2cell(1:length(varargin)), 'UniformOutput', false);
iU_ = vertcat(iU_{:})



end