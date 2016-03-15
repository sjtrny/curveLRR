function [ Z ] = get_dtw_Z( X )
%GET_DTW_Z Summary of this function goes here
%   Detailed explanation goes here

n = size(X, 2);
window = n * 0.1;

N = size(X, 3);

Z = zeros(N);

for i = 1 : N
    for j = 1 : N
        
        Z(i, j) = dtw_c(X(:,:,i)', X(:,:,j)', window);
        
    end
end


end

