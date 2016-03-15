paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

t = 0:0.01:1;
n = length(t);

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

freqs = [0.1, 0.5, 1, 2, 3, 10];
% freqs = [1, 2, 3];

for k = 1 : n_runs
    
    k
    
    % Generate Data
    A = zeros(1, n, N);
    X = zeros(1, n, N);
    X_2 = zeros(n, N);

    power = 1:1:group_size;
    
    freq_inds = randsample(length(freqs), 3);
    
    for i = 1 : n_groups
        
        for j = 1 : group_size
            
            A(:,:,i*group_size - group_size + j) =   sin(2*freqs(freq_inds(i))*pi*(t.^(power(j))))';

            X(:,:,i*group_size - group_size + j) = A(:,:,i*group_size - group_size + j);

            X_2(:, i*group_size - group_size + j) = X(:,:,i*group_size -group_size + j)';
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

% 
% plotClusters(clusters_lrr)
% set(gcf,'PaperPositionMode','auto')
% set(gcf,'renderer','opengl');
% print(gcf, '-depsc2', 'syn_seg_lrr.eps');
% 
% plotClusters(clusters_curve)
% set(gcf,'PaperPositionMode','auto')
% set(gcf,'renderer','opengl');
% print(gcf, '-depsc2', 'syn_seg_curve.eps');

% figure, plot(X_2(:,1:20)); xlim([0, 100]);
% print(gcf, '-depsc2', 'syn_cluster_1.eps');
% figure, plot(X_2(:,21:40)); xlim([0, 100]);
% print(gcf, '-depsc2', 'syn_cluster_2.eps');
% figure, plot(X_2(:,41:60)); xlim([0, 100]);
% print(gcf, '-depsc2', 'syn_cluster_3.eps');
% close all