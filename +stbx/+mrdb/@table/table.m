classdef table < handle

    properties (SetAccess = protected)
        data@column; % an array of tbl_col objects - must be an array, otherwise we have to track everything from this class and it's a drag 
        % // TODO make sure the columns can be accessed by name - map or something
    end
    
    properties (Access = public, Constant = true)
        %%% common errors to let the users know they did something they
        %%% were not allowed to do
%         err_colSizeMismatch = {[mfilename,':','001'], 'All columns must be of the same size.'};
        err_colSizeMismatch = struct('identifier', {'stbx:mrdb:table:err001'}, 'message', {'All columns must be of the same size.'})
%         err_colSizeMismatch.message = 'All columns must be of the same size.';

        %%% Freaky accidents of nature and logic 
        %%% (+ underconstruction notice)
        err_underConstruction = struct('identifier', {'stbx:mrdb:table:err999'}, 'message', {'This feature is not yet implemented.'})
        err_superunknown = struct('identifier', {'stbx:mrdb:table:err998'}, 'message', {'This should not be happening... Some debugging must be done.'})

        wrn_ignoreInputTypeOnColumnClassInput = struct('identifier', {'stbx:mrdb:table:wrn998'}, 'message', 'Data input as ''stbx.mrdb.column'' object array, input column names will be ignored...');     
    
    
    end
    
    methods
        function obj = table(varargin)
            if nargin == 0
                obj.data = [];
            end
            
            initErrs(obj);
            
        end
        
        
        
        function this = addcol(this, col_names, col_types, col_data)
% mrdb.table.addcol(col_names, col_types, col_data)
%   adds columns given by col_names, col_types and col_data to our table
% mrdb.table.addcol([], col_types, col_data)
%   if col_names not given generates column names automatically: 'col1',
%   'col2', ...
% mrdb.table.addcol(col_names, [], col_data)
%   if col_types not given stores data as stbx.mrdb.col_type.GEN
%
% All inputs must exist.
%
% Further explanation of input variable and behaviors
% ---------------------------------------------------
% col_names: names of column, the number of names given must be equal to
%   the number of columns given.
% col_type: emnumerated stbx.mrdb.col_type, 
% (*) if scalar, all columns are inserted using this type
% (*) if vector must be of equal length to the number of
%     columns
% ---------------------------------------------------------------------
% *** The following must be implemented in stbx.mrdb.column class ***
% ---------------------------------------------------------------------
% col_data: the columns we want to add to our table this could consist of
% many different data types, some of which will result insertion with
% particular behavior(s). addcol works with the following input types:
% (*) object array of stbx.mrdb.column - inserted as is
% (-) cell arrays of
%     + stbx.mrdb.column   - as is
%     - numeric vectors    - as stbx.mrdb.col_type.NUM
%     - cellstr            - as strings or categorical as
%                            designated in col_types
%     - mixed vector types - as numeric and str/ctg respectively
%     - mixed type vectors - as GEN
% (-) numeric matrix / cell matrix - columns taken as numeric 
%                                    stbx.mrdb.column objects
% (-) mixed cell matrix 
% or anything mixed
% of cellstr
            
            [~,nC] = size(col_data); % ~ - num of rows is not clear at this point, nC - num of cols
            
            %%% deal with column names
            wasEmptyColNames = false;
            if isempty(col_names)
                col_names = (cellstr('col_' + num2str((1:nC)')).\' ').';
                wasEmptyColNames = true;
            elseif ischar(col_names)
                col_names = {col_names};
            elseif iscellstr(col_names)
                assert(length(col_names) == length(col_data), 'Each input column must be assigned with a different name.');
            else % ~ischar, ~iscellstr
                error('Unsupported input type for column names.');
            end
            
            %%% deal with column types 
            wasEmptyColTypes = false;
            if isempty(col_types) % if empty, default to array of GENs
                col_types = repmat(stbx.mrdb.col_type.GEN, [1,nC]);
                wasEmptyColTypes = true;
            elseif isscalar(col_types) % if scalar, replicate to match num of cols
                assert(isa(col_types, 'stbx.mrdb.col_type'), 'Unknown column type.');
                col_types = repmat(col_types, [1,nC]);
            else % make sure input is col_type and of the right size
                assert(isa(col_types, 'stbx.mrdb.col_type'), 'Unknown column type.');
                assert(length(col_types) == nC, 'Number of column types given does not match the number of columns.');
            end
            
            %%% deal with column data
            if isa(col_data,'stbx.mrdb.column')
                if ~wasEmptyColNames
                    warning('Data input as ''stbx.mrdb.column'' object array, input column names will be ignored...'); 
                end
                if ~wasNotEmptyCoTypes
                    warning('Data input as ''stbx.mrdb.column'' object array, input column types will be ignored...'); 
                end
                this.data = [this.data, col_data]; % horzcat should work fine here
            elseif iscell(col_data)
                if isvector(col_data)
                    if all(cellfun(@(u) isa(u, 'stbx.mrdb.column'), col_data))
                        if ~wasEmptyColNames
                            warning(this.wrn_ignoreInputTypeOnColumnClassInput);
%                             warning('Data input as ''stbx.mrdb.column'' object array, input column names will be ignored...');
                        end
                        if ~wasNotEmptyCoTypes
                            warning(this.wrn_ignoreInputTypeOnColumnClassInput);
%                             warning('Data input as ''stbx.mrdb.column'' object array, input column types will be ignored...');
                        end
                        this.data = [this.data, col_data{:}]; % horzcat should work fine here
                        
                    elseif all(cellfun(@(u) isnumeric(u) && iscolumn(u), col_data)) % if numeric column
                        assert(all(length(col_data{1}) == cellfun(@length, col_data)), this.err_colSizeMismatch); %//TODO
                        
                    end
                end
            end
            
            n = length(this.data);
            
            % once everything is set up, we can just create a new set of 
            % stbx.mrdb.column objects and horzcat them to the existing 
            % table 
            column_cell = cellfun(@stbx.mrdb.column, col_names, col_types, col_data, 'UniformOutput', false);
            this.data = [this.data, column_cell{:}];
%             this.data(n+1) = 
        end
        
    end
    

    
end

function initErrs(this)
this.errs = struct();
this.errs.colSizeMismatch.identifier = [mfilename,':','colSizeMismatch'];
this.errs.colSizeMismatch.message = 'All columns must be of the same size.';
end

function errstr_ = errstr(err_)
errstr_ = sprintf( '%s\n %s', err_.identifier, err_.message);
end

