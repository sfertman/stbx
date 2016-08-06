function ii = subsindex( a )
% SUBSINDEX({a,b}) -- returns (a:b) - 1 
% SUBSINDEX({A,b}) -- returns vertcat(A(1):b, A(2):b, ... A(end):b)
% SUBSINDEX({a,B}) -- returns vertcat(a:B(1), a:B(2), ... a:B(end))
% SUBSINDEX({A,B}) -- returns vertcat(A(1):B(1), ... A(end):B(end))
assert(length(a) == 2, 'Beginning and end must be input.')
if isscalar(a) 
    if isscalar(b)
        ii = (a{1}:a{2}) - 1;
    else
        
    end
else
    if isscalar(b)
        
    else
        
    end
end    
    


end

