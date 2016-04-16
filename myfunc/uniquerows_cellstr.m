function [C, IA, IC] = uniquerows_cellstr(A)
% Quick a dirty implementation of unique(...,'rows') for cellstr case.
% Apparently builtin unique does not support the 'rows' parameter for
% cellstr inputs. Assumes A is cellstr. Outputs are the same as with
% builtin unique. 
% See also: 
%   unique
[~,~,IC] = arrayfun(@(u) unique(A(:,u)), 1:size(A,2), 'UniformOutput', false); 
[~, IA, IC] = unique([IC{:}], 'rows','stable');
C = A(IA,:);
end