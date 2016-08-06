function [ output_args ] = compare( varargin )
% COMPARE performs pairwise comparisons of the input data sets using a
% specified statistical tests and significance correction methods. Null
% hypothesis is that there is no difference from zero or given measure, or
% no difference between sample populations. Alternative hypothesis is that
% there IS difference from zero/measure or between samples.
%
% compare(x) -- compare data in vector x agains zero
% COMPARE(x,y,...) -- compare data in vectors x,y,...
% COMPARE(X) -- campare the columns of the matrix X
% COMPARE(..., P1,V1, P2,V2, ...) -- modifies the behavior of the function
%   using parameter-value pair input. Possible options:
%   (-) '-test' -- choose a statistical test for comparison. 
%       (-) 'ttest' -- T-test (default) 
%       (-) 'ftest' -- F-test
%       (-) 'chi2' -- Chi squared test of fit
%       (-) 'coh_d' -- Cohen's d effect size measure
%       (-) ... implement more test that matlab has ...
%   (-) '-alpha' -- significance level, numeric (default 0.05)
%   (-) '-tail' -- A string specifying the alternative hypothesis:
%       (-) 'both'  -- "mean is not M" (two-tailed test - default)
%       (-) 'right' -- "mean is greater than M" (right-tailed test)
%       (-) 'left'  -- "mean is less than M" (left-tailed test)
%   (-) '-adj' -- choose multiple comparisons penalty/adjustment of
%       significance level.
%       (-) 'lsd' -- least significant distance method (equvalent to no
%           adjustment).
%       (-) 'bon' -- Bonferroni method
%       (-) 'sid' -- Sidak method, don't know what this is yet, but SPSS
%           has it, so I think so should I.
%   (-) '-rows' -- like in corr (copy/paste from there)
%       (-) default should be taking each data-set as completely
%           independent samples 
%   (-) '-skipsanity' -- if logical 1, true or 'on', skips sanity checks
%       for input and goes straight to the number crunching. If logical 0,
%       false or 'off' performs input checkes and crashes gracefully
%       (hopefully) when something goes terribly wrong. Use if you know
%       what you're doing.
%
% See also:
%   ttest, ztest and others

error(stbx.commons.err.underConstruction);
end

