function clmap = clmap_thermal( N )
persistent map_thermal

if isempty(map_thermal)
    map_thermal = load('map_thermal.mat');
    map_thermal = map_thermal.map_thermal;
end

if ~exist('N', 'var')
    clmap = map_thermal;
else
    clmap = zeros(N,3);
    N0 = size(map_thermal,1);
    clmap(:,1) = linterp(1:N0, map_thermal(:,1), linspace(1,N0,N));
    clmap(:,2) = linterp(1:N0, map_thermal(:,2), linspace(1,N0,N));
    clmap(:,3) = linterp(1:N0, map_thermal(:,3), linspace(1,N0,N));
    % <TODO>
    %   (-) get rid of linterp, this function needs to be independent
    % </TODO>
end

end

