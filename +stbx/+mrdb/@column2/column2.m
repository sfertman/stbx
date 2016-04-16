classdef (Abstract) column2 < handle 
% Abstract column class
% <TODO> 
% I should take care of column array creation here.
%   - this could be usefull when creating a table, there could be cols of
%   essentially different types in the same array... If Matlab ca pull this
%   off, this should be a good this to have since it will simpify table
%   creation.
%</TODO>
 
    properties (Abstract = true)
        data
        type@stbx.mrdb.COL_TYPE
        
    end

	methods 
		%
		function obj = column2(data, type)	
            % initilizing column object 
            obj.data = 0;
            obj.type = stbx.mrdb.COL_TYPE.GEN;
            
            % dealing w/ empty inputs
            if nargin == 0
                return; 
            end
            
            [data, type] = obj.parseData(data, type); % abstract function that must be implemented in each column subclass
            
            % making sure parsed data fits together in a sensible way
            assert(all(size(data) == size(type)) || isscalar(type), 'The second output of ''parseData'' function must be either a scalar or equal in size to the first output.');

            % preallocating memory for object array
            [m,n] = size(data);
            [obj(m,n).data, obj(m,n).type] = deal(0, obj.type); 
            
            % populating the fields in object array
            if isscalar(type)
                for i = 1:numel(obj) 
                    obj(i).data = data{i};
                    obj(i).type = type;
                end
            else
                for i = 1:numel(obj) 
                    obj(i).data = data{i};
                    obj(i).type = type(i);
                end
            end                
		end
	
	end
    methods (Abstract = true, Static = true)
% PARSEDATA formattes input data according to it type, returns all the data
% structures in a cell array d, where each element represents one
% data-column and numeric array t, where each element represents the data
% type for the corresponding column in d. If t is scalar, the same data
% type is assumed for all members of d.
        [d,t] = parseData(data, type)
% % %         
% % % % element-wise arithmetics
% % %         c = plus(a,b)
% % %         c = minus(a,b)
% % %         c = times(a,b)
% % %         c = rdivide(a,b)
% % %         c = ldivide(a,b)
% % %         
% % % % "matrix"-wise arithmetics
% % %         c = mtimes(a,b)
% % %         c = mrdivide(a,b)
% % %         c = mldivide(a,b)
% % %         
% % % % concatination - this should be made to concatinate single columns
% % % % (usually of the same type), not column object arrays
% % %         c = cat(a,b)
% % %         c = horzcat(a,b)
% % %         c = vertcat(a,b)
% % %             
% % % 		

    
    
    end
end 