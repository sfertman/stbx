classdef column < handle % cuz lots of data is going to be inside each
%//TODO 
% (*) make an abstract class name column or mrdbcol that will have the
%     following class methods
%     (+) object construct 
%     (+) subsref of some type for addressing
%     (+) subsasgn of some type for assignment
%     (+) vertcat 
%     (+) horzcat, need support for columns that are of array or list types
%         (not between column horzcat--this will be dealt with within a
%         table class)
%     (+) sorting
%     

    properties (SetAccess = protected)
        colName % name
        colType % data type
        colData % the actual data
    end

    properties (Access = public, Constant = true)
        %%% common errors to let the users know they did something they
        %%% were not allowed to do, may be encountered in the class once or
        %%% twice
        err_unsupprtedColType = struct('identifier', {'stbx:mrdb:column:err001'}, 'message', {'Input type must be either ''stbx.mrdb.col_type'' or empty, cannot continue.'})
        err_datatypeMismatch =  struct('identifier', {'stbx:mrdb:column:err002'}, 'message', {'Input data type does not match input column type, cannot continue.'})
    end
    
    methods
        % list of methods:
        % column - constructor
        % subset - returns subset of clumn array
        % assign - assigns input to subset of column
        
        function obj = column(name_, type_, data_)
            %%% REWRITE THIS TO MAKE SURE WHAT IT SAYS AND HOW IT WORKDS
            %%% ARE THE SAME. 
            %%% MAKE THIS THING WORK AS AN ARRAY OF OBJECTS AS WELL
            %%% figure out all the possibilities for processing input
            %%% according to type_. this will not be done in table class
            % ---------------------------------------------------------------------
            % *** The following must be implemented in stbx.mrdb.column class ***
            % ---------------------------------------------------------------------
            % col_data: the columns we want to add to our table
            % this could consist of many different data types, some of
            % which will result insertion with particular behavior(s).
            % addcol works with the following input types:
            % (*) object array of stbx.mrdb.column - inserted as is
            % (-) cell arrays of
            %     + stbx.mrdb.column   - as is
            %     - numeric vectors    - as stbx.mrdb.COL_TYPE.NUM
            %     - cellstr            - as strings or categorical as
            %                            designated in col_types
            %     - mixed vector types - as numeric and str/ctg respectively
            %     - mixed type vectors - as GEN
            % (-) numeric matrix / cell matrix - columns taken as numeric 
            %                                    stbx.mrdb.column objects
            % (-) mixed cell matrix 
            % or anything mixed
            % of cellstr
            
            if nargin == 0
                obj.colName = 'col_1';
                obj.colType = stbx.mrdb.COL_TYPE.GEN;
                obj.colData = [];
                return
            end
            
            obj.colName = name_;
            
            if isempty(type_)
                obj.colType = stbx.mrdb.COL_TYPE.GEN;
            elseif isa(type_, 'stbx.mrdb.col_type')
                obj.colType = type_;
            else
                error(stbx.mrdb.column.err_unsupprtedColType);
            end
            
            %%% dealing with different ways data could be input according
            %%% to the specified column type - you should break it down in
            %%% the help file for this method (see stbx.mrdb.table.addcol)
            switch type_
                case stbx.mrdb.COL_TYPE.GEN
                    % will basically store anything and everything as an
                    % unparsed strings - same as for type STR but for any
                    % object that cannot be assumed to be a string
                    % 
                    % 
                    % ********** NON CRITICAL ********** 
                    % 
                    % 
                    %
                    error(stbx.mrdb.globalconst.err_underConstruction);
                case stbx.mrdb.COL_TYPE.CTG % nominal/categorical critical
                    assert(iscolumn(data_), stbx.mrdb.column.err_datatypeMismatch); % make sure it actually is a column
                    
                    % allowed inputs:
                    % (+) cellstr - alphanumeric anything
                    % (+) char - number of rows will be num of records, converted to cellsrt 
                    % (+) numeric - will be converted into cellstr 
                    % (+) cell of strings and numbers - converted to cellstr 
                    if ischar(data_) 
                        data_ = cellstr(data_); % easily convertible to cellstr
                    elseif isnumeric(data_)
                        data_ = num2cell(data_, 2);
                    elseif iscell(data_) 
                        if ~iscellstr(data_) % if cellstr already, will convert to ctgmat at the bottom
                            try % attempt to convert to cellstr using char defined for what ever it is the user is trying to sell as a category
                                data_ = cellfun(@char, data_, 'UniformOutput', false); % will work for numerics and strings in same cell
                            catch e % if cannot do it rethrow whatever gone wrong
                                warning('Input data not convertible to char - maybe try other srorage methods....');
                                rethrow(e);
                            end      
                        end
                    else % is not char nor cell, throw type mismatch error
                        error(stbx.mrdb.column.err_datatypeMismatch);
                    end
                    
                    % if made it till here then we have a brand new shiny
                    % cellstr to convert to mapped indexed ctgmat
                    %
                    % CONVER THE DATA INTO stbx.ctgmat //TODO
                    % AND STORE IN obj.colData
                    %
                    
                case stbx.mrdb.COL_TYPE.NUM % critical
                    assert(iscolumn(data_), stbx.mrdb.column.err_datatypeMismatch);
                    if isnumeric(data_) % (+) numeric array
                        obj.colData = data_;
                    elseif iscell(data_) % (+) numeric cell array
                        assertfun = @(u) isnumeric(u) && isscalar(u);
                        assert(all(cellfun(assertfun && isscalar, data_)), stbx.mrdb.column.err_datatypeMismatch);
                        obj.colData = nan(size(data_));
                        obj.colData(~isempty(data_)) = [data_{~cellfun('isempty', data_)}];
                    else % not numeric vector or a numeric cell? - not supported
                        error(stbx.mrdb.column.err_datatypeMismatch);
                    end
                case stbx.mrdb.COL_TYPE.STR 
                    assert(iscolumn(data_), stbx.mrdb.column.err_datatypeMismatch); % mske sure it's a column
                    if ischar(data_) 
                        obj.colData = cellstr(data_); % easily convertible to cellstr
                    elseif iscell(data_) 
                        if iscellstr(data_) 
                            obj.colData = data_; % cellstr, stored as is
                        else % not cellstr
                            try % attempt to convert to cellstr using char
                                obj.colData = cellfun(@char, data_, 'UniformOutput', false);
                            catch e % if cannot do it  - throw the shit out of that error!!
                                warning('Input data not convertible to char - maybe try other srorage methods....');
                                rethrow(e);
                            end      
                        end
                    else % is not char nor cell, throw type mismatch error
                        error(stbx.mrdb.column.err_datatypeMismatch);
                    end
                %%% ------------- NON CRITICAL ----------------------------
                %%% vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
                case stbx.mrdb.COL_TYPE.DAT % (non critical - implement later)
                    % allowed inputs
                    % (*) Unix timestamp (int64) - stored as is.
                    % (*) Matlab datenum - stored as unix timestamp (int64)
                    error(stbx.mrdb.globalconst.err_underConstruction);
                case stbx.mrdb.COL_TYPE.ARR
                    error(stbx.mrdb.globalconst.err_underConstruction);
                case stbx.mrdb.COL_TYPE.LST
                    error(stbx.mrdb.globalconst.err_underConstruction);
                otherwise
                    error(stbx.mrdb.globalconst.err_superunknown);
            end
            
            obj.colData = data_; % would be inside the switch astmt above.
        end
        
        function subs = subset(this, varargin)
            % subs = subset(A, rows) gets subset of rows, returns a column
            %   object. If the object is an array of columns, returns a
            %   column array with the specified rows.
            % subs = subset(A, rows, cols) returns array of columns as
            %   above but only the specified columns. May be specified by
            %   logical array, numerical array, or by column name (string
            %   or cellstr).
        end
        
        function this = assign(this, verargin)
            % A = assign(A, rows, B) assigns whatever is in B to specified
            %   rows. If B is non-scalar, its size and dimensions must
            %   match the column object and input rows.
            % A = assign(A, rows, cols, B) assigs B to specified rows and
            %   cols. If B is non-scalar, its size and dimensions must
            %   match the column object and input rows and cols. cols input
            %   rules are the same as in subset, i.e. logical and numeric
            %   arrays are allowed, so are cellstr and single string.
            % If B is empty, i.e. satiffying isempty(B) == true then the
            %   corresponding rows/columns of the object will be deleted.
            %   In this case the size and dimensions of B must match the
            %   assignment references, otherwise 'Subscript assignment
            %   dimension mismatch' error will be thrown.
            
        end
        
    end
    
end

