function b = reduce( a )
warning('Use stbx.data.compress instead')
assert(iscellstr(a), 'cell/reduce supports cellstr types only.')
if isempty(a), 
    b = {}; 
elseif all(strcmpi(a{1}, a))
    b = a(1);
else
    b = {''};
end

end

