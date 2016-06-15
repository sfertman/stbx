%# This generates 100 variables that could possibly be assigned to 5 clusters

n_variables = 100;
n_clusters = 5;
n_samples = 1000;

%# To keep this example simple, each cluster will have a fixed size
cluster_size = n_variables / n_clusters;

%# Assign each variable to a cluster

% belongs_to_cluster = np.repeat(range(n_clusters), cluster_size);
% belongs_to_cluster = np.repeat(1:n_clusters, cluster_size)
belongs_to_cluster = repmat(1:n_clusters, [cluster_size, 1]);
belongs_to_cluster = belongs_to_cluster(:).';



shuffleIdx = randperm(length(belongs_to_cluster));
belongs_to_cluster = belongs_to_cluster(shuffleIdx);
% ^ np.random.shuffle(belongs_to_cluster)

%# This latent data is used to make variables that belong
%# to the same cluster correlated.

% latent = np.random.randn(n_clusters, n_samples)
latent = randn(n_samples, n_clusters);

tic
variables = zeros(n_samples, n_variables);
for i_var = 1:n_variables
    variables(:, i_var) = randn(n_samples, 1) + latent(:, belongs_to_cluster(i_var));
    % ^ variables.append( np.random.randn(n_samples) + latent[belongs_to_cluster[i], :])
    
end
toc
% variables = np.array(variables) % converts from list to array in python
% -- no need here

C = cov(variables);
% ^ C = np.cov(variables)

%%
f = figure; set(f,'Renderer', 'zbuffer')
ax = newplot;
imagesc(C); axis square;
title('Unclustered original')
set(ax,'YDir','reverse');
colorbar
%%
tic
[nn, XX] = stbx.ml.clusterBlkdiag(C);
toc
%%
f = figure; set(f,'Renderer', 'zbuffer')
ax = newplot;
imagesc(XX); axis square;
title('Block-diagonal clustered')
set(ax,'YDir','reverse');
colorbar
