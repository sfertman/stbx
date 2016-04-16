classdef col_NUM < stbx.mrdb.column2
    %COL_NUM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
        type@stbx.mrdb.COL_TYPE
    end
    
    methods
        function obj = col_NUM(varargin)
            obj = obj@stbx.mrdb.column2(varargin{:});
        end
    end
    methods (Static = true)
        function [d,t] = parseData(data,type)
%             stbx.mrdb.COL_TYPE.(type);
            [sr, sc] = size(data);
%             assert(isscalar(type) || 
            [d,t] = deal({data},type);
        end
    end
    
    
end

