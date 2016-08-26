function [N,C] = ecdfnhist( F, X, B )
% ECDFNHIST is just like builtin ecdfhist but for multidimesional data
% 
% F and X are stbx.stats ecdfn outputs
% B is for "bins" and assumed input are bin centers for now. Number of
% centers (i.e. scalar input) is not supprted. Goodies may be added in
% later time. Have to work quickly now...

% compute bin edges from centers
x_edg = [-inf, 0.5*(B(1:end-1) + B(2:end)), inf].';





end

