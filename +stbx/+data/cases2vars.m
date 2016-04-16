function data_out = cases2vars( data, IDvars, indexVars )
% CASES2VARS performs SPSS style restructuring of tabular data. 
% data -- tabular data of type:
%   (-) numerical matrix
%   (-) cell array of mixed numerical and categorical (cellstr /
%       cetegorical / integer)
%   (-) Matlab builtin table class
%
% IDvars -- list of record identifying variables of type:
%   (-) categorical, cellstr, integer os general numerical
%   records may be identified by a single or multiple variables which must
%   ultimately yield unique (not wure if this has to be the case -- lets
%   not check it at first and see what happens) identification for each
%   record after restructring.
%
% indexVars -- list of indexing variables of type:
%   (-) 
%   Identifies the variables from the cases of which new variables will be 
%   created.
%
% data_out -- restructured tabular data of the same type as input data.


%%% algorithm:
% - group data by indexVars (use: stbx.data.group_by)
% - sort ascending each group
% - merge the sorted groups by IDvars


error(stbx.commons.err.underConstruction);


end

