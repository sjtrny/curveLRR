paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

load('data/chars74k.mat');

n_groups = 3;
group_size = 20;

N = n_groups * group_size;

labels = reshape(repmat(1:n_groups, group_size, 1), 1, N);

n_runs = 50;

missrate_curve = zeros(n_runs, 1);
missrate_lrr = zeros(n_runs, 1);
missrate_kmeans = zeros(n_runs, 1);
missrate_dtw = zeros(n_runs, 1);
missrate_bayes = zeros(n_runs, 1);

runtime_curve = zeros(n_runs, 1);
runtime_lrr = zeros(n_runs, 1);
runtime_kmeans = zeros(n_runs, 1);
runtime_dtw = zeros(n_runs, 1);
runtime_bayes = zeros(n_runs, 1);

for k = 1 : n_runs
    
    k
    
    inds = randi(n_chars, 3, 1);

    X = zeros(2, 365, N);

    for i = 1 : n_groups

        offset = ( (inds(i) - 1) * n_samples) + 1;

        group_inds = randi(n_samples, group_size, 1) - 1 + offset;

        X(:,:, (i-1)*group_size + 1 : i*group_size) = curve_X(:,:, group_inds);

    end

    X_data = zeros(365*2, N);

    for i = 1 : 60

        X_data(:,i) = reshape(X(:,:, i)', 365*2, 1);

    end
    
    
    tic;
    W = curve_lrr(X, 10, 0.1);
    runtime_curve(k, 1) = toc;

    [W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), n_groups);
    clusters_curve = condense_clusters(W_clusters,1);
    missrate_curve(k, 1) = Misclassification(clusters_curve, labels');

    tic;
    Z = lrr_relaxed_lin(normalize(X_data), 1);
    runtime_lrr(k, 1) = toc;

    [Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), n_groups);
    clusters_lrr = condense_clusters(Z_clusters,1);
    missrate_lrr(k, 1) = Misclassification(clusters_lrr, labels');
    
    tic;
    try
        idx = kmeans(X_data', n_groups);
    catch
        idx = zeros(N, 1);
    end
    runtime_kmeans(k, 1) = toc;
    
    missrate_kmeans(k, 1) = Misclassification(idx, labels');
    
    tic;
    Z_dtw = get_dtw_Z(X);
    runtime_dtw(k, 1) = toc;

    [dtw_clusters, ~, ~] = ncutW(abs(Z_dtw) + abs(Z_dtw'), n_groups);
    clusters_dtw = condense_clusters(dtw_clusters,1);
    missrate_dtw(k, 1) = Misclassification(clusters_dtw, labels');
    
    tic;
    try
        clusters_bayes = bayesian_clustering(X, n_groups);
    catch
        clusters_bayes = zeros(1, N);
    end
    runtime_bayes(k, 1) = toc;
    missrate_bayes(k, 1) = Misclassification(clusters_bayes', labels');
    
end

save(['results_' mfilename]);

rmpath(paths);