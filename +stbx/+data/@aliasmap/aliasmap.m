classdef aliasmap < handle
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% ALIASMAP improves on Matlab's builtin containers.Map by adding a
% feature that allows for referring to the same data by a number of
% different keys. Copyright (C) 2016 Alexander Fertman.
%     
%     This file is part of STBX package.
%
%     STBX package is distributed in the hope that it will be useful and
%     it is absolutely free. You can do whatever you want with it as long
%     as it complies with GPLv3 license conditions. Read it in full at: 
%     <http://www.gnu.org/licenses/gpl-3.0.txt>. Needless to say that
%     this program comes WITHOUT ANY WARRANTY for ANYTHING WHATSOEVER. 
%   
%     On a personal note, if you do end up using any of my code, consider
%     sending me a note. I would like to hear about the cool new things my
%     code helped to make and get some inspiration for my future projects
%     too.
%     
%     Cheers.
%     -- Alexander F.
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    % Rules of the game in order for this thing to work properly
    % (*) A key cannot be an empty object (or primitive)
    % (*) An alias cannot be an empty object (or primitive)
    % (*) Two different keys cannot have any identical aliases
    % (*) A key cannot have the same name as an alias of another key
    % <TODO>
    %   (*) add additional referencing methods such as, 
    %       (-) case insensitive
    %       (-) ignore non letter symbols
    %       (-) ... think of additional methods...
    %       (-) maybe even user defined methods, hmmm
    %
    
    properties (Access = public)
        refMethod
    end
    properties (SetAccess = private)
        mainmap % holds key-value pairs 
        keyaliasmap % holds alias-key pairs 
    end
    
    methods
        function obj = aliasmap(varargin)
            % <TODO> 
            % (*) constructor might be too simple. can add option to
            %     create aliasmap object by providing k-v-a triplets in
            %     cell arrays and what not (not a major inconvenience for
            %     now though)
            % </TODO>
            obj.mainmap = containers.Map(varargin{:});
            obj.keyaliasmap = containers.Map('KeyType', obj.mainmap.KeyType, 'ValueType', obj.mainmap.KeyType);
            obj.refMethod = 'default';
        end
        
        function this = alias(this, K, A, tf_skipSanity)
            % alias(K, A) -- K must be a cell array of keys of type
            %   aliasmap.mainmap.KeyType; A must be a cell array which 
            %   contains numel(K) cell arrays of aliases for each key given
            %   in K.
            % alias(..., tf_skipSanity) -- optional input. If tf_skipSanity
            %   is 'true' then all assertions are skipped (this is mainly
            %   made for internal use). If tf_skipSanity is 'false' then
            %   the input is asserted for correctness. If tf_skipSanity is
            %   not given or isempty(tf_skipSanity) == true then the
            %   variable defaults to false.
            
            % <TODO> 
            % (*) make sure to cover all duplicate keys and aliases
            %     cases as stated in "Rules of the game" above 
            % </TODO>
            
            if ~exist('tf_skipSanity', 'var') || isempty(tf_skipSanity)
                tf_skipSanity = false;
            end
            
            % perfoming sanity checks
            if ~tf_skipSanity
                % make sure mapKeys and keyAliases are cells of equal zise
                assert( iscell(K) && iscell(A) && ...
                        all(size(K) == size(A)), ...
                        'Keys and aliases must be given in cell arrays of equal size.');
            end
            
            for i = 1:length(K)
                % <TODO> Test this -- seems to work for now </TODO>
                if ~tf_skipSanity
                    if isempty(A{i})
                        warning('Ignoring keys with empty aliases.');
                        continue;
                    else % weed out the empties in each a{i}
                        empty_ai = cellfun('isempty', A{i});
                        if any(empty_ai), warning('ignoring empty aliases.'); end
                        A{i} = A{i}(~empty_ai);
                      
                    end
                end
                % insert alias-key pairs into aliasmap.keyaliasmap
                this.keyaliasmap = vertcat( this.keyaliasmap, ...
                    containers.Map( A{i}, repmat(K(i), [1, length(A{i})]) ) );
            end
        end
        
        function this = setValue(this, k, v, a)
            % <TODO> 
            %   (*) make sure to cover all duplicate keys and aliases
            %       cases as stated in "Rules of the game" above 
            % </TODO>
            % 
            % k - key
            % v - value
            % a - alias/aka
            % setValue(k, v, a) -- single key-value-alias triplet
            % setValue(k, v, A) -- single k-v pair and multiple aliases
            %   given in cell array A
            % setValue(K, V, A) -- multiple k-v-a triplaets given in cell
            %   arrays of matching sizes; V{i} are values of K{i}; A{i}{:}
            %   are aliases of K{i}
            
            if ~exist('a', 'var'), a = {}; end
            
            if strcmpi(class(k), this.mainmap.KeyType)
                this.mainmap(k) = v; % insert key-value pair
                if ~isempty(a) && isa(a, this.mainmap.KeyType)
                    this.alias({k}, {{a}}, true); % alias the key with single alias
                elseif iscell(a)
                    assert(all(cellfun('isclass', a, this.mainmap.KeyType)), 'All aliases must the same type as mainmap.KeyType.');
                    % weed out empty aliases from 'a'
                    a = a(~cellfun('isempty', a)); 
                    if ~isempty(a)
                        this.alias({k}, {a}, true); % alias k with multiple aliases
                    else 
                        return;
                    end
                else
                    error(stbx.commons.err.superunknown);
                end
                    
            elseif iscell(k) % setValue(K, V, A)
                % make sure all members of input cell are of type: KeyType
                assert(all(cellfun('isclass', k, this.mainmap.KeyType)), 'Some input keys are not consistent with this map''s KeyType. Cannot continue.');
                % make sure v is a cell array matching in size to size(k)
                assert(iscell(v) && all(size(k) == size(v)), 'When inserting multiple pairs, both keys and values must be given in cell arrays of matching size.');
                % insert all k-v pairs
                this.mainmap = vertcat(this.mainmap, containers.Map(k,v));
                % deal with aliases if applicable
                if ~isempty(a) 
                    % make sure a is a cell
                    assert(iscell(a), 'When inserting multiple pairs, aliases must be given in cell array.');
                    % make sure a matches k size
                    assert(all(size(k) == size(a)), 'When inserting multiple pairs, number of alias lists must match the number of given keys.');
                    % make sure all members of 'a are cell arrays of
                    % mainmap.KeyTyep
                    assert(all(cellfun(@(a_) all(iscell(a_)) && all(cellfun('isclass', a_, this.mainmap.KeyType)), a)), 'All members of alias cell array must be cell arrays of mainmap.KeyType.');
                    % first, check which members of a are empty and weed
                    % them out fomr 'a' and 'k'.
                    empty_a = cellfun('isempty', a);
                    a = a(~empty_a); k = k(~empty_a);
                    % then, check which members of non-empty member of 'a'
                    % are empty and weed them out out of 'a' only
                    a = cellfun(@(a_) a_(~cellfun('isempty', a_)), a, 'UniformOutput', false);
                    % alias all keys in 'k' with the aliases in 'a'
                    this.alias(k, a, true);
                end % else, do nothing
            end
        end
        
        function v = getValue(this, k)
            % getValue returns the value associated with a key. The key may
            % be an actuall key in this.mainmap or and alias.
            %
            % k input key
            % v output value 
            if ~iscell(k), k = {k}; end
            v = cell(size(k)); % preallocate output value array
            
            isKeyInMainMap = this.mainmap.isKey(k);
            isKeyInAliasMap = this.keyaliasmap.isKey(k(~isKeyInMainMap));
            assert(all(isKeyInAliasMap), 'Some input keys do not exist in maps. Cannot continue.')
            v(isKeyInMainMap) = cellfun(@(k_)this.mainmap(k_), k(isKeyInMainMap), 'UniformOutput', false);
            mainKeysByAlias = cellfun(@(k_)this.keyaliasmap(k_), k(~isKeyInMainMap), 'UniformOutput', false);
            v(~isKeyInMainMap) = cellfun(@(k_)this.mainmap(k_), mainKeysByAlias, 'UniformOutput', false);
        end
        
        function k = getRealKey(this, a)
            % input: array of aliases or real keys
            % output: array of the corresponding real keys
            % if key doesn't exist will return empty-value of type KeyType
            % (returns empty cell for now)
%             error('doesn''t work -- figure it out tomorrow!');
            if ~iscell(a), a = {a}; end
            
            k = cell(size(a));
            isKeyInMainMap = this.mainmap.isKey(a);
            isKeyInAliasMap = this.keyaliasmap.isKey(a(~isKeyInMainMap));
            
            % if key in main then already a real key
            k(isKeyInMainMap) = a(isKeyInMainMap);
            
            notKeyInMainMapID = find(~isKeyInMainMap);
            k(notKeyInMainMapID(isKeyInAliasMap)) = this.keyaliasmap.values(a(notKeyInMainMapID(isKeyInAliasMap)));
        end        
        
        function r = absenceReport(this, k)
            % returns which keys from 'k' are key in mainmap, which
            % are in keyaliasmap and which are not in any map.
            % The output is a four column cell containing the following
            % columns:
            % <key> <exists anywhere?> <exists as key?> <exists as alias?>
            
            isKeyInMainMap = this.mainmap.isKey(k);
            isKeyInAliasMap = this.keyaliasmap.isKey(k);
            r = [k,num2cell(isKeyInMainMap | isKeyInAliasMap), num2cell([isKeyInMainMap,isKeyInAliasMap])];
        end
        

        
    end
    
end

