classdef (Abstract) moto < handle
    % MOTO means Map One To One. This class is a wrapper around
    % containers.Map and uses it to store key-value pairs. It allows
    % subclasses to implement reverse lookup using the abstract method
    % 'findKeys' below. The resulting class allows for injective mapping
    % back and forth between keys and values. However, containers.Map is
    % inherently one sided; so, developer should choose key->value mapping
    % according to the data and optimize the implementation of 'findKeys'
    % method for the *values* stored in the containers.
    
    % //TODO: Make sure to throw errors when the values added are not
    % unique and/or already exist in the map. One-to-one mapping cannot
    % exist if map is not injective.
    % 
    % 
    %
    
    
    properties (SetAccess = protected, Abstract = true)
        mapOneWay@containers.Map;
    end
    
    
    methods
        
        function map = getMap(this)
            % Matlab won't let me create a get.mapOneWay method because the
            % property is abstract so we're going to do it like so:
            map = this.mapOneWay;
        end
        
        function this = setPair(this, varargin)
%             actually might not be necessary at all - just let
%             containers.Map default behavious take over. This can be
%             achieved using vertcat where new values are added to an
%             existing map by concatinating a a newly generated map
%             containing these key-value pairs to an existing one (this).
%             It is more consistent with Matlab this way.

            % obj.setPair(key, val) -- adds the key 'key' and values 'val'
            %   pair to the map. Existing keys and values are overwritten.
            % obj.setPair([k1, k2, ...], [v1, v2, ...])
            %  - or -
            % obj.setPair({k1, k2, ...}, {v1, v2, ...})
            %   adds pairs k1,v1 k2,v2 ... to the map. The input arrays
            %   must be of the equal size and of the same type (cells or
            %   numerical arrays). If the inputs are of different types,
            %   the first one determines the behavior of the function.
            %   Example: the inputs {'a','b','c'} and [1,2,3] will yield a
            %   map with three keys: 'a', 'b' and 'c' which all have the
            %   same value [1,2,3]. Inputs {'a','b','c'} and {1,2,3} will
            %   yield a map with the above keys but with three different
            %   values: 1, 2 and 3 respectively.
            
            
        end
        
        function tf = isKey(this, keys)
            % Wrapper for containers.Map 'isKey' method. This function is
            % literally a one liner: tf = this.mapOneWay.isKey(keys); so
            % you don't have to type: myMotoSubclass.mapOneWay.isKey(keys).
            % Plus, the property is protected anyway.
            % SEE ALSO:
            %   containers.Map
            tf = this.mapOneWay.isKey(keys);
        end
        
        function tf = isValue(this, varargin)
            % returns true for every input argument that is value in this
            % map and false otherwise. Assuming that findKeys is 
            % implemented to this abstract class' specification! 
            tf = ~isnan(this.findKeys(varargin{:})); % keys in same order as values.
        end
        
        function keys_ = keys(this, varargin)
            % no inputs or ':', returns all keys in map
            % obj.keys(values) -- reurns keys corresponding to the input 
            % values and in the same order including duplicates (if any are
            % input)
            
            if isempty(varargin)|| (length(varargin) == 1 && ischar(varargin{1}) && strcmp(varargin{1}, ':'))
                % then we return all keys
                keys_ = this.mapOneWay.keys;
                return;
            else
                keys_ = this.findKeys(varargin{:});
            end
        end
        
        function vals = values(this, keys)
            % If no inputs, returns all tha values in map
            % obj.values(keys) -- returns all the values corresponding
            
            if ~exist('keys','var') || (ischar(keys) && strcmp(keys, ':'))
                vals = this.mapOneWay.values;
                return;
            else
                vals = this.mapOneWay.values(keys);
            end
                
            
        end
        
        function this = remove(this, varargin)
            % Removes keys and values from the map.
            %   obj.remove(keys, vals)
            %   - or -
            %   obj.remove(keys,  {})
            %   - or -
            %   obj.remove({}  , vals)   <-- uses findKeys
            % will remove the key-value pair 'key'-'val' from the map. The
            % search can be done from either way but must be specified by
            % the position of the input. If 'vals' or 'keys' are cell
            % arrays than each element in it will be used as a reference to
            % a pair to delete.
            
            assert(length(varargin) == 2, 'Wrong number of inputs.');
            assert(all(cellfun(@iscell, varargin)), 'keys and values must be input in cells.' );
            
            %%% remove input keys.
            this.mapOneWay.remove(keys);
            
            %%% remove input vals
            keys_ = this.findKeys(vals); % find the keys corresponding with the input values
            this.mapOneWay.remove(keys_); % remove the found keys from the map
        end
    end
    
    methods (Abstract = true)
        % 'findKeys' has to implement inverse lookup of keys for a set of
        % input values. Accepts list of values (in what ever way
        % implemented by subclass) and returns a list of keys in
        % correspondance with the input values. If no key is found then the
        % method must return NaN.
        keys = findKeys(this, varargin); 
    end
    
    methods (Abstract = true, Static = true)
        % this method must return a newly constructed object of the
        % subclass. Basically, just a wrapper around the constructor of
        % your subclass the - so we can use it here for various awesome
        % things. Example: for implementation of this method in a static
        % method block of a subclass 'myClass' of 'moto':
        %   function obj = getNew(varargin)
        %       obj = myClass(varargin{:});
        %   end
        obj = getNew(varargin);        
    end
    
    methods (Static = true)
        function [varargout] = size( a )
            [varargout{1:nargout}] = size(a.mapOneWay);
        end
        function l = length(a)
            l = length(a.mapOneWay);
        end
        function tf = isempty(this)
            % returns true if object is empty --> if the map is empty
            tf = this.map_str2num.isempty;
        end
        
        function c = vertcat(varargin)
            % USES: cellunwrap, cellunique (see end of this file)
            % This function uses probably the least efficient method for
            % finding unique values. Developer is strongly encouraged to
            % override vertcat in subclasses.
            
            % assert that all inputs are moto objects
            assert(all(cellfun(@isa, varargin, 'stbx.moto')), 'Inputs must all be stbx.moto subclasses.')
            % ^ I use @isa instead of 'isclass' because isclass returns
            % false if subclass is given. 
            
            % get the map property from each input object
            allMaps = cellfun(@(u) u.getMap, varargin, 'UniformOutput', false);
            
            % make sure the values taken together from all maps are unique 
            allVals = cellunwrap(cellfun(@(u) u.values, allMaps, 'UniformOutput', false));
            assert(length(allVals) == length(cellunique(allVals)), 'Values must be unique.'); 
            % ^ The above supports any type of object but it might make the method slow. 
            
            % get the subclass name:
            subclassName = class(varargin{1});
            
            % output a new moto subclass object with a new map that
            % includes all input maps together. Do not have a better way of
            % doing this other than feval at the moment
            c = feval([subclassName,'.getNew'], vertcat(allMaps{:}));
            
            function C = cellunique( A )
                % overload of cellunique to get only the unique values without indices
                % this assumes that there are no NaNs in A!
                C = {};
                while length(A) > 1
                    C = [C, A{1}]; %#ok
                    l = cellfun(@(u) isequal(u, A{1}), A);
                    A = A(~l); % reduce A in size so the next iterations go quicker
                end
                
                % if anything left in A slap it to the end of C
                if length(A) == 1, C = [C, A]; end
                % otherwise nothing is left and we do nothing
            end
        end
        
        function argsout = horzcat(varargin) %#ok
            error('Horizontal concatenation is not supported for ''moto'' class.');
        end
    end
    
end





