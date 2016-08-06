function mi = minfo( varargin )
% MINFO computes mutual information between 2 input data 
%
% Inputs supprted:
%   (-) MINFO(X,Y) where X and are continuous
%   (-) MINFO(A,B) where A and B are discrete / categorical / nominal
%   (-) MINFO(X,A) or MINFO(A,X) where X is continuous and A is discrete


% <TODO>
%   (-) this function figures out what to do, preprocesses the data and
%       routes it to the actual number-crunchers bellow
% </TODO>
end

function minfo_cc(x,y)
% cont-cont

end

function minfo_dd(a,b)
% disc-disc

end

function minfo_cd(x,a)
% cont-disc
% x must be cont, a must be disc
% use stbx.mlearn.mictg as a starting point

end