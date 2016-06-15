function dirs_ = getDirTree( varargin )
% GETDIRTREE returns the directory and subdirectory structure of a ginven
%   path.
%
% GETDIRTREE(PATH) -- (char) path to scan (defaults to current path)
% GETDIRTREE(..., PARAM1, VAL1, PARAM1, VAL1, ...)
%   '#relative' -- (logical) if true returns relative paths otherwise,
%       returns full path (defaults to false)
%   '#ignore' -- (char, cellstr) directory list to ignore (defaults to {})
%   '#strcut' -- (logical) if true returns dir tree in a structure
%   (defaults to false) 
% 
% Returns: 
%   paths of subdirectories
%

% <TODO> 
% scrape all parameters and values
% ignore list default has to be {'.', '..'} to get rid of some of 'dir'
%   function outputs
% </TODO>

[isRelative, ignores_, isStruct, varargin] = parseParamsPrefix( varargin, { ...
    {'#relative', @(u) islogical(u) && isscalar(u),  '''#relative'' parameter must be logical scalar.', false}, ...
    {'#ignore', @(u) (  ischar(u) || iscellstr(u)), 'Ignore list must be a single string or cellstr.', {}}, ...
    {'#struct', @(u) islogical(u) && isscalar(u),  '''#struct'' parameter must be logical scalar.', false},...
    });
    

ignores_ = [{'.', '..'}, ignores_];


if isempty(varargin)
    path_ = cd;
else
    path_ = varargin{1}; 
    % assert path_ is an actual path
end

dirs_ = getDirTreeRecursiveCell(path_, ignores_);

if isRelative
    dirs_ = dirs_.\(dirs_{1} + '\');
    dirs_{1} = '.';
end

if isStruct
    error(stbx.commons.err.underConstruction);
end

end

function dirs_ = getDirTreeRecursiveCell(dirs_, ignores_)
% get subdirectories of current directory
subdirs_ = getDirTreeSingleLevel(dirs_, ignores_);
% stopping condition
if isempty(subdirs_), return; end 
% append found subdirectories to current directory to get full path
subdirs_ = cellfun(@(s) strcat(dirs_, '\', s), subdirs_, 'UniformOutput', false);
% get subdirs of all subdirs (recursively)
subdirs_ = cellfun(@(s) getDirTreeRecursiveCell(s, ignores_), subdirs_, 'UniformOutput', false);
% concatinate current dir with all found subdirs
dirs_ = vertcat({dirs_}, subdirs_{:});
end

function dirs_ = getDirTreeSingleLevel(fullpath_, ignore_)
% get everything in directory
dirs_ = dir(fullpath_);
% keep sub-directories only
dirs_(~[dirs_.isdir]) = [];
% discard ignore list
dirs_(cellfun(@(d) any(strcmp(d, ignore_)), {dirs_.name})) = [];
% get dir names and put them in cell
dirs_ = {dirs_.name}.';
end


function dirs_ = getSubDirsRecursiveStruct(dirs_, ignore_)

end

