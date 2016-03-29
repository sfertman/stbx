classdef err
    %%% class with all constant fields and no methods - a fancy way of
    %%% defining a structure to hold all my constants of a given group. In
    %%% this case we're talking about errors that could be encountered
    %%% anywhere in my toobox (stbx)
    
    properties (Access = public, Constant = true)
        %%% make sure error identifiers do not begin with a number!
        underConstruction = struct('identifier', {'stbx:commons:err999'}, 'message', {'This feature is not yet implemented.'})
        superunknown = struct('identifier', {'stbx:comons:err998'}, 'message', {'This should not be happening... Some debugging must be done.'})
        
    end
    
    methods (Static = true)
    end
end

