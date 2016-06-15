classdef COL_TYPE < double
% flat table possible data types
    enumeration
        %%% add new enumerations freely - things are fully automated
        GEN (0)     % general - no data type associated with it - stored as is in cell array (equivalent to OBJ basically)
        %%% prmitives
        CTG (1)     % categorical - stored in categorical array/matrix (builtin Matlab class starting R2014a) 
        ORD (2)     % ordinal - stored in some CtgMat subclass that establishes ranking relations between categories
        NUM (3)     % default numeric. stored as DOUBLE PRECISION float
        BIT (4)     % binary digit logical one or zero
        CHR (5)     % single character - stored as char array 
        R32 (6)     %(?) SINGLE PRECISION float (R for real)
        R64 (7)     %(?) DOUBLE PRECISION float (R for real)
        C32 (8)     %    single complex (takes up 64 bits of memory)
        C64 (9)     %    double complex (takes up 128 bits of memory)
        Z32 (10)     %(?) int32 (Z for positive/negative integers)
        Z64 (11)    %(?) int64 or 'long' (Z for positive/negative integers)
        N32 (12)    %    uint32 (N for Natural)
        N64 (13)    %    uint64 (N for Natural)
        
        % non-primitives (anything really)
        TXT (14)    % character string - stored as cellstr
        DAT (15)    % date time stored as int64 array (unix time stamp) same as 'long' but displayed as date.
        ARR (16)    % numeric array - STORED IN A DATA TYPE I HAVEN'T INVENTED YET - maybe a numeric matrix
        MAT (17)    % numeric matrix (2d) -- stored as 3d array where dims 1 and 2 represent the matrices, and dim 3 represents position in column
        LST (18)    % a list - STORED IN A DATA TYPE I HAVEN'T INVENTED YET - a cell of vectors maybe  
        STR (19)    % structure -- stored as structure array
        FUN (20)    % function_handle -- stored as cell array of function handles
        OBJ (21)    % any object of the same class -- stored as an object array

    end

%     methods (Static = true)
%         % Do not put the methods in this classdef file - not allowed for
%         % enumerations. Must be outside with the signatures listed here.
%         COL_TYPE.display(a); % displays '<TYPE> (<id>)', e.g. 'GEN (0)', works on matices too
%     end
    
end

