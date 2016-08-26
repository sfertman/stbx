function ii = subsindex( a )
% SUBSINDEX({a,b}) -- returns (a:b) - 1 
% SUBSINDEX({A,b}) -- returns vertcat(A(1):b, A(2):b, ... A(end):b) - 1
% SUBSINDEX({a,B}) -- returns vertcat(a:B(1), a:B(2), ... a:B(end)) - 1
% SUBSINDEX({A,B}) -- returns vertcat(A(1):B(1), ... A(end):B(end)) - 1
assert(length(a) == 2, 'Beginning and end must be input.')
assert(all(cellfun(@(u) isvector(u), a)), 'All inputs must be vectors. Do they really?? Not sure about that');
if isscalar(a{1}) 
    if isscalar(a{2})
        ii = (a{1}:a{2}) - 1;
    else
        ii = arrayfun(@(i) a{1}:a{2}(i), (1:length(a{2})).', 'UniformOutput', false);
        ii = vertcat(ii{:}) - 1;
    end
else
    if isscalar(a{2})
        ii = arrayfun(@(i) a{1}(i):a{2}, (1:length(a{1})).', 'UniformOutput', false);
        ii = vertcat(ii{:}) - 1;
    else
        L = length(a{1});
        assert(length(a{2}) == L, 'Length mismatch. Non-scalar arguments must be the same length.') 
        ii = arrayfun(@(i) a{1}(i):a{2}(i), (1:L).', 'UniformOutput', false);
        ii = vertcat(ii{:}) - 1;
    end
end    
    


end

