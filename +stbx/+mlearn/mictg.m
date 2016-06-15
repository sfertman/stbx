function [ output_args ] = mictg( varargin )
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% MICTG computes the mutual information between categorical and real random
% variables. Copyright (C) 2016 Alexander Fertman.
%     
%     This file is part of STBX package.
%
%     STBX package is distributed in the hope that it will be useful and
%     it is absolutely free. You can do whatever you want with it as long
%     as it complies with GPLv3 license conditions. Read it in full at: 
%     <http://www.gnu.org/licenses/gpl-3.0.txt>. Needless to say that
%     this program comes WITHOUT ANY WARRANTY for ANYTHING WHATSOEVER. 
%   
%     On a personal note, if you do end up using any of my code, consider
%     sending me a note. I would like to hear about the cool new things my
%     code helped to make and get some inspiration for my future projects
%     too.
%     
%     Cheers.
%     -- Alexander F.
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% MICTG computes the mutual information between categorical and real random
% variables.
% Usage posibilities:
% MICTG(X,C) --- X is data, C is category specification. C can be a vector of
%   several types which may be considered categorical: any type of integer,
%   cell array of strings (cellstr) and Matlab's builtin categorical array.
%   Every data point must be assigned with a category, i.e., X and G must 
%   have the same length.
% MICTG(V1,V2,V3,...) --- assumes that the inputs V1,V2,V3,... are data 
%   points given categories C1,C2,C3,... implicitly specified by the number
%   of input vectors.
%
% <TODO> 
% detailed help file to characterize all aspects of this function that need
% to be written
% </TODO>

% assuming:
% C is categorical and X is numeric continuous / descrete or ordinal 
% X and C are column vectors 
% X and C do not have NaNs inside

validTypesForC = {'categorical', 'cellstr', 'integer'};
validateType = @(u) iscategorical(u) || ...
                    iscellstr(u) || ...
                    isinteger(u); 

%% figuring out inputs
if nargin < 2
    error('Not enough inputs.')
elseif nargin == 2
    if isnumeric(varargin{1})
        assert(...
            isvector(varargin{1}) && isvector(varargin{2}) && ...
            length(varargin{1}) == length(varargin{1}), ...
            'Inputs must be vectors of the same length.' );
        
%         CvarIdx = cellfun(@(u) isany(u, validTypesForC), varargin);
        CvarIdx = cellfun(@(u) validateType(u), varargin);
        switch sum(CvarIdx)
            case 0
                error('Only the following types are supported for now: %s.', strcatDelim(validTypesForC));
            case 1
                X = varargin{~CvarIdx}; assert(isnumeric(X), 'Continuous variable must be numeric non-integer.');
                G = varargin{CvarIdx}; 
                % <TODO> split X into a bunch of arrays according to C
                % </TODO>
            case 2
                error('Only one categorical variable allowed.');
        end
     end
else % if nargin > 2
    assert(all(cellfun(@(u) iscolumn(u) && isnumeric(u), varargin)), 'If 3 or more inputs, all inputs must be numeric column vectors.')
%     X = varargin;
    X = vertcat(varargin{:}); % numeric variable
    G = int32(1:length(varargin)); % categorical variable (maybe I don't even need it)
end

% -- put X and C cells into one big vector X and vector C
% -- sort both vectors by X
[X, I] = sort(X);
G = G(I);
% -- divide vectors again by C
[uG, ~, IuG] = unique(G);
% G = uG(IuG)
X = arrayfun(@(i) X(IuG == i,:), unique(IuG), 'UniformOutput', false);

%% mi calculation

% get the index of the nearest neighbour of each elment of X
[~, i_knn] = cellfun(@(x) stbx.ml.knn(x, 1, 'sort'), X, 'UniformOutput', false);

return

assert(isvector(X) && isvector(Y) && length(X) == length(Y), 'Inputs must be vectors of the same length.');
assert(isnumeric(X),'First input must be numeric.')

validTypesForC = {'categorical', 'cellstr', 'integer'};
errMsgVldTyC = sprintf('Second input must be one of the following types: %s.', strcatDelim(validTypesForC));
for i = 1:length(validTypesForC)
    assert(isa(Y, validTypesForC{i}), errMsgVldTyC);
end


% total number of points
N = length(X); % assuming X and C are the same length

% sort X
[Xs,IXs] = sort(X);
% sort Y by X
Ys = Y(IXs);

% get unique categories
[uYs, IYs, IuYs] = unique(Ys);

nc = length(uYs); % number of unique categories

XbyY = cell(1,nc);
for i = 1:nc
    % I'm sure one of the 'unique' indices can be used to compute XbyY
    % without explicitly comparing Ys and uYs(i). Try to figure it out to
    % improve calculation speed 
    XbyY{i} = Xs(Ys == uYs(i)); 
    XbyY{i} = Xs(IuYs == i); %??? doesn't save us much trouble
end

% ----- continue from here --------

[Cs, ICs] = sort(Y); % sorting variable C
Xs = X(ICs); % sorting variable X according to Cs

uX = unique(Xs); % get unique categories
uX_idx = false(length(X), length(Xs));
% doing it in a loop to save us memory and speed in very large arrays where
% bsxfun expansion is less than feasible. 
% <TODO> 
% maybe I can play around with bsxfun and determine when it's better to
% use a loop and make a small if stmt to choose the fastest method.
% </TODO>
for i = 1:length(Xs)
    uX_idx(:,i) = Xs == uX(i);
end

% get linear indices from the logicals found above & put them in a cell arr
uX_idx = arrayfun(@(i) find(uX_idx(:,i)), 1:length(Xs), 'UniformOutput', false);

% total number of members in each category
Nx = cellfun('prodofsize', uX_idx); % (should be row vector)












end

