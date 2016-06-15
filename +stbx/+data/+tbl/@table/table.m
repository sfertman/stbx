classdef table
% TABLE is essentially a 1-d stbx.data.col.column array where the number of
%   rows in each column if forced to be the same and table oriented
%   operations are implemented.
%
%   In all class methods that modify the content of an object, can be used
%   in two ways:
%       tbl.<method> -- will modify 'tbl' object 
%       tbl2 = tbl1.<method> -- will modify a copy of 'tbl1' and return it
%           in 'tbl2' with 'tbl1' unchanged. 

    properties 
        colarray 
        colnames
        rownames
        queryHist
        userdata
        
    end
    
    methods
        function obj = table(varargin)
% TABLE
% Supported inputs
%   (-) TABLE() creates an empty table object
%   (-) TABLE(filepath) where filePath is a file to be read and converted
%       to TABLE object
%   (-) TABLE(fid) where fid is a valid file id generated with fopen
%   (-) TABLE(DATA)
%   (-) TABLE(DATA,TYPE)
%   (+) TABLE(COLUMNS) -- where COLUMNS is stbx.data.col.column object
%
% Parameter / value inputs:
%   (-) '#colnames', {'c1', 'c2',...} -- assigns names 'c1,'c2',... to
%       table columns (if not provided then the naming defaults to 'col1',
%       'col2' and so on...
%   (-) '#rownames', {'r1','r2',...} -- assigns names 'r1','r2',... to
%       table rows (if not provided then no names are given and rows cannot
%       be referrenced by name.
%   (-)



            obj.colarray = stbx.data.col.column();
            obj.colnames = containers.Map('KeyType', 'char', 'ValueType', 'double');
            obj.rownames = containers.Map('KeyType', 'char', 'ValueType', 'double');
            obj.queryHist = struct(); %struct('subset', {}, 'subset_rec', {}, 'group', {}, 'group_rec', {}, 'group_ctg', {});
            obj.userdata = [];
            
            if nargin == 0, return, end;
            
            [colnames_in, rownames_in, varargin] = parseparams(varargin, {...
                {'#colnames', @iscellstr, '''#colnames'' parameter must be a cellstr.' , {}}, ...
                {'#rownames', @iscellstr, '''#rownames'' parameter must be a cellstr.' , {}}, ...
            });
            

        
        
            if length(varargin) == 1
                if isa(varargin{1}, 'stbx.data.col.column')
                    assert(length(unique(varargin{1}.getColLength())) == 1, ...
                        'All columns must have the same length.');
                    obj.colarray = varargin{1}.getcopy();
                else
                    error(stbx.commons.err.underConstruction)
                end
            else
                error(stbx.commons.err.underConstruction);
            end
            
            % '#colnames'
            if ~isempty(colnames_in)
                assert(length(colnames_in) == length(obj.colarray), ...
                    'Number of column names must match the number of columns in table.');
            else % assign names as 'col1', 'col2', ...   
                colnames_in = cellstr('col' + num2str((1:length(obj.colarray)).')).\' ';
            end
            obj.colnames = containers.Map(colnames_in, 1:length(colnames_in));
            
            % '#rownames'
            if ~isempty(rownames_in)
                assert(length(rownames_in) == obj(1).getColLength, ...
                    'Number of row names must match the number of rows in table.');
                obj.rownames = containers.Map(rownames_in, 1:length(rownames_in));
            end
                
        end

        
        function cols = getcol(this, varargin)
% GETCOL retrieves specified columns in a table
% Supported inputs (and any mix of them):
%   (+) GETCOL(c1,c2,...) or GETCOL([c1,c2,...]) returns columns numbered
%       c1,c2,...
%   (+) GETCOL('col1','col2',...) or GETCOL({'col1','col2',...}) returns
%       columns named 'col1','col2',...
%   (+) GETCOL('#match', regexp, ...) returns all columns with names
%       *matching* the regular expression regexp (char) in addition to
%       other columns specified by name or number.

            assert(all(cellfun(@(u) ischar(u) || iscellstr(u) || isnumeric(u), varargin)), 'Column can be referenced by name, number or regular expressions only.')
            % scrape numeric indices from varargin
            [colindex, varargin] = stbx.data.split( varargin, cellfun(@isnumeric, varargin) );
            colindex = [colindex{:}]; 
            % translate all other references to numerics and merge w/ prev
            colindex = [colindex, this.getcolidx(varargin{:})];
            % return the referenced columns as a new table object in the
            % same order as they appear in this one
            cols = this.getsubtable([], sort(colindex));
        end
        
        function this = setcol(this, varargin)
% SETCOL adds or modifies columns in table. If specified cols exist then
%   modifies, otherwise adds new.
% Supported inputs:
%   (-) SETCOL(c1,v1, c2,v2, ...) set v1 to column number c1, v2 to column
%       number c2 and so on...
%   (-) SETCOL('col1',v1, 'col2',v2, ...) set v1 to column named 'col1', v2
%       to column named 'col2' and so on...
%   (-) SETCOL([c1,c2,...],{v1,v2,...}) sets v1 to column number c1, v2 to
%       column number c2 and so on...
%   (-) SETCOL({'col1','col2',...}, {v1,v2,...}) sets v1 to column named
%       'col1', v2 to column named 'col2' and so on...
%   (-) SETCOL(..., '#match', 'regexp', {v1,v2,...}) sets values v1,v2,...
%       to columns found by matching regular expression 'regexp'. The
%       number of input values must match to the number of coulmns found
%       matching the pattern.


% rewrite the stuff below to take '#match' tag into account
            assert( rem( length(varargin), 2) == 0, ...
                'Inputs must be name-value pairs.');
            if length(varargin) < 2
                error('At least one name-value pair is required.');
            elseif length(varargin) == 2
                [cols, vals] = deal(varargin{:});
                if isnumeric(cols) 
                    % (-) setcol(c1,v1)
                    % (-) setcol([...], {...})
                elseif ischar(cols)
                    % (-) setcol('col1', v1)
                elseif iscell(cols)
                    % (-) setcol({...}, {...})
                end
            else % length(varargin) > 2
                assert(rem(length(varargin),2) == 0, ...
                    'Each column must have a corresponding value.');
                cols = varargin(1:2:end-1);
                if all(cellfun(@isnumeric, cols))
                    % (-) SETCOL(c1,v1, c2,v2, ...)
                elseif iscellstr(cols)
                    % (-) SETCOL('col1',v1, 'col2',v2, ...)
                    
                else
                    error('Columns may be referenced by name or index only.');
                end
                vals = varargin(2:2:end);

            end
        
        
        end
        
        function this = addcol(this, varargin)
% ADDCOL ads a column to the table.
% Supported inputs:
%   (-) ADDCOL(col1, col2, ...)
%       where col1, col2, ... are
%       (-) any set of workspace variables (added as COLTYPE.ANY)
%       (-) stbx.data.col.column variables (checked for size and added)
%   (-) ADDCOL(data, type) 
%       (-) col is a cell array of anything and type is scalar COLTYPE:
%           parsed as the specified type and added (depending on type may
%           result in multiple columns added)
%       (-) if type is COLTYPE array, dimensions must match to the number
%           of elements in data
%   (-) ADDCOL(data, type, colname)
%       (-) colname specifies the names of the columns to be added. Must
%           match in length to type. If any single type generates multiple
%           columns, the corresponding colname is replicated and an index
%           is added at the end.
%       (-) If colname is a single char (or scalar cellstr), it is
%           replicated to match the final column count and an index is
%           added at the end of it.


            
        end
        
        function that = delcol(this, varargin)
% DELCOL deletes column by name or index
%
% Supported inputs (and any mix of them):
%   (+) DELCOL(c1,c2,...) or DELCOL([c1,c2,...]) deletes columns numbered
%       c1,c2,...
%   (+) DELCOL('col1','col2',...) or DELCOL({'col1','col2',...}) deletes
%       columns named 'col1','col2',...
%   (+) DELCOL('#match', regexp) deletes all columns with names *matching*
%       the regular expression regexp (char)
% 
% See also
%   regexp

            assert(all(cellfun(@(u) ischar(u) || iscellstr(u) || isnumeric(u), varargin)), 'Column can be referenced by name, number or regular expressions only.')
            
            if nargout == 0
                that = this;
            else
                that = this.getcopy();
            end
            
            % scrape numeric indices from varargin
            [colindex, varargin] = split( varargin,cellfun(@isnumeric, varargin) );
            % translate all other references to numerics and merge w/ prev
            colindex = [colindex, that.getcolidx(varargin{:})];
            % delete the referenced columns
            that(colindex) = [];
        end
        
        function that = setcolname(this, varargin)
% SETCOLNAME can be used to set column names within table
% Supported inputs:
%   (-) SETCOLNAME(c, 'name') -- set column number c name to 'name'
%   (-) SETCOLNAME('oldname', 'newname') -- set column named 'olname' to
%       'newname';
%   (-) SETCOLNAME([c1,c2,...], {'name1','name2',...}) -- set names  
%       'name1','name2',... to multiple columns specified by numeric
%       references c1,c2,...
%   (-) SETCOLNAME({'old1','old2',...},{'new1','new2',...}) -- set names
%       'new1','new2',... to columns specified by current names
%       'old1','old2',...
%   (-) SETCOLNAME('#match', regexp, {'new1', 'new2', ...}) -- set names 
%       'new1','new2',... to column whose names match the regular
%       expression string <regexp>. The number of matches must be equal to
%       the number of input names.
%   (-) SETCOLNAME('#match', regexp, name) -- sets names based on a single 
%       input string <name> by adding a numerical index postfix for every 
%       new column name found to match regular expression <regexp>.
% 

            if nargout == 0
                that = this;
            else
                that = this.getcopy();
            end
            
            
            

        end
        
        function colidx = getcolidx(this, varargin)
% GETCOLIDX returns the numeric position of columns specified by name.
% Supported inputs:
%   (+) GETCOLIDX('col1','col2',...)
%   (+) GETCOLIDX({'col1','col2',...})
%   (-) GETCOLIDX(..., '#match', regexp, ...)

            [regexpMatchStr, varargin] = parseparams(varargin, {...
                {'#match', @ischar, '''#match'' parameter must be a regular expression (char) to look for matches within existing column names.' , ''}, ...
            });
            

            colidx = [];
            % extract '#match' here 
            if ~isempty(regexpMatchStr)
                
                % matches... = this.colnames(regexp-matched names)
                colidx = [colidx, matches];
            end
            
            %%% rewrite the rest
            
            if iscellstr(varargin) 
                colidx = cell2mat(this.colnames.values(varargin));
            elseif iscellstr(varargin{:})
                colidx = cell2mat(this.colnames.values(varargin{:}));
            else
                error('Unsupported input.')
            end
        end
        
        function colname = getcolname(this, varargin)
% GETCOLNAME returns the names of the columns specified by numeric indices.
% Supported inputs:
%   (-) GETCOLNAME() -- returns all column names in the order they appear
%       in the table.
%   (-) GETCOLNAME(c1,c2,...) or GETCOLNAME([c1,c2,...) --- returns the
%       column names specified by indices c1,c2,...
% < This is not top priority since the lookup will usually in name->number
%   direction. Would be nice to have though. >

        
        end
        
        
        function that = getcopy(this)
% GETCOPY returns a copy by value of the table object 
            that = stbx.data.tbl.table();
            props = properties(this);
            for i = 1:length(props)
                that.(props{i}) = this.(props{i});
            end
        end
        
        function this = castcolsas(this, varargin)
% CASTCOLSAS casts table columns to specified types
% Supported inputs:

        end
        
        function row = getrow(this, varargin)
            
        end
        
        function this = setrow(this, varargin)
            
        end       
        
        function this = addrow(this, varargin)
            
        end
        
        function this = delrow(this, varargin)
            
        end
        
        function this = setrowname(this, varargin)
        end
        
        function rowidx = getrowidx(this, varargin)
        end
        
        function that = subset(this, varargin)
        end
        
        function that = getsubtable(this, rows, cols)
% GETSUBTABLE returns part of table specified by row and col *numbers* only
%
% Supported inputs:
%   (+) GETSUBTABLE() or GETSUBTABLE([],[]) returns a copy of the table
%   (+) GETSUBTABLE(rows) or GETSUBTABLE(rows, []) GETSUBTABLE(rows, ':')
%       or returns only specified rows in all columns
%   (+) GETSUBTABLE([], cols) or GETSUBTABLE(':', cols) returns specified
%       columns (all rows)
%   (+) GETSUBTABLE(rows, cols) returns subset of table specified by rows &
%       cols
%   (+) [] are interchangeable with ':'

            % modifier biolerplate
            if nargout == 0 
                that = this;
            else
                that = this.getcopy();
            end
            
            % if only 'this' input, nothing to do
            if nargin == 1, return; end

            if isempty(rows) || strcmpi(rows, ':')
                isAllRows = true; 
            else
                isAllRows = false; 
            end
            
            if ~exist('cols', 'var') || isempty(cols) || strcmpi(cols, ':')
                isAllCols = true; 
            else
                isAllCols = false; 
            end
            
            if ~isAllCols && ~isAllRows
                that.colarray = that.colarray(cols).getrecords(rows);
            elseif ~isAllCols && isAllRows
                that.colarray = that.colarray(cols);
            elseif isAllCols && ~isAllRows
                that.colarray = that.colarray.getrecords(rows);
            end  % elseif isAllCols && isAllRows, do nothing, end
                
        end
        
        function [ varargout ] = colfun(this, varargin)
        end
        
        function [ varargout ] = rowfun(this, varargin)
        end
        
        function [ varargout ] = datafun(this, varargin)
        end
        
        
    end
    
   
end

function [varargout] = parseparams(varsin, paramToParse)

% paramToParse is a cell of 4 element cells:
%   paramToParse{i}{1} is parameter's name
%   paramToParse{i}{2} is parameter's assertion function
%   paramToParse{i}{3} is assertion error message (defaults msg: 'Parameter
%       does not qualify assertion rules.')
%   paramToParse{i}{4} is parameter's default value
% 
% if any element is set to {}, it is considered empty and will result in
% default assignment/behavior.
% //TODO add some examples for future reference

if nargin == 0 
    dbs = dbstack;
    help(dbs(end).name);
    return
end

varargout = cell(1, length(paramToParse) + 1); % 1 slot for each parameter and 1 for everything else
varsOutIdx = 1;
for i = 1:length(paramToParse) 
    % //TODO: shouldn't be the following???
    % pIdx = find(ischar(varsin) & strcmp(varsin, paramToParse{i}{1})); % find parameter name in list    
    % ^ ischar is unnecessary here since strcmp will return false if a
    %   string is compared with anything that is not a string or cellstr
    pIdx = find(strcmp(varsin, paramToParse{i}{1})); % find parameter name in list
    if ~isempty(pIdx)
        varargout{varsOutIdx} = varsin{pIdx + 1}; % the next input after the parameter tag
        if ~isempty(paramToParse{i}{2})
            if ~isempty(paramToParse{i}{3})
                assert(paramToParse{i}{2}(varargout{varsOutIdx}), paramToParse{i}{3});
            else % no assert error message was input
                assert(paramToParse{i}{2}(varargout{varsOutIdx}), 'Parameter does not qualify assertion rules.');
            end
        end
        varsin = varsin([1:pIdx-1, pIdx+2:end]); % +2 because it's property name and value
    elseif ~isempty(paramToParse{i}{4})
        varargout{varsOutIdx} = paramToParse{i}{4};
    else
        varargout{varsOutIdx} = {};
    end
    varsOutIdx = varsOutIdx + 1;
end

varargout{end} = varsin;
end


