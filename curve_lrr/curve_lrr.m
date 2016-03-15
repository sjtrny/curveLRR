function [ W ] = curve_lrr( X, beta, lambda )
%CURVE_LRR Summary of this function goes here
%   Detailed explanation goes here

N = size(X, 3);

% tic;
B = get_B(X);
% toc;

DEBUG = 0;
rho = 1.9;

maxIter = 500;
tol1 = 1e-4;
tol2 = 1e-4;

omega = zeros(N,N);

[W, ~, ~] = grassmann_lrr(B, lambda, rho, beta, maxIter, tol1, tol2, DEBUG, omega);


end

