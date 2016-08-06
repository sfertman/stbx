function [varargout] = parseParams(varsin, paramToParse)
% PARSEPARAMS parses parameter-value pairs from inputs to a function. This
% is a more lightweight and simple version of Matlab's own input parser.
% It's very easy to use and proved to be quite useful in my projects. 
%
% <TODO>
%   (-) improve documentation for this file and publish to github
% </TODoO>
% paramToParse is a cell of 4 element cells:
%   paramToParse{i}{1} is parameter's name
%   paramToParse{i}{2} is parameter's assertion function
%   paramToParse{i}{3} is assertion error message (defaults msg: 'Parameter
%       does not qualify assertion rules.')
%   paramToParse{i}{4} is parameter's default value
%
% if any element is set to {}, it is considered empty and will result in
% default assignment/behavior.
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
%

varargout = cell(1, length(paramToParse) + 1); % 1 slot for each parameter and 1 for everything else
varsOutIdx = 1;
for i = 1:length(paramToParse)
    % //TODO: shouldn't be the following???
    % pIdx = find(ischar(varsin) & strcmp(varsin, paramToParse{ii}{1})); % find parameter name in list
    pIdx = find(strcmp(varsin, paramToParse{i}{1})); % find parameter name in list
    if ~isempty(pIdx)
        varargout{varsOutIdx} = varsin{pIdx + 1}; % the next input after the parameter tag
        if ~isempty(paramToParse{i}{2})
            if ~isempty(paramToParse{i}{3})
                assert(paramToParse{i}{2}(varargout{varsOutIdx}), paramToParse{i}{3});
            else % no assert error message was input
                % <TODO>
                % when reporting assertion failure,  report parameter name,
                % and printout assertion function
                % </TODO>
                assert(paramToParse{i}{2}(varargout{varsOutIdx}), 'Parameter %d does not qualify assertion rules.', i);
            end
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