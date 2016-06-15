classdef column < handle
    %COLUMN Summary of this class goes here
    %   Detailed explanation goes here

    properties
        type
        data
    end
    
    methods
        function obj = column(varargin)
% COLUMN class constructor.
% COLUMN() -- creates an empty column object
% COLUMN(DATA) -- creates a column out of the input DATA with type ANY
% COLUMN(DATA,TYPE) -- creates a column out of the input DATA with type
%   according to the input TYPE
    
            % function begins
            narginchk(0,2);
            if nargin == 0
                % COLUMN()
                obj.type = stbx.data.col.COLTYPE.ANY;
                obj.data = [];
            elseif nargin == 1
                obj = populate(obj, varargin{:}, stbx.data.col.COLTYPE.ANY);
            elseif nargin == 2
                obj = populate(obj, varargin{:});
            end
            
        end
 
        function that = getcopy(this)
            % construct empty object
            that = stbx.data.col.column(); 
            % copy everything into it
            [r,c] = size(this);
            that(r,c).data = this(r,c).data;
            that(r,c).type = this(r,c).type;
            if r*c > 1
                [that(1:end-1).data] = deal(this(1:end-1).data);
                [that(1:end-1).type] = deal(this(1:end-1).type);
            end
        end
        
        function that = getrecords(this, varargin)
% GETRECORDS returns a subset of a column object specified by *numeric*
%   indices in 'rows' and 'cols'
% Supported inputs: 
%   (+) GETRECORDS() -- returns a copy of the current object
%   (+) GETRECORDS(r) -- returns record numer r from each column in object
%       using linear indexing
%   (+) GETRECORDS([r1,r2,...]) -- returns records r1,r2,... from all
%       columns in object (dimension must match)
%   (+) GETRECORDS(r1,r2,...) -- returns r1 from col1, r2 from col2 and so
%       on. Number of inputs must match number of columns in object array.
%   (+) GETRECORDS(s1,s2,...) -- returns records s1 from col1, records s2
%       from col2 and so on using linear or logical indexing. Where
%       s1,s2,... are numerical or logical arrays that reference records in
%       each column in object array. As always, dimensions must match.
%   (+) GETRECORDS({s1},{s2},...) -- returns record s1{:} from col1, record
%       s2{:} from col2 and so on using n-d numeric indexing. Where
%       s1,s2,... are numerical arrays that reference records in each
%       column in object array. s_i cannot be logical. Returns single
%       record per column. As always, dimensions must match.
%   (-) GETRECORDS({s11,s12,...},{s21,s22,...},...) -- 
%
% Examples:
%   % record 5 from all cols
%   getrecords(5)
%   % record [5,2,3] from all cols
%   getrecords([5,2,3]) 
%   % 5 from col 1, 2 from col 2, 3 from col 3
%   getrecords(5,2,3) 
%   % recs 1,2 and 3 from col1, rec 4 from col2, rec [0,0,1,0] (or 3) from col3
%   getrecords([1,2,3], 4, [0,0,1,0]) 
%   % record [1,2,3] from col 1, rec 4 from col 2, rec [1,2,3,4] from col 3
%   getrecords({1,2,3}, {4}, {1,2,3,4})
%   % recs [1,2] and [3,4] from col1, recs [5,6,7] and [8] from col2, ...
%   getrecords({{1,2},{3,4}},{{5,6,7},{8}},...)


            % modifier biolerplate
            if nargout == 0
                that = this;
            else
                that = this.getcopy();
            end
            
            % if no inputs then nothing to do
            if isempty(varargin) == 0, return; end;
             
            new_data = {that.data};
            if all(cellfun(@(u) isnumeric(u) || islogical(u), varargin))
                if length(varargin) == 1
                    %   (+) GETRECORDS(r)
                    %   (+) GETRECORDS([r1,r2,...])
                    new_data = cellfun(@(u) u(varargin{1}), new_data, 'UniformOutput', false);
                else
                    %   (+) GETRECORDS(r1,r2,...)                    
                    %   (+) GETRECORDS(s1,s2,...)
                    new_data = cellfun(@(u,r) u(r), new_data, varargin, 'UniformOutput', false);
               end
            elseif all(cellfun(@iscell, varargin))
                %   (+) GETRECORDS({s1},{s2},...)
                %   (-) GETRECORDS({s11,s12,...},{s21,s22,...},...)
                assert(~any(cellfun('islogical', [varargin{:}])), ...
                    'n-d *numeric* reference cannot be logical.');
                new_data = cellfun(@(u,r) u(r{:}), new_data, varargin, 'UniformOutput', false);
            else
                error('Unsupported input.')
            end
            
            [that.data] = deal(new_data{:});
            
        end
            
        
        function this = populate(this, data, type)
            data_cell = arrayfun(@(d,t) parsedata(d{:}, t), data, type, ...
                'UniformOutput', false);
            
            % combine all cols into single cell array
            data_cell = [data_cell{:}];
            
            % get dimensions of column array to be created
            [r,c] = size(data_cell);
            
            % pre-allocate by end-assignment
            % <TODO> preallocation takes the most time. Try to find a
            % way to make it work faster </TODO>
            this(r,c).data = data_cell{r,c};
            
            % populate the aray (if applicable)
            if r*c > 1
                [this(1:end-1).data] = deal(data_cell{1:end-1});
            end
            
            % assign types ('type' is actuall array, not cell. Loop may be
            % faster than converting to cell and then using cellfun. In any
            % case, type array will not be large enough to make any
            % significant difference because it can only be the length of
            % the number of columns in array which is relatively small
            % comapred with the amount of data they contain.) 
            for i = 1:length(type)
                this(i).type = type(i);
            end
        end
       
        
        function catCols
%%% CATCOLS concatinte all coulmns            
        end
        
        function that = castas(this, varargin)
% CASTAS casts select columns in this array to specified type
% Supported inputs:
%   (-) CASTAS(type)
%   (-) CASTAS([t1,t2,...])
%   (-) CASTAS([c1,c2,...],[t1,t2,...]) or CASTAS(c1,t1, c2,t2, ...)

            % modifier boilerplate
            if nargout == 0
                that = this;
            else 
                that = this.getcopy();
            end
            
            if length(varargin) == 1
                if length(varargin{1}) == 1
                    % cast all data in this object to type varargin{1}
                    % idea for converting: 
                    %   perform col2cell
                    %   perform cell2col witht the appropriate type
                    
                elseif length(varargin{1}) == numel(that);
                    % cast every column in this object to the corresponding
                    % type ti
                else
                    error('Number of elements in type array does not match the number of elements in this object.')
                end
            elseif length(varargin) == 2
                assert(numel(varargin{1}) == numel(varargin{2}),...
                    'Number of elements in columns and types must match.');
            else
                error('Wrong number of inputs.')
            end
        end
        
        function sz = getColSize(this, dim)
% Returns the size of the column
            if ~exist('dim', 'var')
                sz = arrayfun(@(u) size(u.data), this, 'UniformOutput',false);
            else
                sz = arrayfun(@(u) size(u.data, dim), this);
            end
        end
        
        function l = getColLength(this)
            l = arrayfun(@(u)length(u.data), this);
        end
        
        function tf = isempty(this)
            tf = all(arrayfun(@(u) isempty(u.data), this));
        end

    

    end
    methods (Static = true)
 
               
        
    end
      
    
end

function data_out = parsedata(data, type)
% Routing data to parsing function according to its type
switch type
    case stbx.data.col.COLTYPE.ANY
        data_out = parsedata_any(data);
    case stbx.data.col.COLTYPE.NUM
        data_out = parsedata_num(data);
    case stbx.data.col.COLTYPE.TXT
        data_out = parsedata_txt(data);
    otherwise
        warning('Unknown data type, parsing as ''ANY''.');
        data_out = parsedata_any(data);
end

end



function data_cell = parsedata_any( data )
%PARSEDATA_NUM 
if ~exist('data', 'var') || isempty(data), data_cell = {[]}; return; end

if ~iscell(data), data = {data}; end
% reshaping input data into a matrix where each column is the nd-th column
% in the input.
nd = ndims(data); % get number of dimensions in data
if nd > 2
    data = reshape(permute(data, [nd, 1:nd-1]), size(data, nd), []);
end
data_cell = num2cell(data,1);

end

function data_cell = parsedata_num( data )
%PARSEDATA_NUM

% If data is a matrix, its columns are taken as input columns for the
% object (this also applies to row and column vectors). If data is an n-d
% array then the last dimension of 'data' is assumed to contain the
% columnar data. All dims but the very last will be flattened into a 1D
% array.
    

if ~exist('data', 'var') || isempty(data), data_cell = {[]}; return; end

if isnumeric(data)
    
    % reshaping input data into a matrix where each column is the nd-th
    % column in the input.
    nd = ndims(data); % get number of dimensions in data
    if nd > 2
        data = reshape(permute(data, [nd, 1:nd-1]), size(data, nd), []);
    end
    data_cell = num2cell(data,1);
elseif iscell(data)
    assert(all(cellfun(@(u) isnumeric(u) && iscolumn(u), data)), ...
        'All members of input cell must be numerical columns.');
    data_cell = data(:).';
else
    error('Unknown input.' );
end

end

function data_cell = parsedata_txt( data )
%PARSEDATA_TXT 
% Supported inputs:
% (+) cellstr matrix (up to 2-d)
% (+) cellstr n-d array
% (+) char matrix (up to 2-d)
% (+) char n-d array

if ~exist('data', 'var') || isempty(data), data_cell = {''}; return; end

assert(iscellstr(data) || ischar(data),...
    'Only cellstr and char array inputs are supported.')

nd = ndims(data); % get number of dimensions in data
if nd > 2
    data = reshape(permute(data, [nd, 1:nd-1]), size(data, nd), []);
end
data_cell = num2cell(data,1);

if ischar(data)
    data_cell = cellfun(@cellstr, data_cell, 'UniformOutput', false);
end

end