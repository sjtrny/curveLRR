function [ labels ] = bayesian_clustering( X, n_cluster )
%BAYESIAN_CLUSTERING Summary of this function goes here
%   Detailed explanation goes here

N = size(X, 3);

W = zeros(N,N);

for i = 1 : N
    for j = i : N
        W(i,j) = GeodesicElasticClosedinner(X(:,:,i),X(:,:,j));
    end
end

W = W + W';

for i = 1 : N
    W(i,i) = 1;
end
 
[~,S,~] = svd(W);

for i=1:N
    ratio = sum(diag(S(1:i,1:i)))/sum(diag(S));
    if (ratio>0.95)
        d = i;
        break;
    end;
end;

% prior of theta
theta_vect = 0.2:0.2:1;
xi = 0.1;
r0 = 6/d;
s0 = 8/d;
iter = 1000;
% M = 10; %initial number of clusters

[labels, ~] = WishartCluster(d, theta_vect, r0, s0, xi, iter, n_cluster, W);


end
