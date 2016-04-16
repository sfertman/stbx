stbx.ml.knn(randi(1e15,1000000,1),3,'sort');


return


X = randi(1e6,20,1);
abs2X = sum(X.^2,2); % sqaure of amplitude of X
[~, iX]  = sort(abs2X); % Xs = X(iX) transforms to sorted order
Xs = X(iX,:);
[N,I] = stbx.ml.knn(X,3,'sort');

% <TODO> try an arrow plot from X(i) to every neighbour to visualize more
% clearly what's going on here </TODO>
f = figure; ax = newplot; set(ax,'NextPlot','add');
plot(ax, X(:,1), X(:,2), '.'); % plot raw data
plot(ax, N(:,1,1),N(:,2,2), 'sq') % plot 1st neighbour
% plot(ax, N(:,2), 'dr') % plot 2nd neighbour
% plot(ax, N(:,3), 'og') % plot 3rd neighbour
% plot(ax, N(:,4), '^m') % plot 4th neighbour
return
for i=1:1000
    stbx.ml.knn(randi(1e15,10000,1),3,'sorted');
end