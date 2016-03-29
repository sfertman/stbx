function [ N, I ] = knn( X, varargin )
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% KNN returns K of the nearest neighbours of each member in X. Copyright
% (C) 2016 Alexander Fertman.
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
% KNN K-nearest neighbours -- returns a number of nearest neighbours of
% each member in X as specified by K. If X is a multidimensional array, KNN
% works along the first non-singelton dimension. 
%
% N = KNN(X) -- finds 1 nearest neighbour for each element of X and returns
%   them in N.
% N = KNN(X,K) -- finds K nearest neigbours for each element of X and
%   returns them in N.
% [N, I] = KNN(X, ...) -- returns the neigbours in array N and linear
%   indexing locations of these neighbours within X in array I.
% KNN(X,K,'sorted') -- returns output in sorted order
% --- not yet implemented below this point ---
% KNN(X,K,SORTFLAG,DISTFUN) -- calculates the distances to find nearest
%   elements using finction DISTFUN. DISTFUN must return a single scalar
%   value for each pair of elements it accepts. If X is multidimensional,
%   DISTFUN behaviour must be consistent with builtin functions such as:
%   max, min, sum, etc., in terms of working dimension specification, and
%   defaul behaviour.
%
% See also:
%   max, sum

p = inputParser;
addOptional(p,'K', 1, @isnumeric);
addOptional(p,'isSortRequested', [], @(u) isempty(u) || ischar(u) && strcmpi(u,'sorted'));
% addOptional(p,'distfun', @(u) norm(u,2), @(u) isa(u, 'function_handle'))
parse(p,varargin{:});
K = p.Results.K;
if ~isempty(p.Results.isSortRequested)
    isSortRequested = true;
else
    isSortRequested = false;
end

% total number of members in X
[L,D] = size(X);

% we will work with sorted vectors and transform back to original order at
% the end
abs2X = sum(X.^2,2); % sqaure of amplitude of X
[~, iX]  = sort(abs2X); % Xs = X(iX) transforms to sorted order
Xs = X(iX,:);
% [Xs, iX]  = sort(X); % Xs = X(iX) transforms to sorted order
% that ^ was for the easy 1-d case

% get distances between adjacent members
dist_x = sqrt(sum(diff(Xs,[],1).^2,2)); % n-d Euclidean distance 
% dist_x = abs(diff(Xs)); 
% that ^ was for the easy 1-d case

% all positions of K neighbours of each x immediately to the left and right
dist_idx = bsxfun(@plus, (1:L).', repmat(-K:K-1, [L ,1])); 
set2inf_beg = zeros(K,2*K); set2inf_beg(dist_idx(    1:K, :) <= 0) = inf;
set2inf_end = zeros(K,2*K); set2inf_end(dist_idx(L-K+1:L, :) >= L) = inf;
dist_idx = max(dist_idx, 1); % make sure the minimum index is 1
dist_idx = min(dist_idx, L-1);  % make sure the maximum index is N-1

dist_x = dist_x(dist_idx);

% take care of the edges
dist_x(    1:K, :) = dist_x(    1:K, :) + set2inf_beg;
dist_x(L-K+1:L, :) = dist_x(L-K+1:L, :) + set2inf_end;

% get cummulative distance from center
dist_x(:,  K:-1:1) = cumsum(dist_x(:,  K:-1:1), 2); 
dist_x(:, K+1:2*K) = cumsum(dist_x(:, K+1:2*K), 2); 

[~,iDs] = sort(dist_x,2); % sort the distances from smallest to largest

X_idx = dist_idx;
X_idx(:,K+1:2*K) = X_idx(:,K+1:2*K) + 1;

% retrieve the closest K neighbours
I = zeros(L,K);
N = zeros(L,D,K);
for i = 1:K
    I(:, i) = X_idx( sub2ind([L,2*K], (1:L).', iDs(:,i)) );
    N(:,:,i) = Xs(I(:,i),:);
end

if ~isSortRequested
    [~, iXs] = sort(iX); % X = Xs(iXs) transforms back to the original order
    N = N(iXs, :, :);
    if nargout == 2 
        % make sure I is in original order also
        I = I(iXs, :);
    end
end

N = squeeze(N);

end

