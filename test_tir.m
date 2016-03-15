paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);


rng(1);

load 'data/TIRlib'

n = 321;

n_groups = 3;
group_size = 20;

N = n_groups * group_size;

labels = reshape(repmat(1:n_groups, group_size, 1), 1, n_groups * group_size);

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

inds = [10, 50, 100];

min_mean = 50;
max_mean = 250;
min_var = 50;
max_var = 175;

for k = 1 : n_runs
    
    k
    
    % Generate Data
    X_orig = zeros(n, N);
    X = zeros(1, n, N);
    X_2 = zeros(n, N);
    
    for i = 1 : n_groups


        for j = 1 : group_size

            X_orig(:,i*group_size - group_size + j) = A(:, inds(i));

            cur_mean = (max_mean - min_mean) * rand(1,1) + min_mean;
            cur_var = (max_var - min_var) * rand(1,1) + min_var;

            y = cdf(makedist('Normal',cur_mean,cur_var), 1:321);
            y = y - min(y);
            y = y / max(y);
            y = y * 320;
            y  = y+ 1;
            y = floor(y);

            X(:,:,i*group_size - group_size + j) = A(uint32(y), inds(i));


            X_2(:,i*group_size - group_size + j) = X(:,:,i*group_size - group_size + j)';

        end


    end

    tic;
    W = curve_lrr(X, 10, 0.1);
    runtime_curve(k, 1) = toc;

    [W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), n_groups);
    clusters_curve = condense_clusters(W_clusters,1);
    missrate_curve(k, 1) = Misclassification(clusters_curve, labels');

    tic;
    Z = lrr_relaxed_lin(normalize(X_2), 1);
    runtime_lrr(k, 1) = toc;

    [Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), n_groups);
    clusters_lrr = condense_clusters(Z_clusters,1);
    missrate_lrr(k, 1) = Misclassification(clusters_lrr, labels');
    
    tic;
    idx = kmeans(X_2', n_groups);
    runtime_kmeans(k, 1) = toc;
    
    missrate_kmeans(k, 1) = Misclassification(idx, labels');
    
    tic;
    Z_dtw = get_dtw_Z(X);
    runtime_dtw(k, 1) = toc;

    [dtw_clusters, ~, ~] = ncutW(abs(Z_dtw) + abs(Z_dtw'), n_groups);
    clusters_dtw = condense_clusters(dtw_clusters,1);
    missrate_dtw(k, 1) = Misclassification(clusters_dtw, labels');
    
    tic;
    clusters_bayes = bayesian_clustering(X, n_groups);
    runtime_bayes(k, 1) = toc;
    missrate_bayes(k, 1) = Misclassification(clusters_bayes', labels');

end

save(['results_' mfilename]);

rmpath(paths);


% plotClusters(clusters_lrr)
% set(gcf,'PaperPositionMode','auto')
% set(gcf,'renderer','opengl');
% print(gcf, '-depsc2', 'tir_seg_lrr.eps');
% 
% plotClusters(clusters_curve)
% set(gcf,'PaperPositionMode','auto')
% set(gcf,'renderer','opengl');
% print(gcf, '-depsc2', 'tir_seg_curve.eps');

% figure, plot(X_2(:,1:20)); xlim([0 321]);
% print(gcf, '-depsc2', 'tir_cluster_1.eps');
% 
% figure, plot(X_2(:,21:40)); xlim([0 321]);
% print(gcf, '-depsc2', 'tir_cluster_2.eps');
% 
% figure, plot(X_2(:,41:60)); xlim([0 321]);
% print(gcf, '-depsc2', 'tir_cluster_3.eps');
% 
% figure, plot(A(:,inds)); xlim([0 321]);
% print(gcf, '-depsc2', 'tir_base_curves.eps');