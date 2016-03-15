paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

t = 0:0.01:1;
n = length(t);
n_groups = 3;
group_size = 20;
N = n_groups * group_size;

labels = reshape( repmat( 1:n_groups, group_size, 1 ) , 1, N);

freqs = [0.1, 0.5, 1, 2, 3, 10];

A = zeros(1, n, N); % Original Curves
X = zeros(1, n, N); % Copy of curves (pulled out of other code but redundant here)
X_2 = zeros(n, N); % Curve data reshaped for LRR

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
toc;

[W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), n_groups);
clusters_curve = condense_clusters(W_clusters,1);

tic;
Z = lrr_relaxed_lin(normalize(X_2), 1);
toc;

[Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), n_groups);
clusters_lrr = condense_clusters(Z_clusters,1);


Misclassification(labels', clusters_curve)
Misclassification(labels', clusters_lrr)