function [ output_args ] = spooled( varargin )
% SPOOLED(x1,x2,...) computes the pooled standard deviation of input
%   vectors x1, x2, ...
% SPOOLED(X) computes pooled std of all the columns of matrix X
% SPOOLED(X,[],DIM) computes pooled std of matrix X as above but along
%   dimension DIM.
% SPOOLED(C) computes pooled std of all column vectors in cell C
% SPOOLED(X, flag) sames flag behavior as in std and var 
% [...] = SPOOLED(..., PARAM1, VAL1, PARAM2, VAL2,...) uses parameter /
%   value pair to activate special behavior of this function. The possible
%   pairs are as follows:
%       'rows'    'all' (default) to use all rows regardless of missing
%                 values (NaNs), 'complete' to use only rows with no
%                 missing values, or 'pairwise' to compute RHO(i,j) using
%                 rows with no missing values in column i or j.
%       'skipsanity'    false (default) to NOT skip input "sanity" checks, 
%                       true to skip all input checks and go strait to
%                       number crunching. This option should be used only
%                       if the inputs are known to be compatible with this
%                       function. Otherwise, expect the unexpected, i.e.,
%                       the function may work or it may fail with or
%                       without informative error messages.
% See also: 
%   std


error(stbx.commons.err.underConstruction)


end

