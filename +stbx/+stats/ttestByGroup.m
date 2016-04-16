function [ H, P, CI, STATS, B, C ] = ttestByGroup( X, G, varargin )
% TTESTBYGROUP Performs T-test (ttest2) between the groupes in X defined by
% G.

% <TODO> 
% add option to decide between paired and unpaired ttest (i.e. between
% ttest(...) and ttest2(...)
%</TODO>
[B, C] = stbx.data.group_by(X,G);

N = length(B); % number of groups
% [H,P,CI,STATS]
H = zeros(N);
P = ones(N);
CI = cell(N);
STATS(N,N) = struct('tstat',{[]},'df',{[]},'sd',{[]});
% the following(v) can be done more efficiently 
for i = 1:N
    for j = 1:N
        [H(i,j),P(i,j),CI{i,j},STATS(i,j)] = ttest2(B{i}, B{j}, varargin{:});
    end
end

% <TODO> 
% ideas for better efficiency. compute only the upper diagonal above and
% complete the result matrices as follows
% H = triu + triu.' - diag(diag(H));
% P = triu + triu.' - diag(diag(P));
% </TODO>

end

