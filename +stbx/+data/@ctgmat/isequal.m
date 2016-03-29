function tf = isequal(a,b)
% stbx.ctgmat.eq
% Compares two inpout ctgmat objects 'a' and 'b' for equality. Unlike
% convensional Matlab eq function behaviour, matrices that have NaN members
% can still be compared.
% 
% a and b are equal if:
%   They are equal in size (all dimensions)
%   Their maps - encoding of categories into numerical codes - are the same
%   The non-NaN members of both matrices are equal
%   The locations of NaNs within both matrices are the same

if all(size(a) ~= size(b));% size equality test
    tf = false; % if fails return false
elseif ~eq(a.ctg_map, b.ctg_map); % equality of maps test ('==' might not be defined for this class, maybe use isequal instead)
    tf = false; % if fails return false
else
    nansidx = isnan(a.num_mat(:)); % nans locations in a
    if ~empty(nansidx) 
        if any(~isnan(b.num_mat(nansidx))) % a and b nans location equality test
            tf = false; % if fails return false
        elseif any(a.num_mat(~nansidx) ~= b.num_mat(~nansidx)) % non-NaN member equality test (actual codes)
            tf = false; % if fails return false
        end
    % if no nans were found, perform equality test on each member    
    elseif any(a.num_mat(:) ~= b.num_mat(:)) % non-NaN member equality test (actual codes)
        tf = false; % if fails return false
    else 
        % if we reached so far, it means that all previous if statements
        % were no true, a and b are equal were NaNs do not appear 
        tf = true; % assign 'true' as output and finish program
    end
end

%{
%%%------------------------------------------------------------

if all(size(a) ~= size(b));% size equality test
    tf = false;
    return;
end

if ~eq(a.ctg_map, b.ctg_map); % equality of maps test
    tf = false;
    return;
end

% a_nansidx = find(isnan(a.num_mat(:))); % nans locations in a
% b_nansidx = find(isnan(a.num_mat(:))); % nans locations in a
nansidx = isnan(a.num_mat(:)); % nans locations in a
if ~empty(nansidx) 
    if any(~isnan(b.num_mat(nansidx))) % a and b nans location equality test
        tf = false;
        return;
    end
    if any(a.num_mat(nansidx) ~= b.num_mat(nansidx)) % non-NaN member equality test (actual codes)
        tf = false;
        return
    end
% if no nans were found, perform equality test on each member    
elseif any(a.num_mat(:) ~= b.num_mat(:)) % non-NaN member equality test (actual codes)
    tf = false;
    return
end

% if we reached so far, it means that all previous if statements have
% failed and a and b are equal

tf = true; % assign 'true' as output and finish program

end


%}