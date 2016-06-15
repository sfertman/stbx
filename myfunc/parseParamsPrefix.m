function [varargout] = parseParamsPrefix(varsin, paramToParse)
% <TODO>
% parameter names should be made possible to define explicitely or by name
% and prefix (any length) + param name
% </TODO>
% paramToParse is a cell of 4 element cells:
%   paramToParse{i}{1} is parameter's name
%   paramToParse{i}{2} is parameter's assertion function
%   paramToParse{i}{3} is assertion error message (defaults msg: 'Parameter
%       does not qualify assertion rules.')
%   paramToParse{i}{4} is parameter's default value
%
% if any element is set to {}, it is considered empty and will result in
% default assignment/behavior.
% //TODO add some examples for future reference


varargout = cell(1, length(paramToParse) + 1); % 1 slot for each parameter and 1 for everything else
varsOutIdx = 1;
for ii = 1:length(paramToParse)
    % //TODO: shouldn't be the following???
    % pIdx = find(ischar(varsin) & strcmp(varsin, paramToParse{ii}{1})); % find parameter name in list
    pIdx = find(strcmp(varsin, paramToParse{ii}{1})); % find parameter name in list
    if ~isempty(pIdx)
        varargout{varsOutIdx} = varsin{pIdx + 1}; % the next input after the parameter tag
        if ~isempty(paramToParse{ii}{2})
            if ~isempty(paramToParse{ii}{3})
                assert(paramToParse{ii}{2}(varargout{varsOutIdx}), paramToParse{ii}{3});
            else % no assert error message was input
                assert(paramToParse{ii}{2}(varargout{varsOutIdx}), 'Input %d does not qualify assertion rules.', ii);
            end
        end
        varsin = varsin([1:pIdx-1, pIdx+2:end]); % +2 because it's property name and value
    elseif ~isempty(paramToParse{ii}{4})
        varargout{varsOutIdx} = paramToParse{ii}{4};
    else
        varargout{varsOutIdx} = {};
    end
    varsOutIdx = varsOutIdx + 1;
end

varargout{end} = varsin;
end