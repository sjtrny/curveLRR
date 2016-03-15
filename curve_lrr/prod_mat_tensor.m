function C = prod_mat_tensor(W, B)
% this function calculate product of a matrix W and a 3-order tensor B such 
% the i-th row of result matrix C is the product of i-th row of W and the 
% the i-th slice matrix B(:,:,i) of B

  [N, M] = size(W);
  WW = reshape(W', [M, 1, N]);  %Make it into a tensor
  C = sum(bsxfun(@times, WW, B),1);  %Which is in [1 M N];
  C = (reshape(C, [M, N]))';  %Each row is the gradient in the formula
end