paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

load('data/asl.mat');

n_groups = 3;
group_size = 3*9;

N = n_groups * group_size;

labels = reshape(repmat(1:n_groups, group_size, 1), 1, N);

n_runs = 50;

missrate_curve = zeros(n_runs, 1);
missrate_lrr = zeros(n_runs, 1);
missrate_kmeans = zeros(n_runs, 1);
missrate_dtw = zeros(n_runs, 1);
missrate_bayes = zeros(n_runs, 1);

missrate_curve_smooth = zeros(n_runs, 1);
missrate_lrr_smooth = zeros(n_runs, 1);
missrate_kmeans_smooth = zeros(n_runs, 1);
missrate_dtw_smooth = zeros(n_runs, 1);
missrate_bayes_smooth = zeros(n_runs, 1);


runtime_curve = zeros(n_runs, 1);
runtime_lrr = zeros(n_runs, 1);
runtime_kmeans = zeros(n_runs, 1);
runtime_dtw = zeros(n_runs, 1);
runtime_bayes = zeros(n_runs, 1);

runtime_curve_smooth = zeros(n_runs, 1);
runtime_lrr_smooth = zeros(n_runs, 1);
runtime_kmeans_smooth = zeros(n_runs, 1);
runtime_dtw_smooth = zeros(n_runs, 1);
runtime_bayes_smooth = zeros(n_runs, 1);


n_signs = length(signs);
channels = 12:17;

n_channels = length(channels);

g = gausswin(20);
g = g/sum(g);

X = zeros(n_channels, 136, N);
X_data = zeros(n_channels * 136, N);
X_smooth = zeros(n_channels, 136, N);
X_data_smooth = zeros(n_channels * 136, N);

for k = 1 : n_runs
    
    k
    
    class_inds = randi(n_signs, n_groups, 1);
    
    for i = 1 : n_groups
    
        offset = ( (class_inds(i) - 1) * 27) + 1;

        inds = randi(27, group_size, 1) - 1;

        X(:,:, (i-1)*group_size + 1 : i*group_size) = curve_X(channels,:, offset + inds );
        
    end
    
    for i = 1 : N
        
        X_data(:,i) = reshape(X(:,:, i)', n_channels*136, 1);
        X_smooth(:,:,i) = smtv(136, 1, {X(:,:,i)}, get_R(1, 136), 0.01, ones(1,1), {ones(1, 1360)}, 'aniso');
        X_data_smooth(:,i) = reshape(X_smooth(:,:, i)', n_channels*136, 1);
        
    end
    
    
    % Normal data
    tic;
    W = curve_lrr(X, 10, 0.1);
    runtime_curve(k, 1) = toc;

    [W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), n_groups);
    clusters_curve = condense_clusters(W_clusters,1);
    missrate_curve(k, 1) = Misclassification(clusters_curve, labels');

    tic;
    Z = lrr_relaxed_lin(normalize(X_data), 0.1);
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
    
    % Smoothed data
    tic;
    W_smooth = curve_lrr(X_smooth, 10, 0.1);
    runtime_curve_smooth(k, 1) = toc;

    [W_clusters_smooth, ~, ~] = ncutW(abs(W_smooth) + abs(W_smooth'), n_groups);
    clusters_curve_smooth = condense_clusters(W_clusters_smooth,1);
    missrate_curve_smooth(k, 1) = Misclassification(clusters_curve_smooth, labels');

    tic;
    Z_smooth = lrr_relaxed_lin(normalize(X_data_smooth), 1);
    runtime_lrr_smooth(k, 1) = toc;

    [Z_clusters_smooth, ~, ~] = ncutW(abs(Z_smooth) + abs(Z_smooth'), n_groups);
    clusters_lrr_smooth = condense_clusters(Z_clusters_smooth,1);
    missrate_lrr_smooth(k, 1) = Misclassification(clusters_lrr_smooth, labels');
    
    tic;
    try
        idx_smooth = kmeans(X_data_smooth', n_groups);
    catch
        idx_smooth = zeros(N, 1);
    end
    runtime_kmeans_smooth(k, 1) = toc;
    tic;
    
    missrate_kmeans_smooth(k, 1) = Misclassification(idx_smooth, labels');
    
    tic;
    Z_dtw_smooth = get_dtw_Z(X_smooth);
    runtime_dtw_smooth(k, 1) = toc;

    [dtw_clusters_smooth, ~, ~] = ncutW(abs(Z_dtw_smooth) + abs(Z_dtw_smooth'), n_groups);
    clusters_dtw_smooth = condense_clusters(dtw_clusters_smooth,1);
    missrate_dtw_smooth(k, 1) = Misclassification(clusters_dtw_smooth, labels');
    
    tic;
    clusters_bayes_smooth = bayesian_clustering(X_smooth, n_groups);
    runtime_bayes_smooth(k, 1) = toc;
    missrate_bayes_smooth(k, 1) = Misclassification(clusters_bayes_smooth', labels');
    
    tic;
    try
        clusters_bayes_smooth = bayesian_clustering(X_smooth, n_groups);
    catch
        clusters_bayes_smooth = zeros(1, N);
    end
    runtime_bayes_smooth(k, 1) = toc;
    missrate_bayes_smooth(k, 1) = Misclassification(clusters_bayes_smooth', labels');
    
end

save(['results_' mfilename]);

rmpath(paths);