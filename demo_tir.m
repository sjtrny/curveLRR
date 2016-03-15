paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

load data/TIRlib

groups = 3;
each = 20;

N = groups * each;

labels = reshape( repmat( 1:groups, each, 1 ) , 1, N);

inds = [10, 50, 100];

X_orig = zeros(321, N);
X = zeros(1, 321, groups*each);
X_2 = zeros(321, N);

min_mean = 50;
max_mean = 250;
min_var = 50;
max_var = 175;

for i = 1 : groups
    
    
    for j = 1 : each
        
        X_orig(:,i*each - each + j) = A(:, inds(i));

        cur_mean = (max_mean - min_mean) * rand(1,1) + min_mean;
        cur_var = (max_var - min_var) * rand(1,1) + min_var;

        y = cdf(makedist('Normal',cur_mean,cur_var), 1:321);
        y = y - min(y);
        y = y / max(y);
        y = y * 320;
        y  = y+ 1;
        y = floor(y);
    
        X(:,:,i*each - each + j) = A(uint32(y), inds(i));


        X_2(:,i*each - each + j) = X(:,:,i*each - each + j)';
        
    end
    
    
end


tic;
W = curve_lrr(X, 10, 0.1);
toc;

[W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), groups);
clusters_curve = condense_clusters(W_clusters,1);


tic;
Z = lrr_relaxed_lin(normalize(X_2), 1);
toc;

[Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), groups);
clusters_lrr = condense_clusters(Z_clusters,1);

Misclassification(labels', clusters_curve)
Misclassification(labels', clusters_lrr)