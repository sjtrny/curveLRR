function [W, relChgW, recErr] = grassmann_lrr(B, lambda, rho, beta, maxIter, tol1, tol2, DEBUG, One_Omega)
% This matlab code implements linearized ADM method for Grassmann LRR problem
% inputs:
%        B -- N*N*N Tangent Trace matrix
% outputs:
%        W -- N*N representation matrix
%        relChgs --- relative changes
%        recErrs --- reconstruction errors
%
% created by Junbin Gao on 27 September 2014 based on LRR from Risheng Liu on 05/02/2011 

if nargin < 9
    One_Omega = [];
end
if nargin < 8
    DEBUG = 0;
end
if nargin < 7
    tol2 = 1e-8;
end
if nargin < 6
    tol1 = 1e-8;
end
if nargin < 5
   maxIter = 1000;
end
if nargin < 4
    beta = 0.1;
end
if nargin < 3
    rho = 1.9;
end
if nargin < 2
    lambda = 0.1;
end

 
[n1, n2, n3] = size(B);
opt.tol = tol2;  %precision for computing the partial SVD
opt.p0 = ones(n3,1);  
max_beta = 1e10;

eta_W = 0;
for i = 1:n3
    tmp = B(:,:, i);
    eta_W = max( norm(tmp,2), eta_W);
end
eta_W_1 = eta_W;
eta_W = 1.02*(eta_W + n3);

% One_Omega = zeros(n3, n3);
% for i = 1:size(Omega)
%     One_Omega(Omega(i,1), Omega(i,2)) = 1;
% end

% norm2X = norm(X,2);
% mu = 1e2*tol2;
% mu = min(d,n)*tol2;

%eta = norm2X*norm2X*1.02;%eta needs to be larger than ||X||_2^2, but need not be too large.

%% Initializing optimization variables
% intialize
W = rand(n3,n3)/n3^2;
W = zeros(n3,n3);
Y1 = zeros(n3,1);
Y2 = zeros(n3,n3);  
sv = 5;
svp = sv;


%% Start main loop
convergenced = 0;
iter = 0;

if DEBUG
    disp(['initial,rank(W)=' num2str(rank(W))]);
end

while iter<maxIter
    iter = iter + 1;
    
    %copy W to compute the change in the solutions 
    Wk = W;
    
    %-----------Using PROPACK--------------%
    M = Wk - (prod_mat_tensor(Wk, B) + (Y1  + beta*(sum(Wk,2) - 1)) * ones(1,n3) + Y2.*One_Omega + beta * Wk.*One_Omega)/(eta_W*beta) ;
    
    %[U, S, V] = lansvd(M, n, n, sv, 'L', opt);
    %[U, S, V] = lansvd(M, n, n, sv, 'L');
    [U, S, V] = svd(M,'econ');
      
    S = diag(S);
    svp = length(find(S> (lambda/(eta_W*beta))));
    if svp < sv
        sv = min(svp + 1, n3);
    else
        sv = min(svp + round(0.05*n3), n3);
    end
    
    if svp>=1
        S = S(1:svp)-lambda/(beta*eta_W);
    else
        svp = 1;
        S = 0;
    end

    A.U = U(:, 1:svp);
    A.s = S;
    A.V = V(:, 1:svp);
    
    W = A.U*diag(A.s)*A.V';

    diffW = norm(Wk - W,'fro');
    
    relChgW = diffW/eta_W_1;
    %relChg = max(relChgZ,relChgE);

    dY = W*ones(n3,1) - ones(n3,1);
    recErr = norm(dY,'fro')/eta_W_1;
    
    convergenced = recErr <tol1 && relChgW < tol2;
    
    if DEBUG
        if iter==1 || mod(iter,5)==0 || convergenced
            disp(['iter ' num2str(iter) ',beta=' num2str(beta) ...
                ',rank(W)=' num2str(svp)  ...
                ',recErr=' num2str(recErr) ',relChgW = ' num2str(relChgW)]);
        end
    end
    if convergenced 
        break;
    else
     
        Y1 = Y1 + beta*dY;
        Y2 = Y2 + beta*Wk.*One_Omega; 
        if beta*relChgW < tol2
            beta = min(max_beta, beta*rho);
        end
    end
end
