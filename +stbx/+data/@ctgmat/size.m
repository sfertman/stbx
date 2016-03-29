function varargout = size( x, varargin )
varargout = cell(1, max(1,nargout));
[varargout{:}] = size(x.num_mat, varargin{:});
end