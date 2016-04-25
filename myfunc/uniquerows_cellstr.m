function [C, IA, IC] = uniquerows_cellstr(A, SORTFLAG)
% Quick a dirty implementation of UNIQUE(...,'rows') for cellstr matrix
% case. Apparently builtin UNIQUE does not support the 'rows' parameter for
% cellstr inputs. Assumes A is cellstr matrix. Outputs are the same as with
% builtin UNIQUE. 'sorted' and 'stable' keywords are also supported. 
% See also: 
%   unique

if ~exist('SORTFLAG', 'var')
    SORTFLAG = 'sorted';
else
    assert(ischar(SORTFLAG), 'SORTFLAG parameter must be of type char.');
    assert(any(strcmpi(SORTFLAG, {'sorted', 'stable'})), 'Unknown input parameter: ''%s''.', SORTFLAG);
end

[~,~,IC] = arrayfun(@(u) unique(A(:,u),'sorted'), 1:size(A,2), 'UniformOutput', false); 
% <^> sorting is required when SORTFLAG == 'sorted' and doesn't matter when
% SORTFLAG == 'stable', so I force it here without a check.
[~, IA, IC] = unique([IC{:}], 'rows', SORTFLAG);
C = A(IA,:);
end