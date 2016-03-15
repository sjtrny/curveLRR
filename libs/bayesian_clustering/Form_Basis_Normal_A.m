% This function returns the vector field that forms the basis
% for normal space of {\cal A}
function delG = Basis_Normal_A(q)
[n,T] = size(q);
e = eye(n);
for i = 1:n
    Ev(:,:,i) = repmat(e(:,i),1,T);
end

for t = 1:T
    qnorm(t) = norm(q(:,t));
end

for i = 1:n
    tmp1 = repmat(q(i,:)./qnorm,n,1);
    tmp2 = repmat(qnorm,n,1);
    delG{i} = tmp1.*q + tmp2.*Ev(:,:,i);    
end

return;