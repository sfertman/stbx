function [ F,X ] = ecdfn( Y, C )
% ECDFN a clone of Matlab's builtin ecdf but with support for
% multidimensional variables.
% <TODO>
%   (-) make it work in the same way as the builtin
% </TODO>

%{-
% maybe I don't even need to sort it
[Ys, Is] = sortrows(Y, [1,2]); % sorting D ascending

if ~exist('C','var') || isempty(C)
    Cs = ones(size(Ys,1),1);
else
    Cs = C(Is); % sorting C according to Ds
end

X = Ys;
F = cumsum(Cs);
F = F/F(end);






%} 

% % indicator function
% IND_func = @(x,y) all(x(:) >= y(:));


end

