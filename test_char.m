paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

load 'data/mixoutALL_shifted.mat'

n_groups = 3;
group_size = 10;

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


min_mean = 100;
max_mean = 100;
min_var = 50;


for k = 1 : n_runs
    
    k
    
    % Generate Data
    r = randi([1, 20], 3, 1);

    max_len = 0;
    for b = 1 : 2858
        if size(mixout{1, b}, 2) > max_len
            max_len = size(mixout{1, b}, 2);
        end
    end

    X = zeros(2, max_len + 100, 30);
    X_2 = zeros( (max_len + 100)*2, 30);
    
    max_var = max_len;
    
    for i = 1 : n_groups
    
        % Find all curves from class k in r
        candidates = find(consts.charlabels == r(i));

        % Pick 10 curves from class k
        cand_inds = randi(size(candidates,2), 10, 1);

        for  j = 1 : group_size

            % Select curve j
            cand_data = mixout{1, candidates( cand_inds(j) )};

            % Do some local warping
            cur_mean = (max_mean - min_mean) * rand(1,1) + min_mean;
            cur_var = (max_var - min_var) * rand(1,1) + min_var;

            y = cdf(makedist('Normal',cur_mean,cur_var), 1:size(cand_data, 2));
            y = y - min(y);
            y = y / max(y);
            y = y * (size(cand_data, 2)-1);
            y  = y+ 1;
            y = floor(y);

            warped_data = cand_data(:, uint32(y));

            % Scale it horizontally (always smaller than original)
            scale_hor = randi(50);

            hor_scaled = resample(warped_data', 50 + scale_hor, 100)';

            % Scale it vertically

            scale_ver = randn(1,1);

            ver_scaled = hor_scaled * (scale_ver / 100);

            % Pad to 196 length curve
            padded_data = [ver_scaled(1:2, :), zeros(2, max_len - size(ver_scaled, 2))];

            % Shift each curve
            final_data = zeros(2, max_len + 100);
            shift = randi(100) - 50;

            final_data(:, 51 + shift : 50 + shift + max_len) = padded_data;


            X(:,:, i*group_size - group_size + j) = final_data;


            X_2(:, i*group_size - group_size + j) = reshape( final_data', (max_len + 100)*2, 1);

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

% 
% plotClusters(clusters_lrr)
% set(gcf,'PaperPositionMode','auto')
% set(gcf,'renderer','opengl');
% print(gcf, '-depsc2', 'char_seg_lrr.eps');
% 
% plotClusters(clusters_curve)
% set(gcf,'PaperPositionMode','auto')
% set(gcf,'renderer','opengl');
% print(gcf, '-depsc2', 'char_seg_curve.eps');

% figure, plot(X_2(1:max_len+100,1:10)); xlim([0 305]);
% print(gcf, '-depsc2', 'char_cluster_x_1.eps');
% 
% figure, plot(X_2(max_len+101:(max_len + 100)*2,1:10)); xlim([0 305]);
% print(gcf, '-depsc2', 'char_cluster_y_1.eps');
% 
% figure, plot(X_2(1:max_len+100,11:20)); xlim([0 305]);
% print(gcf, '-depsc2', 'char_cluster_x_2.eps');
% 
% figure, plot(X_2(max_len+101:(max_len + 100)*2,11:20)); xlim([0 305]);
% print(gcf, '-depsc2', 'char_cluster_y_2.eps');
% 
% figure, plot(X_2(1:max_len+100,21:30)); xlim([0 305]);
% print(gcf, '-depsc2', 'char_cluster_x_3.eps');
% 
% figure, plot(X_2(max_len+101:(max_len + 100)*2,21:30)); xlim([0 305]);
% print(gcf, '-depsc2', 'char_cluster_y_3.eps');



rmpath(paths);