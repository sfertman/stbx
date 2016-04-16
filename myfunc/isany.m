function tf = isany( OBJ, CLASSLIST )
% ISANY Determine if input is object's class matches any of the ones
% specified in a list of classes. This function just applies CELLFUN on top
% of ISA.
%
% ISANY(obj,CLASSLIST) returns true if OBJ is an instance of any of the
%   classes specified by CLASSLIST cellstr, and false otherwise. ISANY also
%   returns true if OBJ is an instance of a class that is derived from any
%   of the classes in CLASSLIST.
%
% See also: 
%   isa, cellfun

tf = any(cellfun(@(t) isa(OBJ,t), CLASSLIST));

end

