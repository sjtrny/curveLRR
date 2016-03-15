function [q2new,R] = Find_Best_Rotation(q1,q2)
% Assumes the starting points are fixed

[n,T] = size(q1);
A = q1*q2';
[U,S,V] = svd(A);
if det(A) > 0
    S = eye(n);
else
    S = eye(n);
    S(:,end) = -S(:,end);
end
R = U*S*V';
q2new = R*q2;