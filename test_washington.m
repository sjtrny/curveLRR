paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

load('data/washington.mat');

max_length = 250;

n_groups = 3;
group_size = 20;

N = n_groups * group_size;

labels = reshape(repmat(1:n_groups, group_size, 1), 1, N);

n_runs = 10;

missrate_curve = zeros(n_runs, 1);
missrate_lrr = zeros(n_runs, 1);
missrate_kmeans = zeros(n_runs, 1);
missrate_dtw = zeros(n_runs, 1);

runtime_curve = zeros(n_runs, 1);
runtime_lrr = zeros(n_runs, 1);
runtime_kmeans = zeros(n_runs, 1);
runtime_dtw = zeros(n_runs, 1);

inds = find(lengths <= max_length);
sub_classes = unique(ground_truth(inds));
cand_classes = intersect(sub_classes, find(class_totals >= 20));

for k = 1 : n_runs
    
    k
    
    X = zeros(4, max_length, N);
    X_data = zeros(max_length*4, N);
    
    cand_class_inds = randi(length(cand_classes), 3, 1);
    
    for i = 1 : n_groups
        % Get current class indices

        cur_class_inds = find(ground_truth == cand_classes(cand_class_inds(i)));

        % Pick up each n. from the class 

        group_inds = cur_class_inds(randi(length(cur_class_inds), group_size, 1));

        X(:,:, (i-1)*group_size + 1 : i*group_size) = curve_X(:,1:max_length, group_inds);
        
    end
    
    for i = 1 : N
        
        X_data(:,i) = reshape(X(:,:, i)', max_length*4, 1);
        
    end
    
    tic;
    W = curve_lrr(X, 10, 0.1);
    runtime_curve = toc;

    [W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), n_groups);
    clusters_curve = condense_clusters(W_clusters,1);
    missrate_curve(k, 1) = Misclassification(clusters_curve, labels');

    tic;
    Z = lrr_relaxed_lin(normalize(X_data), 1);
    runtime_lrr = toc;

    [Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), n_groups);
    clusters_lrr = condense_clusters(Z_clusters,1);
    missrate_lrr(k, 1) = Misclassification(clusters_lrr, labels');
    
    
    tic;
    idx = kmeans(X_data', n_groups);
    runtime_kmeans(k, 1) = toc;
    
    missrate_kmeans(k, 1) = Misclassification(idx, labels');
    
    tic;
    Z_dtw = get_dtw_Z(X);
    runtime_dtw(k, 1) = toc;

    [dtw_clusters, ~, ~] = ncutW(abs(Z_dtw) + abs(Z_dtw'), n_groups);
    clusters_dtw = condense_clusters(dtw_clusters,1);
    missrate_dtw(k, 1) = Misclassification(clusters_dtw, labels');
    
    
    
end



rmpath(paths);