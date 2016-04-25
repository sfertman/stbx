function [dataOut, keysOut, varsOut] = cases2vars( data, keyVars, idxVars )
% CASES2VARS performs SPSS style restructuring of tabular data. 
% data -- tabular data of type:
%   (-) numerical matrix
%   (-) cell array of mixed numerical and categorical (cellstr /
%       cetegorical / integer)
%   (-) <TODO> Matlab builtin table class should be supported too </TODO>
%
% keyVars -- column(s) of variable(s) that must uniquely identify cases
%   within case groups determined by indexVars after restructring
%   <TODO> also would be good idea to support the following input:
%   list of record identifying variables givent by: 
%   (-) numerical position index of column(s) in data or variable name(s)
%   if data is a table class object. keyVars must uniquely identify cases
%   within case groups determined by indexVars after restructring. </TODO>
%
% idxVars -- column(s) of variables that identify the the cases of which
%   new variables will be created.
%   <TODO> also would be good to support the following input:
%   list of indexing variables of type:
%   (-) numerical position index of column(s) in data or variable name(s)
%   if data is a table class object. idxVars identify the variables from
%   the cases of which new variables will be created. </TODO>
%
% data_out -- restructured tabular data of the same type as input data.
%
% <TODO> 
% (-) need to add some sanity checks:
%   (-) keyVars must uniquely identify records after reconstruction


%%% algorithm:
% - group data by indexVars (use: stbx.data.group_by)
% - sort ascending each group
% - merge the sorted groups by IDvars

% idxVars_logic = any(bsxfun(@eq, 1:size(data,2), idxVars(:)), 1);
% keyVars_logic = any(bsxfun(@eq, 1:size(data,2), keyVars(:)), 1);
% dataIdx_logic = ~(idxVars_logic & keyVars_logic);


if iscellstr(keyVars)
    [keysOut, ~, IC] = uniquerows_cellstr(keyVars,'sorted');
else
    [keysOut, ~, IC] = unique(keyVars, 'rows','sorted');
end
    
% C - category names for each bin, R - record numbers in each bin
[dataBinned, idxVars_, binIdx] = stbx.data.group_by(data, idxVars,'sorted');
keyVarsBinned = stbx.arr.cellsubsref(keyVars, binIdx);
% could also be done in a more stable way <v> if the above <^> dowsn't work
% keyVarsBinned = cellfun(@(r) keyVars(r,:), binIdx, 'UniformOutput', false);

% make sure keyVars uniquely identify records after grouping -- may be time consuning
assert(all(cellfun(@(k) size(k,1) == size(uniquerows_cellstr(k),1), keyVarsBinned)), 'Input key variables do not uniquely identify records for each value index vars.')
ICbinned = stbx.arr.cellsubsref(IC, binIdx);

dataOut = nan(size(keysOut,1),length(dataBinned));
for v = 1:length(idxVars_)
    dataOut(ICbinned{v},v) = data(binIdx{v},:);
end

varsOut = idxVars_.';

end

