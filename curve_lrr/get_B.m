function [ B ] = get_B( X )
%GET_B Summary of this function goes here
%   Detailed explanation goes here

    [m, n, N] = size(X);

    B = zeros(N, N, N);
    
    if exist('matlabpool','file') && matlabpool('size') == 0
        matlabpool open
    end
    
    % For each B_i
    parfor i = 1 : N
%         i
%         tic;
        V = zeros(m*n, N);
        for j = 1 : N
            
            a = inverse_exp(X(:,:,i), X(:,:,j))';
            
            V(:, j) = a(:);
        end
%         toc;
        
        B(:,:,i) = (V' * V)/n; 
        
    end
    
end

