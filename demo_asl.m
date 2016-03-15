paths = [genpath('libs'), genpath('common'), genpath('curve_lrr')];
addpath(paths);

rng(1);

load('data/asl.mat');

groups = 3;
each = 3*9;
% each = 10;

N = groups * each;

labels = reshape( repmat( 1:groups, each, 1 ) , 1, N);

n_signs = length(signs);

clusters = randi(n_signs, groups, 1);

channels = 12:17;
% channels = [1:6, 12:17];
n_channels = length(channels);

g = gausswin(20);
g = g/sum(g);

X = zeros(n_channels, 136, N);

for i = 1 : groups
    
    offset = ( (clusters(i) - 1) * 27) + 1;

    inds = randi(27, each, 1) - 1;
    
    X(:,:, (i-1)*each + 1 : i*each) = curve_X(channels,:, offset + inds );
end

X_data = zeros(n_channels * 136, N);

for i = 1 : N
    
    X_data(:,i) = reshape(X(:,:, i)', n_channels*136, 1);
    
end


X_smooth = zeros(n_channels, 136, N);

for i = 1 : N
    X_smooth(:,:,i) = smtv(136, 1, {X(:,:,i)}, get_R(1, 136), 0.01, ones(1,1), {ones(1, 1360)}, 'aniso');
end

X_data_smooth = zeros(n_channels * 136, N);

for i = 1 : N
    
    X_data_smooth(:,i) = reshape(X_smooth(:,:, i)', n_channels*136, 1);
    
end


% tic;
% W = curve_lrr(X, 10, 0.1);
% toc;
% 
% [W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), groups);
% clusters_curve = condense_clusters(W_clusters,1);
% 
% 
% tic;
% Z = lrr_relaxed_lin(normalize(X_data), 0.1);
% toc;
% 
% [Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), groups);
% clusters_lrr = condense_clusters(Z_clusters,1);
% 
% Misclassification(Label', clusters_curve)
% Misclassification(Label', clusters_lrr)


tic;
W = curve_lrr(X_smooth(1:2,:,:), 10, 0.1);
toc;

[W_clusters, ~, ~] = ncutW(abs(W) + abs(W'), groups);
clusters_curve = condense_clusters(W_clusters,1);


tic;
Z = lrr_relaxed_lin(normalize(X_data_smooth), 1);
toc;

[Z_clusters, ~, ~] = ncutW(abs(Z) + abs(Z'), groups);
clusters_lrr = condense_clusters(Z_clusters,1);

Misclassification(labels', clusters_curve)
Misclassification(labels', clusters_lrr)
