function [ Y ] = groupfun( X, G, F, varargin )
% GROUPFUN Groups data and applies functions to it. Most straighforward use
% would be to apply the same function on each section of grouped data,
% similarly to cellfun. GROUPFUN, however, will also be capable of the
% following:  
%   (-) appying binary functions pairwise between groups, 
%   (-) what else should it do?
% 

% simplest case: 
Y = cellfun(F, stbx.data.group_by(X,G));


end

