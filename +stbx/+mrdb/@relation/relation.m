classdef relation
    %REL_MYRELDB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        relType % one2one or one2many % maybe will enumerate but maybe not
        tblPrime
        tblForeign
    end
    
    methods
        function obj = relation(rel_type, tbl_prime, tbl_foreign)
            % rel_type: relationship type: one2one or one2many
            % tbl_prime: the "one" side table
            % tbl_foreign: the "many" side table
            
            
        end
        
        
    end
    
end

