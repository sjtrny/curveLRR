paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

load('data/washington.mat');

max_length = 250;
inds = find(lengths <= max_length);
sub_classes = unique(ground_truth(inds));

groups = 3;
each = 20;

N = groups * each;

labels = reshape( repmat( 1:groups, each, 1 ) , 1, N);

cand_classes = intersect(sub_classes, find(class_totals >= 20));

cand_class_inds = randi(length(cand_classes), 3, 1);

X = zeros(4, max_length, N);

for i = 1 : groups
    % Get current class indices
    
    cur_class_inds = find(ground_truth == cand_classes(cand_class_inds(i)));

    % Pick up each n. from the class 
    
    group_inds = cur_class_inds(randi(length(cur_class_inds), each, 1));
    
    X(:,:, (i-1)*each + 1 : i*each) = curve_X(:,1:max_length, group_inds);
    
end

X_data = zeros(max_length*4, N);

for i = 1 : 60
    
    X_data(:,i) = reshape(X(:,:, i)', max_length*4, 1);
    
end

tic;
W = curve_lrr(X, 10, 0.1);
toc;

[W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), groups);
clusters_curve = condense_clusters(W_clusters,1);


tic;
Z = lrr_relaxed_lin(normalize(X_data), 1);
toc;

[Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), groups);
clusters_lrr = condense_clusters(Z_clusters,1);

Misclassification(labels', clusters_curve)
Misclassification(labels', clusters_lrr)