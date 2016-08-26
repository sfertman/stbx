function strout = pyjoin( delim, varargin )
% PYJOIN works as python join
narginchk(2, inf);
strout = cell(1,2*length(varargin)-1);
[strout{1:2:end}] = varargin{:};
[strout{2:2:end-1}] = deal(delim);
strout = [strout{:}];


end

