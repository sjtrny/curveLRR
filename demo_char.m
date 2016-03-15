paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

load data/mixoutALL_shifted.mat

% Pick 3 classes

groups = 3;
each = 10;
N = groups * each;

labels = reshape( repmat( 1:groups, each, 1 ) , 1, N);

r = randi([1, 20], 3, 1);

max_len = 0;
for k = 1 : 2858
    if size(mixout{1, k}, 2) > max_len
        max_len = size(mixout{1, k}, 2);
    end
end

X = zeros(2, max_len + 100, 30);
X_2 = zeros( (max_len + 100)*2, 30);


min_mean = 100;
max_mean = 100;
min_var = 50;
max_var = max_len;

for k = 1 : groups
    
    % Find all curves from class k in r
    candidates = find(consts.charlabels == r(k));
    
    % Pick 10 curves from class k
    cand_inds = randi(size(candidates,2), each, 1);
    
    for  j = 1 : each
        
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
        
        
        X(:,:, k*each - each + j) = final_data;
       
        
        X_2(:, k*each - each + j) = reshape( final_data, (max_len + 100)*2, 1);
        
    end
    
    
end

tic;
W = curve_lrr(X, 10, 0.1);
toc;

[W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), groups);
clusters_curve = condense_clusters(W_clusters,1);


tic;
Z = lrr_relaxed_lin(normalize(X_2), 0.1);
toc;

[Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), groups);
clusters_lrr = condense_clusters(Z_clusters,1);

Misclassification(labels', clusters_curve)
Misclassification(labels', clusters_lrr)