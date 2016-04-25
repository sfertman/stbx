function [C, IA, IB] = unionrows_cellstr(A,B)
% Quick a dirty implementation of UNION(...,'rows') for cellstr matrix
% case. Apparently builtin UNION does not support the 'rows' parameter for
% cellstr inputs. Assumes A is cellstr matrix. Outputs are the same as with
% builtin UNION. 
% See also:
%   union

% <TODO> 
%   the function supports 2 inputs -- make work with any number
% </TODO>
A_ = arrayfun(@(u) strcat(A{u,:}), 1:size(A,1), 'UniformOutput', false);
B_ = arrayfun(@(u) strcat(B{u,:}), 1:size(B,1), 'UniformOutput', false);
[~, IA, IB] = union(A_,B_,'stable');
C = vertcat(A(IA), B(IB));

% another, faster way of doing this might go osmething like this:
% - vertcat the matrices A nd B
% - use uniquerows_cellstr on the result
% - figure out the index vectors IA and IB 
%   - maybe something like applying one of the outputs of unique on
%     [1:length(A), 1:lenth(B)]'



end