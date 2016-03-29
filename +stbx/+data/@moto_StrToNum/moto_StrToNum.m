classdef moto_StrToNum < stbx.moto
    
    properties (SetAccess = protected)
        map_str2num@containers.Map;
    end
    

    methods
        function this = moto_StrToNum(varargin)
            %%% //TODO: write a help file for this junk
            warning('TODO: finish all the methods in this class');
            this.map_str2num = containers.Map('KeyType','char','ValueType','double');
            if nargin == 0
                return;
            elseif nargin == 1 % auto mode, default method
                this.addStrAuto(varargin{1});
            elseif nargin == 2
                if ischar(varargin{2}) % might still be auto but incl method (count/rand/...)
                    warning('there''s no check of correct mode - ''auto'' here');
                    this.addStrAuto(varargin{:});
                else % assumed paired insertion
                    this.addPaired(varargin{:});
                end
            else
                error('worng number of inptus');
            end
        end
        
        function yesno = isempty(this)
            % returns truw if object is empty --> if the map is empty
            yesno = this.map_str2num.isempty;
        end
        
        function yesno = isCode(this, code_list)
            % checkes if input codes are in map - looks not so good - rewrite
%             m_codes = cell2mat(this.map_str2num.values);
%             yesno = sum(bsxfun(@eq, code_list(:), m_codes), 2, 'native');
            yesno = cellfun(@(u) any(u == code_list), this.map_str2num.values);
        end
        
        function yesno = isString(this, string_list)
            yesno = this.map_str2num.isKey(string_list);
        end
            
        
        function req_strings = getStrings(this, req_codes)
            if ~exist('req_codes','var') || isempty(req_codes) || (ischar(req_codes) && strcmp(req_codes, ':'))
                req_strings = this.map_str2num.keys; % get all strings from map
            else
                
                inverseMap = containers.Map(this.map_str2num.values, this.map_str2num.keys); % create inverse map from nums to strings
                req_strings = inverseMap.values(num2cell(req_codes)); % get strings (values) by nums (keys)
                % this function may run faster with loops
                %             [req_codes_, ~, idxCodes_] = unique(req_codes(:));
                %             m_codes = cell2mat(this.map_str2num.values);
                %             m_codes_ind = (1:this.map_str2num.Count).';
                %             req_codes_logical_ = sum(bsxfun(@eq, req_codes_, m_codes), 2, 'native');
                %             req_codes_ind_ = m_codes_ind(req_codes_logical_);
                %             req_codes_ind = req_codes_ind_(idxCodes_);
                %             m_strings = this.map_str2num.keys;
                %             req_strings = m_strings(req_codes_ind);
            end
        end
        
        function req_codes = getCodes(this, req_strings)
            if ~exist('req_strings','var') || isempty(req_strings) || (ischar(req_strings) && strcmp(req_strings,':'))
                req_codes = cell2mat(this.map_str2num.values);
            else
                req_codes = cell2mat(this.map_str2num.values(req_strings));
%                 [unqStrigns, ~, ic] = unique(req_strings);
%                 unqCodes = cell2mat(this.map_str2num.values(unqStrigns));
%                 req_codes = unqCodes(ic);
            end
        end
        
        function this = setPair(this, varargin)
            narginchk(2,3); % including 'this'
            switch nargin
                case 2
                    this.addStrAuto(varargin{1});
                case 3
                    if ischar(varargin{2}) % might still be auto but incl method (count/rand/etc.)
                        this.addStrAuto(varargin{:});
                    else % assumed paired insertion
                        this.addPaired(varargin{:});
                    end
            end
           
            
        end
        
        function this = addStrAuto(this, new_strings, method)
            % new_strings: set of strings to be inserted into our map
            % method: coding method specifies how numbers are matched to
            %   input  strings. possible values for 'method' input
            %   parameter 
            %       'count': add codes in ascending order (starting at 1) 
            %       'rand': get random codes for each new string

            warning('finish this');
            % help section
            if ~exist('method','var') || isempty(method) 
                method = 'count'; 
            end
            if ischar(new_strings), new_strings = {new_strings}; end 
            new_strings = unique(new_strings); % take strings without repetitions
            
            % make sure input types are correct
            assert(iscellstr(new_strings),'Input strings must be ''cellstr'' or ''char'' type.');

            % get existing strings and codes
            m_strings = this.getStrings(':');
            
            % make sure all strigns and codes don't eist in the current map
            assert(~any(cellfun(@(u) any(strcmp(u, m_strings)), new_strings)), 'Input strigns must be all new. Use ''modifyString'' to modify one or more strings in map.');
            
            
            switch method
                case 'count'
                    new_codes_temp = 1:length(new_strings); % initial guess
                    if ~isempty(this.map_str2num)
                        % get existing codes (needed for further operation)
                        m_codes = this.getCodes(':');
                        new_codes = zeros(size(new_codes_temp)); % final result container
                        new_codes_idx = 1;
                        while ~isempty(new_codes_temp)
                            if any(new_codes_temp(1) == m_codes) % exists in current map
                                new_codes_temp = new_codes_temp + 1; % advance the count
                            else % doesn't exist
                                new_codes(new_codes_idx) = new_codes_temp(1); % add current code to new_codes list
                                new_codes_idx = new_codes_idx + 1; % advance new_codes_idx
                                new_codes_temp = new_codes_temp(2:end); % remove current code from temp list
                            end
                        end
                    else
                        new_codes = new_codes_temp;
                    end
                case 'rand'
                    % get random codes for each new string
                    new_codes = rand(length(new_strings),1);
                    if ~isempty(this.map_str2num)
                        % get existing codes (needed for further operation)
                        m_codes = this.getCodes(':');
                        % on the odd chace that we got duplicate values
                        isExistCodes = sum(bsxfun(@eq, new_codes(:), m_codes), 2, 'native');
                        while any(isExistCodes)
                            new_codes(isExistCodes) = rand(sum(isExistCodes), 1);
                            isExistCodes = sum(bsxfun(@eq, new_codes(:), m_codes), 2, 'native');
                        end
                    end
                otherwise
                    error('Unknown coding method. Type ''help moto_StrToNum/addStrAuto'' for more info.')
            end
            
            % update the existing map to include the new strings and codes
            this.map_str2num = [this.map_str2num; containers.Map(new_strings, new_codes)];
            
        end
        
        function this = addPaired(this, new_strings, new_codes)
            warning('not tested');
            if ischar(new_strings), new_strings = {new_strings}; end 
            
            % make sure input types are correct
            assert(iscellstr(new_strings),'1st input must be ''cellstr'' or ''char'' types');
            assert(isnumeric(new_codes), 'codes must be ''numeric'' type');

            % make sure inputs match on length
            assert(length(new_strings) == length(new_codes),'Number of strings and codes must be identical.');
           
            % make sure inputs are unique
            assert(length(new_strings) == length(unique(new_strings)), 'Input strings must be unique.')
            assert(length(new_codes) == length(unique(new_codes)), 'Input codes must be unique.')
            
            if ~isempty(this.map_str2num)
                % get existing strings and codes
                m_strings = this.getStrings(':');
                m_codes = this.getCodes(':');

                % make sure all strigns and codes don't exist in the current map
                assert(~any(cellfun(@(u) any(strcmp(u, m_strings)), new_strings)), 'Input strigns must be all new. Use ''modifyString'' to modify one or more strings in map.');
                assert(~any(sum(bsxfun(@eq, new_codes(:), m_codes),2,'native')), 'Input codes must ne all new. Use ''modifyCode'' to modify one or more codes in map.')
            end
            % update the existing map to include new values (using vertcat for container.Map class)
            this.map_str2num = [this.map_str2num; containers.Map(new_strings, new_codes)];
            
        end
        
        function this = deletePair(this, arg1)
            % Deletes an indexed string pair. This can be done by
            % specifying either a string or an index.
            %
            %   obj.deletePair([idx1, idx2, ...]) -- finds pairs by index
            %       and removes them from map
            %
            %   obj.deletePair(str) -- find the string specified by str and
            %       removes it from map
            %   obj.deletePair({str1, str2, ...}) -- finds pairs specified
            %       by each string in input cellstr and removes them from
            %       map.
            %
            
            if isnumeric(arg1)
                % delete by code identifier
                % deletion_codes = arg1;
                m_strings = this.getStrings;
                m_codes = this.getCodes;
                deletion_idx = sum(bsxfun(@eq, m_codes(:), arg1(:)' ), 2, 'native');
                this.map_str2num = this.map_str2num.remove(m_strings(deletion_idx));
                
            elseif iscellstr(arg1) || ischar(arg1)
                % delete by string identifier
                this.map_str2num = this.map_str2num.remove(arg1);
            end
        end
        
        function this = modifyCode(this, arg1, new_codes)
            % //TODO: should be done in 'setPair' function. arg1 may be
            % cellstr of string values to input new codes, or a vector of
            % old codes to replace
        end
        
        function this = modifyString(this, arg1, new_strings)
            % //TODO: should be done in 'setPair' function. arg1 may be
            % cellstr of old strings to rename or a vector of codes to
            % indicate those strings
        end
        
%         function this = setPair(this, 
        
        function disp(this)
            % //TODO: can be redesigned to display mapped pairs as 
            %   'num1 <--> string1'
            %   'num2 <--> string2'
            %   ...
            m_strings = this.getStrings;
            m_codes = this.getCodes;
            fprintf('\t%s with strings and codes:\n\n',mfilename);
            disp([num2cell(m_codes(:)), m_strings(:)])
        end

        
    end
end