function idx = max_idx( varargin )
% returns only the second argument of Matlabs max functions. Sometimes this
% is usefull in anonymous functions where we cannot access anything but the
% firt output argument. Thus this workaround.

warning('obsolete, use nthvarout instead');
[~, idx] = max(varargin{:});

end

