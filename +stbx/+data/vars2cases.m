function [ tvOut, fixedOut, tvCats, idxOut ] = vars2cases( data, transVars, tvNames )
% VARS2CASES performs SPSS style restructuring of tabular data. Equivalent
%   to table/stack in Matlab.
%
% Input:
% ------
% data -- tabular data of type:
%   (-) numerical matrix
%   (-) cell array of mixed numerical and categorical (cellstr /
%       cetegorical / integer)
%
% transVars -- variables to be transposed. All other variables in data will
%   be considered fixed variables implicitly. If trasVars is column vectors
%   or matrix, then each column is considered as a separate variable (must
%   have the same number of rows as data). If transVars is a row vector, it
%   must be a numeric or logical index specifying the columns in data to be
%   used as transVars.
%
% tvNames -- names of the variable to transpose. Can be anything, as long
%   as it matches in length to the number of transVars.
%
% Output:
% -------
% transOut -- reshaped transVars into a column
% fixedOut -- replicated constant variables (everything not transVars)
% tvCats -- column vector with the same num of rows as data containing the
%   names of the transposed variables that specify which transVars the row
%   had belong to prior to data resructuring. 
% idxOut -- column vector containing the row number that each new row was
%   taken from in the original table. e.g. assuming transVars is logical:
%       fixedOut(i,:) == data( idxOut(i) , ~transVars ) 


%%% assumtions:
% transVars is just one level for now.

[nrows, ncols] = size(data);
szTvars = size(transVars);

if szTvars(2) == 1 || all(szTvars(2)) % col or matrix
    assert(nrows == szTvars(1), 'data and transVars have to have the same number of rows.')
elseif szTvars(1) == 1 % row
    if islogical(transVars)
        assert(szTvars(2) == ncols, 'logical spec. of TV must match in size to the number of cols in data.')
    elseif isnumeric(trnsVars)
        assert(~any(transVars > ncols), 'tv index out of bounds.');
    else
        error('Wrong input, see help for this funciton.');
    end
    tv_temp = data(:, transVars);
    data(:, transVars) = [];
    transVars = tv_temp;
end

if ~exist('tvNames', 'var')
    tvNames = {};
else
    assert(length(tvNames(:)) == szTvars(2),'number of given names does not match num of TV.')
end

nargout_ = nargout;

if nargout_ >= 0
    tvOut = transVars(:); % making a column var from all the cols in transVars
    nanIdx = isnan(tvOut);
    tvOut(nanIdx) = [];
    nargout_ = nargout_ - 1;
end

if nargout_ > 0
    fixedOut = repmat(data, [szTvars(2), 1]);
    fixedOut(nanIdx, :) = [];
    nargout_ = nargout_ - 1;
end

if nargout_ > 0
    if ~isempty(tvNames)
        tvCats = repmat(tvNames, [nrows,1]);
    else
        tvCats = repmat(linspace(1,szTvars(2),szTvars(2)), [nrows,1]);
    end
    tvCats = tvCats(:);
    tvCats(nanIdx) = [];
    nargout_ = nargout_ - 1;        
end

if nargout_ > 0
    idxOut = repmat(linspace(1, nrows, nrows).', [szTvars(2), 1]);
    idxOut(nanIdx) = [];
    nargout_ = nargout_ - 1;    
end

