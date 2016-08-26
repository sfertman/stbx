function [varargout] = parseParams(varsin, paramToParse)
% PARSEPARAMS parses parameter-value pairs from inputs to a function. This
% is a more lightweight and simple version of Matlab's own input parser.
% It's very easy to use and proved to be quite useful in my projects. 
%
% paramToParse is a cell array where each of its elements is a 4 element
% cell array arranged in the following way:
%   {paramname, @assertfunc, err_msg, default_val}
%   where:
%   (+) paramname -- is the parameter's name.
%   (+) @assertfunc -- (optional) is a function used to assert input
%       correctness.
%   (+) err_asg -- (optional) is an error message to be displayed when an
%       input fails the assertion function assigned to it.
%   (+) default_val -- (optional) is parameter's default value which will
%       be assigned if the parameter was not found in list of input
%       arguments. 
%
% An empty placeholder ([],{},'', etc...) can be passed instead of any
% optional input. Parameters' names obviously cannot be left empty. For
% example, to NOT assert input parameter 'p1', pass an empty array in place
% of assertion function and message, like so: {'p1', [], [], def1}. 
% 
%
% Example of parsing three param-value pairs from function inputs:
%
%   function myfunc(varargin)
% 
%   [value1, value2, value3, varargin] = parseParams( varargin, {...
%         {'param1', @assertfunc1, 'err message 1', default_val1}, ...
%         {'param2', @assertfunc2, 'err message 2', default_val2}, ...
%         {'param3', @assertfunc3, 'err message 3', default_val3}, ...
%         });
%   
%   ...
%   ...
%   ...
%
%   end

% TODO: another option to consider is modifying this function to accept
% list of arguments (varargin) instead of a single cell, like so: 
%   function [varargout] = parseParams(varsin, varargin)
% So that we can call this function in sipler way:
%   [value1, value2, value3, varargin] = parseParams( varargin, ...
%         {'param1', @assertfunc1, 'err message 1', default_val1}, ...
%         {'param2', @assertfunc2, 'err message 2', default_val2}, ...
%         {'param3', @assertfunc3, 'err message 3', default_val3}, ...
%         );

% TODO: add an option to input only paprameter name without values at all
% like in unique(...,'rows') or unique(...,'rows','stable'). The result
% will be true if parameter exists and false otherwise.  

% defining error message generators
wrongAssertFunc = @(i,p) sprintf([ ...
    'Assertion function for parameter %d ("%s") returned something '...
    'which is not a logical scalar. Any assertion function must return '...
    'logical scalar!' ], i, p{i} );

genericAssertMsgFunc = @(i,p,f) sprintf(...
    'Parameter %d ("%s") does not qualify assertion fundtion: \n\t%s', ...
    i,p{i},char(f{i}));

% reading inputs
[pname, assertfun, errmsg, defaultval] = ...
    cellfun(@(u) deal(u{:}), paramToParse, 'UniformOutput', false);

% asserting inputs are correct
assert(all(cellfun(@(n) ischar(n) && ~isempty(n), pname)), ...
    'Parameter name(s) must be non-empty character array(s).')
assert(all(cellfun(@(f) isa(f,'function_handle') || isempty(f), assertfun)), ...
    'Assertion functions must be of type function_handle.');
assert(all(cellfun(@(em) ischar(em) || isempty(em), errmsg)), ...
    'Error messages must be of type char.');

% extracting parameters
varargout = cell(1, length(paramToParse) + 1); % 1 slot for each parameter and 1 for everything else
varsOutIdx = 1;
for i = 1:length(paramToParse)
    pIdx = find(strcmp(varsin, pname{i})); % find parameter name in list
    if ~isempty(pIdx)
        varargout{varsOutIdx} = varsin{pIdx + 1}; % the next input after the parameter tag
        if ~isempty(assertfun{i}) % if assertion function exists
            assertOK = assertfun{i}(varargout{varsOutIdx});
            if ~islogical(assertOK) || ~isscalar(assertOK)
                error(wrongAssertFunc(i, pname));
            elseif ~assertOK % if assertion failed
                if isempty(errmsg{i}) % error msg exists
                    errmsg_ = genericAssertMsgFunc(i, pname, assertfun);
                else
                    errmsg_ = errmsg{i};
                end
                throwAsCaller(MException('stbx:parseParams', errmsg_)) 
            end
        end
        % delete the processed parameter name and value from the input list
        varsin([pIdx,pIdx+1]) = []; 
    elseif ~isempty(defaultval{i})
        varargout{varsOutIdx} = defaultval{i};
    else
        varargout{varsOutIdx} = {};
    end
    varsOutIdx = varsOutIdx + 1;
end

% whatever left are the remaining inputs to the caller function
varargout{end} = varsin;

%%% ~~~666@@ The Pit of DooM @@666~~~
%{
Obsolete code -- the above is more readable
varargout = cell(1, length(paramToParse) + 1); % 1 slot for each parameter and 1 for everything else
varsOutIdx = 1;
for i = 1:length(paramToParse)
    pIdx = find(strcmp(varsin, paramToParse{i}{1})); % find parameter name in list
    if ~isempty(pIdx)
        varargout{varsOutIdx} = varsin{pIdx + 1}; % the next input after the parameter tag
        if ~isempty(paramToParse{i}{2}) % if assertion function exists
            assertOK = paramToParse{i}{2}(varargout{varsOutIdx});
            if ~islogical(assertOK) || ~isscalar(assertOK)
                error([ 
                    'Assertion function for parameter %d ("%s") returned '...
                    'something which is not a logical scalar. Any '...
                    'assertion function must return logical scalar!'], ...
                        i, paramToParse{i}{1} );
            elseif ~assertOK % if assertion failed
                if isempty(paramToParse{i}{3}) % error msg exists
                    errmsg = sprintf('Parameter "%s" does not qualify assertion fundtion: \n\t%s', ...
                        paramToParse{i}{1},char(paramToParse{i}{2}));
                else
                    errmsg = paramToParse{i}{3};
                end
                throwAsCaller(MException('stbx:parseParams', errmsg)) 
            end
            %{
            if ~isempty(paramToParse{i}{3}) 
 
                    assert(paramToParse{i}{2}(varargout{varsOutIdx}), paramToParse{i}{3});
            else % no assert error message was input
                % <TODO>
                % when reporting assertion failure,  report parameter name,
                % and printout assertion function
                % </TODO>
                errmsg = sprintf('Parameter "%s" does not qualify assertion fundtion: \n\t%s', ...
                    paramToParse{i}{1},char(f_));
                try
                    assert(paramToParse{i}{2}(varargout{varsOutIdx}), errmsg);
                catch e_
                    throwAsCaller(e_)
                end
            end
            %}
        end
        varsin = varsin([1:pIdx-1, pIdx+2:end]); % +2 because it's property name and value
    elseif ~isempty(paramToParse{i}{4})
        varargout{varsOutIdx} = paramToParse{i}{4};
    else
        varargout{varsOutIdx} = {};
    end
    varsOutIdx = varsOutIdx + 1;
end

varargout{end} = varsin;
end
%}