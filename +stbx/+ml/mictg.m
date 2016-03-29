function [ output_args ] = mictg( X, Y )
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
% MICTG(X,Y)
% X can be any numeric
% Y can be: 
%   categorical
%   cellstr
%   integer
%   


% <TODO> 

% detailed help file to characterize all aspects of this function that need
% to be written
% </TODO>

% assuming:
% C is categorical and X is numeric continuous / descrete or ordinal 
% X and C are column vectors 
% X and C do not have NaNs inside

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

