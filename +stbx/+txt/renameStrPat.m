function strout = renameStrPat(str_in, read_pat, write_pat)
assert(nargin == 3, 'This function accepts 3 inputs exactly.');
%% Input (old_pat)
vardefidx = regexp(read_pat, {'%','#'}); % read positions of special characters in each input string
temp = cellfun(@size, vardefidx, 'UniformOutput', false); % get size of index vector (number of variables)
assert(isequal(temp{:}),'All input variables must have type (%) and name (#). Read help for this file for correct use.') % make sure  that each variable has a '%' and a '#', i.e. type and name, respectively

%%% get input var names
vardefidx_ = vertcat(vardefidx{:}).'; % each row is a var, 1st col var type begin (%) 2nd col var name begin (#)
varnames_in = read_pat(vardefidx_(:,2) + 1); % input var names
vars_ingnore_idx = varnames_in == '~';
varnames_in(vars_ingnore_idx) = [];
nvars = length(varnames_in); % number of input variables
% nvars = sum(varnames_in ~= '~');

% get read pattern for textscan by removing var entries (# and the one
% letter that comes next
txtscn_read_pat = read_pat;
txtscn_read_pat([vardefidx_(:,2),vardefidx_(:,2)+1]) = [];


%%% get input var types: everything between '%' (incl) and '#' (excl)
vartypes_in = cellfun(@(u) read_pat(u(1):u(2)-1), num2cell(vardefidx_,2),'UniformOutput', false).';
vartypes_in(vars_ingnore_idx) = [];

%% Output (new_pat) 
% new pattern variable names (the letter that comes after '#' in 'write_pat') 
% this is in order to determine their location in the output set of strings
vardefidx = regexp(write_pat, '#');
varnames_out = write_pat(vardefidx + 1);

% making sure that the number of input and output variables is identical 
assert(length(varnames_out) == nvars, 'The number of input and output variables must be the same.');

eqlogicmat = bsxfun(@eq, varnames_in, varnames_out');
originordermat = repmat((1:nvars)',[1,nvars]);
varout_order_idx = originordermat(eqlogicmat);
% % % 
% % % VVV=double(horzcat(varvals_in{:}));
% % % varvals_out_= VVV(:,ccc(vvv));

strout_pat = regexp(write_pat, '#\w','split');
strout_pat_ = strout_pat(1:nvars);




vartypes_out_ = vartypes_in(varout_order_idx);
strout_str = [strout_pat_',vartypes_out_'].';
strout_str = strcat([strout_str{:}], [strout_pat{nvars+1:end}]);


%% actual reading of input
%%% read variables' values from input cellstr
% [ALL_VALS_IN, ~, ERRMSG, ~] = cellfun(@(u) sscanf(u, txtscn_read_pat), str_in, 'UniformOutput', false);
[ALL_VALS_IN,~,ERRMSG] = cellfun(@(u) sscanf(u, txtscn_read_pat), str_in, 'UniformOutput', false);
% warning('try to cellstrSpeedBoost the reading above...');
% will definitely be faster but can also be accelerated from outside -- no
% need to waste time for large arrays that cannot be accelerated
% ALL_VALS_IN = cellfun(@(u) u.', ALL_VALS_IN, 'UniformOutput', false);
%%% logical idx of strings that match input pattern - only them will be
%%% processed
remstridx = cellfun('isempty', ERRMSG);% & cellfun(@(u) u == nvars,  COUNT);
% remstridx = ~cellfun('isempty', ALL_VALS_IN);
varvals_in = ALL_VALS_IN(remstridx);

VVV = double(horzcat(varvals_in{:})); % each row is a var, each col is an input string
VVV(vars_ingnore_idx,:) = [];
%%% output variables
varvals_out_= VVV(varout_order_idx,:);


%% actual writing of output
% strout_ = regexp(sprintf(strout_str+'###', varvals_out_.'),'###','split');
% % textscan version -- vars in a row
strout_ = regexp(sprintf(strout_str+'###', varvals_out_),'###','split'); 
strout_ = strout_(1:end-1); 

strout = cell(size(str_in));
strout(~remstridx) = str_in(~remstridx);
strout(remstridx) = strout_;



end

