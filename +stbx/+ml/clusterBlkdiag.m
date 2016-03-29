function [ best_ordering, best_X ] = clusterBlkdiag( X )
% takes in a 2D matrix and rearranges it into block diagonal form.
error('broken, fix it')

max_iter = 1000;
n_variables = size(X,1);
current_ordering = 1:n_variables;
n_clusters = 5;
cluster_size = n_variables / n_clusters;
current_X = X;
current_score = dissimilarity(current_X);
for i = 1:max_iter
    % Find the best row swap to make
    best_X = current_X;
    best_ordering = current_ordering;
    best_score = current_score;

    for row1 = 1:n_variables
        for row2 = 1:n_variables
            if row1 == row2, continue; end

            option_ordering = best_ordering;

            option_ordering(row1) = best_ordering(row2);

            option_ordering(row2) = best_ordering(row1);

            option_X = swapVars(best_X, row1, row2);

            option_score = dissimilarity(option_X);

            if option_score < best_score
                best_X = option_X;
                best_ordering = option_ordering;
                best_score = option_score;
            end
        end
    end
    if best_score < current_score
        % Perform the best var swap

        current_X = best_X;
        current_ordering = best_ordering;
        current_score = best_score;
    else
        % No var swap found that improves the solution, we're done
        break
    end

end    

    
function score = dissimilarity(X)
    %{
    Function to assign a score to an ordered covariance matrix.
    High correlations within a cluster improve the score.
    High correlations between clusters decease the score.
    %}

    score = 0;
    %     for cluster in range(n_clusters):
    for ii = 1:n_clusters
        
        % inside_cluster = np.arange(cluster_size) + cluster * cluster_size
        inside_cluster = zeros(1,n_variables);
        inside_cluster((1:cluster_size) + (ii-1)*cluster_size) = 1;
        inside_cluster = logical(inside_cluster.'*inside_cluster);
        % outside_cluster = np.setdiff1d(range(n_variables), inside_cluster)
        outside_cluster = ~inside_cluster;
        
        
        %# Belonging to the same cluster
        % dissScore = dissScore + np.sum(C[inside_cluster, :][:, inside_cluster])
        score = score + sum(sum(X(logical(inside_cluster),:))) + sum(sum(X(:,logical(inside_cluster))));
%         score = score + sum(X(inside_cluster));
        
        %# Belonging to different clusters
        % score = score - np.sum(C[inside_cluster, :][:, outside_cluster]);
        score = score - sum(X(inside_cluster, :)(:, outside_cluster));

%         score = score + np.sum(C[outside_cluster, :][:, inside_cluster]);
    end
    dissScore = -score; 
    
end

end

% function dissScore = dissimilarity(X)
% dissScore = sum(sum((X(1:end-1, :) - X(2:end, :)).^2)) + ...
%             sum(sum((X(:, 1:end-1) - X(:, 2:end)).^2)) ;
% end



function X = swapVars(X, x1, x2)
% swap rows
r1 = X(x1, :);
X(x1, :) = X(x2, :);
X(x2, :) = r1;

% swap cols
c1 = X(:, x1);
X(:, x1) = X(:, x2);
X(:, x2) = c1;

end


