function c = plus(a,b)
% concatinates two string objects. see strcat for details on how it works
% //USES SashaToolBox\Cell\cellstrSpeedBoost.m

a = cellstr(a); % local version of cellstr -- see below
b = cellstr(b); % local version of cellstr -- see below

if length(a) == length(b) %%% can't boost anything here -- brute force
    c = char(strcat(a, b));
elseif length(a) == 1 && length(b) ~= 1     %%% boost b
    c = cellstrSpeedBoost(@(u) strcat(a, u), b);
elseif length(a) ~= 1 && length(b) == 1     %%% boost a
    c = cellstrSpeedBoost(@strcat, a, b);
end
c = char(c);
end


function c = cellstr(s)
% stolen from Mathworks by Alexander F. :) had to make it more nimble for
% @char/plus purposes
%
%CELLSTR Create cell array of strings from character array.
%   C = CELLSTR(S) places each row of the character array S into
%   separate cells of C.
%
%   Use CHAR to convert back.
%
%   Another way to create a cell array of strings is by using the curly
%   braces:
%      C = {'hello' 'yes' 'no' 'goodbye'};
%
%   See also STRINGS, CHAR, ISCELLSTR.

%   Copyright 1984-2013 The MathWorks, Inc.

numrows = size(s,1);
if numrows == 0
    c = {''};
elseif numrows == 1
    c = {s};
else
    % surprisingly, a for loop is the fastest way of doing this!
    c = cell(numrows,1);
    for i = 1:numrows
        c{i} = s(i,:);
    end
end
end
