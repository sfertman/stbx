function [varsout] = toggleVisibility( handles, state_onoff )
% STBX.PLOT.TOGGLEVISIBILITY -- The function does what it's named for:
% toggles visibility of graphical objects given by input handles. This is
% done by alternating the states of the 'Visible' property 'on' or
% 'off'. In case one or more handle is not a valid graphics object handle,
% the function will issue a warning and ignore the invalid ones.
%
% Use:
%   STBX.PLOT.TOGGLEVISIBILITY(handles) -- 
%   STBX.PLOT.TOGGLEVISIBILITY(hanles, state_onoff) --
%       state_onoff is either 'on' or 'off' or 1 or 0. If length == 1 then
%       all handles are assigned with the value; if length > 1 then we
%       assign one by one and 'state_onoff' must be equal in size to
%       'handles'.
%       
% Input: 
%   handles -- array of handles to graphics objects, if empty, nothing
%   happens
%   sate_onoff -- specify the desired state of all handles, one by one or
%   all together.
% 
% output: none
if nargin == 0
    help stbx.plot.toggleVisibility;
    return
end

varsout = [];

if isempty(handles), return; end

validHandles = handles(ishandle(handles));

if length(validHandles) ~= length(handles)
    warning('Ignoring invalid handles...');
end

if isempty(state_onoff)
    objVis = strcmpi(get(validHandles, 'Visible'), 'on');

    set(validHandles(objVis), 'Visible', 'off'); % render visible object invisible
    set(validHandles(~objVis), 'Visible', 'on'); % render invisible objects visible
elseif ischar(state_onoff) || iscellstr(state_onoff)
%     state_onoff = lower(state_onoff);
    % state_onof is just one element
    switch lower(state_onoff)
        case 'on'
            set(validHandles, 'Visible', 'on'); 
        case 'off'
            set(validHandles, 'Visible', 'off'); 
        otherwise
            error('''Visible'' property can accept only ''on'' or ''off'' values');
    end
    
else isnumeric(state_onoff) % anything that is gt zero counts as 1 everything else is counted as zero
    %//TODO: finish this
    
    
end
    

end

