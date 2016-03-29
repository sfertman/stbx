function subs_explicit = subs_runlenDecode(start_idx, len)
% creates subscript indices vector from run length encoded format.
% Meaning, given a set of starting indices and length, the function
% generates an explicit vector of indices. WARNING: in case len is greater
% than the differences between start_idx subsequent members -- expect the
% unexpected
%
% Example:
%   start_idx = [1, 5, 10];
%   len = 3;
%   % returns
%   subs_explicit = [1,2,3,5,6,7,10,11,12]
% 

if isempty(start_idx)
    subs_explicit = [];
    return
end
    
if iscell(start_idx)
    start_idx = start_idx(:);
    notEmpty_start_idx = ~cellfun('isempty', start_idx);
    
    % in case all start indices vectors in cell are empty, we don't want to
    % waste time
    if ~any(notEmpty_start_idx)
        subs_explicit = start_idx;
        return
    end
    
    len = len(:);
    
    if ~isscalar(len)
        if length(start_idx) ~= length(len)
            error('cell inputs must be of the same length');
        end
        if ~iscell(len) 
            len = num2cell(len); 
        end
        subs_explicit_ = cellfun(@(u,v) bsxfun(@plus, u(:)', (0:v-1)'), start_idx(notEmpty_start_idx), len(notEmpty_start_idx), 'UniformOutput', false);

    else % len is scalar
        if iscell(len), len = len{1}; end % in case we are missing a scalar cell
        subs_explicit_ = cellfun(@(u) bsxfun(@plus, u(:)', (0:len-1)'), start_idx(notEmpty_start_idx), 'UniformOutput', false);
    end
    subs_explicit(notEmpty_start_idx) = subs_explicit_;
    S = struct('type','()','subs',{{':'}});
    subs_explicit = cellfun(@(u) subsref(u, S), subs_explicit, 'UniformOutput', false);
else % if start_idx is not a cell then things are simple
    subs_explicit = bsxfun(@plus,start_idx(:)',(0:len-1)');
    subs_explicit = subs_explicit(:)';
end
