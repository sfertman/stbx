function out = switchfun(varargin)
% switchfun takes the switch statement construct and makes it work in one
% line. Type 'help switch' for info on its syntax. Only one expression
% (actually a return value) is supported per case. If non of the
% comparisons returns true, 'default_val' is returned. If 'default_val' is
% not given then an empty array ([]) is returned.
%
% So, the following well known Matlab switch expression: 
%
% switch switch_expr
%     case case_expr,
%         out = return_val;
%     case {case_expr1, case_expr2, case_expr3,...}
%         out = return_val_n;
%     ...
%     otherwise
%         out = default_val;
% end
%
% may be written in one line using the following syntax
%
% out = switchfun(switch_expr, case_expr, return_val, {case_expr1, case_expr2, case_expr3,...}, return_val_n, ..., default_val)
%

if nargin == 0
    help(mfilename);
    return
end

[switch_expr, varargin] = deal(varargin{1}, varargin(2:end));

if rem(length(varargin), 2) == 1
    [varargin, default_val] = deal(varargin(1:end-1), varargin{end});
end

case_exprs   = varargin(1:2:end-1); % get case expressions 
return_vals  = varargin(2:2:end);   % get return values for each case expr
if ischar(switch_expr) || iscellstr(switch_expr) && isscalar(switch_expr)
    return_val_ind = find(cellfun(@(u) any(strcmp(switch_expr, u)), case_exprs),1,'first'); % compare switch_expr with each case_exprs and return the first one that works
else
    return_val_ind = find(cellfun(@(u) any(isequal_(switch_expr, u)), case_exprs),1,'first'); % compare switch_expr with each case_exprs and return the first one that works
end

if ~isempty(return_val_ind)
    out = return_vals{return_val_ind};
elseif exist('default_val', 'var')
    out = default_val;
else
    out = [];
end

end

function yes_no = isequal_(A, B)
if ~iscell(B), B = {B}; end;
yes_no = cellfun(@(u) isequal(A,u), B);
end