classdef ctgmat < handle
    % CtgMat is categorical matrix very similar to Matlab's 'categorical' 
    % class but twice faster 
   
%     work in progress, also, uses moto_StrToNum - need to finish that
%     too.
    
    properties %(Access = private)
        % numerical matrix of category keys - the actual data
        num_mat@double 
        % map that maps category names (strings) to keys (numbers) and v.v.
        ctg_map@moto_StrToNum 
    end
    
    methods
        function obj = ctgmat(varargin)
            % ctgmat() - creates empty object
            % ctgmat(celstr) - creates ctgmat object automatically from cellstr
            % ctgmat(ctg_map, num_mat) creates ctgmat object with the
            % appropriate fields - doesn't seem like anyone would need that
            
            % create empty object
            obj.num_mat = double.empty;
            obj.ctg_map  = moto_StrToNum();
            switch nargin
                case 0
                    % empty object already creted - just return
                    return;
                case 1
                    assert(iscellstr(varargin{1}), 'input not cellstr');
                    % put strings in ctg_map 
                    [unqCtgs, ~, ic] = unique(varargin{1});
                    obj.ctg_map.addStrAuto(unqCtgs);
                    unqCodes = obj.ctg_map.getCodes(unqCtgs);
                    obj.num_mat = zeros(size(varargin{1}));
                    obj.num_mat(:) = unqCodes(ic);
                case 2
                    warning(stbx.commons.wrn.devsOnly);
                    % assert both inputs are of the same size
                    assert(all(size(varargin{1})==size(varargin{2})), 'Category names cell and numeric identifiers matrix must be of the same size.');
                    % assert correctness of map
                    % assert correctness of codes
                    [obj.num_mat, obj.ctg_map] = deal(varargin{:});
                otherwise
                    error('Wrong number of inputs');
            end
        end

        
        function this = setctg(this, varargin)
            % obj.setctg(new_ctg) - adds new ctg to the available categories 
            % obj.setctg(old_ctg, new_ctg) - replaces/renames old_ctg with new_ctg
            % obj.setctg(old_ctg, []) - deletes old_ctg and assigns NaNs within
            %   num_mat where any old_ctg exist.

            switch length(varargin)
                case 1 
                    this.ctg_map.addStrAuto(varargin{1});
                case 2 
                    if ~isempty(varargin{2})
                        this.ctg_map.modifyString(varargin{:});
                    else % new_ctg == []
                        codesForDeletion = this.ctg_map.getCodes(varargin{1});
                        this.ctg_map.deletePair(varargin{1}); % delete from map
                        for code_idx = 1:length(codesForDeletion) % loop may be faster than bsxfun or cellfun in this case
                            this.num_mat(this.num_mat == codesForDeletion(code_idx)) = NaN;
                        end
                        % this.num_mat(bsxfun(@eq, this.num_mat, codesForDeletion)) = NaN;
                    end
                otherwise 
                    error('wrong number of inputs');
            end
            
        end
    
        
        function disp(this)
            this.ctg_map.getStrings(this.num_mat)
        end
        
    end
    
    
    
%     methods (Static = true)
%         
%     end
    
end

