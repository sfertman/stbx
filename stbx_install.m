function stbx_install(varargin)
%error(stbx.commons.err.underConstruction)

ignoreDirs = {'fex','.git','Obsolete'};
dirsToAdd = stbx.disk.getDirTree('#relative', false, '#ignore', ignoreDirs);
addpath(dirsToAdd{:});
