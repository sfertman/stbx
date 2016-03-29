clear all
A = magic(5);
A = {'a','b','c','d','e','f','gh','ijk'};
A = A(:); L = length(A);
S = {[1,2,3].'; 5; [6,7].'; (1:5).'};
% S = {logical([1,0,1,0,0,0,0,0])};
% S = repmat(S, [30000/4,1]);
S = {floor(length(A)*rand(3e4,1))+1};
S = cellfun(@(~) randi(L, randi(L,1),1) ,num2cell((1:8e3).'), 'UniformOutput', false); length(vertcat(S{:}))
% cellsubsref_(A,S)
a = stbx.arr.cellsubsref(A,S);
tic 
for i = 1:100
    a = stbx.arr.cellsubsref(A,S);
end
toc