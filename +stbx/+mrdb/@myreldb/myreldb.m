classdef myreldb < handle
    %MYRELDB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        tbls; % array of tbl objects (tables)
        rels; % array of relations structures (2 fields: tblPrimary, tblForeign)
        
    end
    properties (Access = public, Constant = true)
        
    end
    methods
        function obj = myreldb(varargin) % construct DB
            if nargin == 0
                obj.tbls = {};
                obj.rels = struct('tblPrimary',{}, 'tblForeign',{});
            end
        end
        % function tbl_add
        % function tbl_del - resolve relations between remaining tables
        % function rel_add - resolve which table get which keys
        % function rel_del - resolve the records when relations disappear
        % function rec_add - add record(s)
        % function rec_del - delete record(s)
        
        % function flatten - convers the entire DB into one table 
        % function export - export any table into a delimited text file
        
        function this = addRelations(this, tbl_primary, tbl_foreign)
            %%% assert correctness of input and all that stuff
            
            % * if either input is scalar and the other one is vector,
            % multiple relations are set for the scalar table
            % * if both are vectors, must be of equal size and relations 
            % will be set respectively
            n = length(this.rels);
            this.rels(n+1).tblPrimary = tbl_primary;
            this.rels(n+1).tblForeign = tbl_foreign;
            
            %%% find a way for updating tables
        end
        

    end
    
end



