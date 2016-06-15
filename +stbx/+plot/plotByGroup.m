function h = plotByGroup( varargin )
% PLOTBYGROUP Summary of this function goes here
% <TODO>
% - all the following input cases should be covered
%   - PLOTBYGROUP(X,Y,G)
%   - PLOTBYGROUP(Y,G)
%   - PLOTBYGROUP(X,Y,S,G)
%   - PLOTBYGROUP(AX,...)
%   - PLOTBYGROUP(..., P1, V1, P2, V2, ...) param/val pair cellfun expanded
%     or must be equal in length to number of groups.
% - additional parameters ('#paramname' : {*val1|val2|val3} where *denotes
%   default behavior)
%   - '#datalabels' : {true|*false} ; {0|*~=0}; {'on'|*'off'}; {user input}
%     - datalabels are generated automatically from grouping vars values
%     - if '#datalabels' is 'on' then a UI button is added to toggle
%     visibility of labes. If 'off' no text is added. 
%     - datalabels can be input by user (cellstr length must be equal to
%       the number of groups).
%   - '#legend' : {true|*false} ; {0|*~=0}; {'on'|*'off'}; {user input}
%     - labels is generated automatically from grouping vars values
%     - legend can be input by use (cellstr length must be equal to number
%       of groups).
% </TODO>

end

