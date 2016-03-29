classdef wrn
    %%% class with all constant fields and no methods - a fancy way of
    %%% defining a structure to hold all my constants of a given group. In
    %%% this case we're talking about warnings that could be encountered
    %%% anywhere in my toobox (stbx)

    properties (Access = public, Constant = true)
        % make sure warning identifiers do not begin with a number!
        devsOnly = struct('identifier', {'stbx:commons:wrn999'}, 'message', {'Tread lightly for you have wandered into developer''s territory.'});
        
    end
    
    methods (Static = true)
    end
end