classdef COL_TYPE < double
% flat table possible data types
    enumeration
        %%% add new enumerations freely - things are fully automated
        GEN (0)     % general - no data type associated with it - stored as is in cell array (equivalent to OBJ basically)
        NOM (1)     % nominal - stored in categorical array/matrix (builtin Matlab class starting R2014a) 
        ORD (2)     % ordinal - stored in some CtgMat subclass that establishes ranking relations between categories
        NUM (3)     % default numeric. stored as DOUBLE PRECISION float
        BIT (4)     %    binary digit logical one or zero
        R32 (5)     %(?) SINGLE PRECISION float (R for real)
        R64 (6)     %(?) DOUBLE PRECISION float (R for real)
        C32 (7)     %    single complex (takes up 64 bits of memory)
        C64 (8)     %    double complex (takes up 128 bits of memory)
        Z32 (9)     %(?) int32 (Z for positive/negative integers)
        Z64 (10)    %(?) int64 or 'long' (Z for positive/negative integers)
        N32 (11)    %    uint32 (N for Natural)
        N64 (12)    %    uint64 (N for Natural)
        
        STR (13)    % string - stored in cellstr
        DAT (14)    % date time stored as int64 array (unix time stamp) same as 'long' but displayed as date.
        ARR (15)    % numeric array - STORED IN A DATA TYPE I HAVEN'T INVENTED YET - maybe a numeric matrix
        LST (16)    % a list - STORED IN A DATA TYPE I HAVEN'T INVENTED YET - a cell of vectors
    end

%     methods (Static = true)
%         % Do not put the methods in this classdef file - not allowed for
%         % enumerations. Must be outside with the signatures listed here.
%         COL_TYPE.display(a); % displays '<TYPE> (<id>)', e.g. 'GEN (0)', works on matices too
%     end
    
end

