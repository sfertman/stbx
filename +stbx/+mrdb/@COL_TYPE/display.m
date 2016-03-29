function display(a)
[szr, szc] = size(a);
[A, ~, ia] = unique(a);
C = arrayfun(@(u) char(u) + ' (' + sprintf('%d',double(u)) + ')', A, 'UniformOutput', false);
disp(reshape(C(ia), szr, szc)); 
% the actuall disp takes the longest to print, all other functions work
% extremely well and extremely fast. unique gets slow when 'a' is larger 
% than 1e+7 members
end